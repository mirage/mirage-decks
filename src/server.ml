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

module Main
  (C: CONSOLE) (ASSETS: KV_RO) (SLIDES: KV_RO) (S: Cohttp_lwt.Server) = struct

  let start c assets slides http =
    let read_assets name =
      ASSETS.size assets name >>= function
      | `Error (ASSETS.Unknown_key _) ->
        fail (Failure ("read_assets_size " ^ name))
      | `Ok size ->
        ASSETS.read assets name 0 (Int64.to_int size) >>= function
        | `Error (ASSETS.Unknown_key _) ->
          fail (Failure ("read_assets " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let read_slides name =
      SLIDES.size slides name >>= function
      | `Error (SLIDES.Unknown_key _) ->
        fail (Failure ("read_slides_size " ^ name))
      | `Ok size ->
        SLIDES.read slides name 0 (Int64.to_int size) >>= function
        | `Error (SLIDES.Unknown_key _) ->
          fail (Failure ("read_slides " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let c_log s = C.log_s c s in

    let callback conn_id ?body req =
      Site.dispatch ~c_log ~read_assets ~read_slides ~conn_id ~req
    in

    let conn_closed conn_id () =
      (* XXX shouldn't i be able to use the Console logging here?
            C.log_s c (sp "conn %s closed\n%!" (Cohttp.Connection.to_string conn_id))
      *)
      Printf.printf "conn %s closed\n%!" (Cohttp.Connection.to_string conn_id)
    in

    let spec = {
      S.callback;
      conn_closed;
    } in
    http spec

end
