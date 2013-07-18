(** based off mirage-skeleton/static_website *)

open Printf
open Lwt

module CL = Cohttp_lwt_mirage
module C = Cohttp

let string_of_stream s =
  Lwt_stream.to_list s >|= Cstruct.copyv

(* handle exceptions with a 500 *)
let exn_handler exn =
  let body = Printexc.to_string exn in
  eprintf "HTTP: ERROR: %s\n" body;
  return ()

let rec remove_empty_tail = function
  | [] | [""] -> []
  | hd::tl -> hd :: remove_empty_tail tl

let not_found req =
  CL.Server.respond_not_found ~uri:(CL.Request.uri req) ()

type handler = 
  | Static of string
  | Dynamic of (path:string -> req:C.Request.t -> string)
  | Unknown of string

let one ~(path:string) ~(req:C.Request.t) = "ONEONEXXXXXXONE"

let urls = [
  ( [ ""; "/" ], Static "index.html" );
  ( [ "/one" ], Dynamic one);
]

let urlmap path = 
  try
    let (_, f) = 
      List.find (fun (ps, _) -> List.exists (fun p -> path=p) ps) urls 
    in
    f
  with Not_found -> Unknown path
  

(* main callback function *)
let t conn_id ?body req =
  let path = Uri.path (CL.Request.uri req) in
  let path_elem =
    remove_empty_tail (Re_str.(split_delim (regexp_string "/") path))
  in
  lwt static =
    eprintf "finding the static kv_ro block device\n";
    OS.Devices.find_kv_ro "static" >>=
    function
    | None   -> Printf.printf "fatal error, static kv_ro not found\n%!"; exit 1
    | Some x -> return x in

  (* determine if it is static or dynamic content *)
  match_lwt static#read path with
  | Some body ->
     lwt body = string_of_stream body in
     CL.Server.respond_string ~status:`OK ~body ()
  | None -> match urlmap path with
      | Static filename -> 
          (static#read filename >>= function
            | Some b ->
                lwt body = string_of_stream b in
                CL.Server.respond_string ~status:`OK ~body ()
            | None -> not_found req
          )
      | Dynamic handler -> 
          let page = handler path req in
          CL.Server.respond_string ~status:`OK ~body:page ()
      | Unknown _ -> not_found req
