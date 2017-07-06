(*
 * Copyright (C) 2013-2016 Richard Mortier <mort@cantab.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

open Lwt.Infix

let err fmt = Fmt.kstrf failwith fmt

module Main
    (S: Cohttp_lwt.Server)
    (ASSETS: Mirage_types_lwt.KV_RO)
    (DECKS: Mirage_types_lwt.KV_RO)
= struct

  let http_src = Logs.Src.create "http" ~doc:"HTTP server"
  module Http_log = (val Logs.src_log http_src : Logs.LOG)

  let size_then_read ~pp_error ~size ~read device name =
    size device name >>= function
    | Error e -> err "%a" pp_error e
    | Ok size ->
      read device name 0L size >>= function
      | Error e -> err "%a" pp_error e
      | Ok bufs -> Lwt.return (Cstruct.copyv bufs)

  let assets_read =
    size_then_read ~pp_error:ASSETS.pp_error ~size:ASSETS.size ~read:ASSETS.read

  let decks_read =
    size_then_read ~pp_error:DECKS.pp_error ~size:DECKS.size ~read:DECKS.read

  let respond_ok ?mime_type ~path body_lwt =
    body_lwt >>= fun body ->
    let mime_type = match mime_type with
      | None -> Magic_mime.lookup path
      | Some mime_type -> mime_type
    in
    let headers = Cohttp.Header.init () in
    let headers = Cohttp.Header.add headers "content-type" mime_type in
    S.respond_string ~status:`OK ~body ~headers ()

  let dispatcher assets decks cid uri =
    let path = Uri.path uri in
    Http_log.info (fun f -> f "[%s] request '%s'" cid path);

    Lwt.catch (fun () -> assets_read assets path |> respond_ok ~path)
      (function
        | Failure e -> (
            Http_log.debug (fun f ->
                f "[%s] not an asset, trying decks! [%s]" cid e
              );

            let cpts = Astring.String.cuts ~empty:false ~sep:"/" path in
            match cpts with
            | [] | [""] ->
              Http_log.info (fun f -> f "root [/]");
              Slides.index ()
              |> respond_ok ~path:"/index.html"
            | deck :: [] ->
              Http_log.info (fun f -> f "deck [%s]" deck);
              Slides.deck ~readf:(decks_read decks) ~deck
              |> respond_ok ~mime_type:"text/html" ~path
            | deck :: asset :: [] ->
              Http_log.info (fun f -> f "deck/asset [%s/%s]" deck asset);
              Slides.asset ~readf:(decks_read decks) ~deck ~asset
              |> respond_ok ~path
            | _ ->
              Http_log.info (fun f -> f "[%s] not found [%s]" cid path);
              S.respond_not_found ~uri ()
          )
        | e -> Lwt.fail e
      )

  let start http assets decks =
    Logs.(set_level (Some Info));

    let callback (_, cid) request _body =
      let uri = Cohttp.Request.uri request in
      let cid = Cohttp.Connection.to_string cid in
      Http_log.info (fun f -> f "[%s] serving [%s]" cid (Uri.to_string uri));
      dispatcher assets decks cid uri
    in
    let conn_closed (_, cid) =
      let cid = Cohttp.Connection.to_string cid in
      Http_log.info (fun f -> f "[%s] closing" cid);
    in
    let port = Key_gen.port () in
    Http_log.info (fun f -> f "listening on %d/TCP" port);

    http (`TCP port) @@ S.make ~conn_closed ~callback ()

end
