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

module type HTTP = Cohttp_lwt.Server

let https_src = Logs.Src.create "https" ~doc:"HTTPS server"
module Https_log = (val Logs.src_log https_src : Logs.LOG)

let http_src = Logs.Src.create "http" ~doc:"HTTP server"
module Http_log = (val Logs.src_log http_src : Logs.LOG)

let log_info s = Http_log.info (fun f -> f "%s" s)

module Main
    (CLOCK: V1.CLOCK) (S: HTTP) (ASSETS: V1_LWT.KV_RO) (DECKS: V1_LWT.KV_RO)
= struct

  module Logs_reporter = Mirage_logs.Make(CLOCK)

  let dispatcher cid read_asset read_deck uri =
    let respond_ok ?mime_type ~path body_lwt =
      body_lwt >>= fun body ->
      Http_log.info (fun f -> f "[%s] ok [%s]" cid path);
      let mime_type = match mime_type with
        | None -> Magic_mime.lookup path
        | Some mime_type -> mime_type
      in
      let headers = Cohttp.Header.init () in
      let headers = Cohttp.Header.add headers "content-type" mime_type in
      S.respond_string ~status:`OK ~body ~headers ()
    in

    let path = Uri.path uri in
    Lwt.catch (fun () -> read_asset path |> respond_ok ~path)
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
              Slides.deck ~readf:read_deck ~deck
              |> respond_ok ~mime_type:"text/html" ~path
            | deck :: asset :: [] ->
              Http_log.info (fun f -> f "deck/asset [%s/%s]" deck asset);
              Slides.asset ~readf:read_deck ~deck ~asset
              |> respond_ok ~path
            | _ ->
              Http_log.info (fun f -> f "[%s] not found [%s]" cid path);
              S.respond_not_found ~uri ()
          )
        | e -> Lwt.fail e
      )

  let read_asset kv_ro asset =
    ASSETS.size kv_ro asset >>= function
    | `Error (ASSETS.Unknown_key _) ->
      Lwt.fail (Failure ("asset size " ^ asset))
    | `Ok size ->
      ASSETS.read kv_ro asset 0 (Int64.to_int size) >>= function
      | `Error (ASSETS.Unknown_key _) ->
        Lwt.fail (Failure ("asset read " ^ asset))
      | `Ok bufs -> Lwt.return (Cstruct.copyv bufs)

  let read_deck kv_ro deck =
    DECKS.size kv_ro deck >>= function
    | `Error (DECKS.Unknown_key _) -> Lwt.fail (Failure ("deck size " ^ deck))
    | `Ok size ->
      DECKS.read kv_ro deck 0 (Int64.to_int size) >>= function
      | `Error (DECKS.Unknown_key _) -> Lwt.fail (Failure ("deck read " ^ deck))
      | `Ok bufs -> Lwt.return (Cstruct.copyv bufs)

  let start _clock http assets decks =
    Logs.(set_level (Some Info));
    Logs_reporter.(create () |> run) @@ fun () ->

    let callback (_, cid) request _body =
      let uri = Cohttp.Request.uri request in
      let cid = Cohttp.Connection.to_string cid in
      Http_log.info (fun f -> f "[%s] serving [%s]" cid (Uri.to_string uri));
      let read_deck = read_deck decks in
      dispatcher cid (read_asset assets) read_deck uri
    in
    let conn_closed (_, cid) =
      let cid = Cohttp.Connection.to_string cid in
      Http_log.info (fun f -> f "[%s] closing" cid);
    in
    let port = Key_gen.port () in
    Http_log.info (fun f -> f "listening on %d/TCP" port);

    http (`TCP port) (S.make ~conn_closed ~callback ())

end
