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

open Mirage_types.V1

open Lwt

let (>>>) x f =
  x >>= function
  | `Error _ -> failwith "error"
  | `Ok x    -> f x


module Main (C: CONSOLE) (FS: KV_RO) (Server: Cohttp_lwt.Server) = struct

  let respond_string body =
    Server.respond_string ~status:`OK ~body ()

  let start c fs http =

    let callback conn_id ?body req =
      let path = Uri.path (Server.Request.uri req) in
      C.log_s c (Printf.sprintf "Got a request for %s\n" path) >>= fun () ->
      FS.size fs path                    >>> fun s ->
      FS.read fs path 0 (Int64.to_int s) >>> fun v ->
      let r = String.concat "" (List.map Cstruct.to_string v) in
      respond_string r
    in

    let conn_closed conn_id () =
      Printf.eprintf "conn %s closed\n%!" (Cohttp.Connection.to_string conn_id)
    in

    let spec = {
      Server.callback;
      conn_closed;
    } in
    http spec

end
