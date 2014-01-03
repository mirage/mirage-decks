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

open Mirage

let assets =
  Driver.KV_RO {
    KV_RO.name = "assets";
    dirname    = "../assets";
  }

let slides =
  Driver.KV_RO {
    KV_RO.name = "slides";
    dirname    = "../slides";
  }

let ip = 
   let open IP in 
   let address = Ipaddr.V4.of_string_exn "46.43.42.134" in
   let netmask = Ipaddr.V4.of_string_exn "255.255.255.128" in
   let gateway = [Ipaddr.V4.of_string_exn "46.43.42.129" ] in
   let config = IPv4 { address; netmask; gateway } in
   { name = "www4"; config; networks = [ Network.Tap0 ] } 

let http =
  Driver.HTTP {
    HTTP.port  = 80;
    address    = None;
    ip
  }

let () =
  add_to_opam_packages ["cow"; "cowabloga"];
  add_to_ocamlfind_libraries ["cow.syntax"; "cowabloga"];

  Job.register [
    "Server.Main", [Driver.console; assets; slides; http]
  ]
