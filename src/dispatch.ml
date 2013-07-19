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
  | Slides of Slides.deck
  | Dynamic of (path:string -> req:C.Request.t -> string)
  | Unknown of string

let handler_to_string = function
  | Static s -> sprintf "Static(%s)" s
  | Slides d -> sprintf "Slides(%s ~ %s)" d.Slides.permalink d.Slides.slides
  | Dynamic f -> sprintf "Dynamic()"
  | Unknown s -> sprintf "Unknown(%s)" s

let resolve path = 
  let urls = 
    [ ( [ ""; "/" ], Dynamic Slides.index ) ]
    @ (List.map (fun (p, h) -> ([p], Static h)) Reveal.urls)
    @ (List.map (fun p -> (["/" ^ p.Slides.permalink], Slides p)) Slides.decks)
  in
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
    | Some x -> return x 
  in
  (* determine if it is static or dynamic content *)
  match_lwt static#read ("/static" ^ path) with
  | Some body ->
     lwt body = string_of_stream body in
     CL.Server.respond_string ~status:`OK ~body ()
  | None -> 
      let h = resolve path in
      printf "[dispatch] '%s' -> %s\n%!" path (handler_to_string h);
      match h with
        | Static filename -> 
            (static#read filename >>= function
              | Some b ->
                  lwt body = string_of_stream b in
                  CL.Server.respond_string ~status:`OK ~body ()
              | None -> not_found req
            )
        
        | Dynamic handler -> 
            let body = handler path req in
            CL.Server.respond_string ~status:`OK ~body ()
        
        | Slides deck -> 
            lwt body = Slides.render req static deck in
            CL.Server.respond_string ~status:`OK ~body ()
        | Unknown _ -> not_found req
        
