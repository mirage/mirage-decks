(*
 * Copyright (c) 2013 Richard Mortier <mort@cantab.net>
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

open Lwt
module S = Cohttp_mirage.Server
module C = Console

let (|>) x f = f x
let sp = Printf.sprintf

let dynamic read_slides req path =
  Printf.(
    eprintf "DISPATCH: %s\n%!"
      (sprintf "[ %s ]"
         (String.concat "; " (List.map (fun c -> sprintf "'%s'" c) path))
      ));

  let respond_ok body =
    lwt body = body in
    S.respond_string ~status:`OK ~body ()
  in
  match path with
  | [] | [""] ->
    Slides.index ~req ~path |> respond_ok
  | deck :: [] ->
    Slides.deck read_slides ~deck |> respond_ok
  | deck :: asset :: [] ->
    Slides.asset read_slides ~deck ~asset |> respond_ok
  | x -> S.respond_not_found ~uri:(S.Request.uri req) ()


let dispatch ~c_log ~read_assets ~read_slides ~conn_id ~req =
  let path = req |> S.Request.uri |> Uri.path in
  let cpts = path
             |> Re_str.(split_delim (regexp_string "/"))
             |> List.filter (fun e -> e <> "")
  in
  c_log (sp "URL: '%s'" path)
  >>
  try_lwt
    read_assets path >>= fun body ->
    S.respond_string ~status:`OK ~body ()
  with
  | Failure m ->
    Printf.printf "CATCH: '%s'\n%!" m;
    dynamic read_slides req cpts
