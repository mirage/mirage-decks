open Cow
open Lwt
open Printf

module CL = Cohttp_lwt_mirage
module C = Cohttp

open Unix_files

type date = {
  year: int;
  month: int;
  day: int;
} with xml

let date (year, month, day) = { year; month; day }

module Html = struct

  let html_t = ["content-type", "text/html"]
  let atom_t = ["content-type", "application/atom+xml; charset=UTF-8"]
  let octets_t = ["content-type", "application/octet-stream"]
  
  let wrap ?(cl="") ?(id="") ?(literals=[]) tag body =
    let cl = match cl with "" -> "" | s -> sprintf "class='%s'" s in
    let id = match id with "" -> "" | s -> sprintf "id='%s'" s in
    sprintf "<%s>\n\
  %s\n\
  </%s>\n" (String.concat " " ([ tag; id; cl ] @ literals)) body tag

  let html = wrap "html" ~literals:["lang=en"]
  let head ?cl ?id ?literals body = wrap "head" ?cl:None ?id:None ?literals:None body
  
  let body = wrap "body"

  let title = wrap "title"
  let div = wrap "div"

  let ul = wrap "ul"
  let li = wrap "li"
  
  let link ?cl ?id u s = wrap "a" ~literals:[ (sprintf "href='%s'" u) ] s
end

type deck = {
  permalink: string;
  given: date;
  speakers: Atom.author list;
  venue: string;
  title: string;
  assets: string list;
}

let decks = [
  { permalink = "fb13";
    given = date (2013, 11, 14);
    speakers = [People.anil];
    venue = "Facebook HQ";
    title = "MirageOS: compiling functional library operating systems";
    assets = [ "arch2.png";
               "modules1.png";
               "modules2.png";
               "modules3.png";
               "uniarch1a.png";
               "uniarch1b.png";
               "uniarch1c.png";
               "uniarch1d.png";
               "architecture.png"; "rwo.jpg";
               "block-storage.png";
               "boot-time.png";
               "cothreads.png";
               "deens-performance.png";
               "dns-all.png";
               "dns-baseline.png";
               "dns-deens.png";
               "green-arrow.png";
               "key-insight.png";
               "kloc.png";
               "memory-model.png";
               "openflow-controller.png";
               "red-arrow.png";
               "scaling-instances.png";
               "specialisation.png";
               "thread-scaling.png";
               "threat-model-dom0.png";
               "threat-model.png";
               "vapps-current.png";
               "vapps-specialised-1.png";
               "vapps-specialised-2.png";
               "vapps-specialised-3.png";
               "zero-copy-io.png";
             ];
  };
 
  { permalink = "qcon13";
    given = date (2013, 11, 11);
    speakers = [People.anil];
    venue = "QCon 2013";
    title = "MirageOS: developer tools of tomorrow";
    assets = [ "arch2.png";
               "modules1.png";
               "modules2.png";
               "modules3.png";
               "uniarch1a.png";
               "uniarch1b.png";
               "uniarch1c.png";
               "uniarch1d.png";
               "architecture.png"; "rwo.jpg";
               "block-storage.png";
               "boot-time.png";
               "cothreads.png";
               "deens-performance.png";
               "dns-all.png";
               "dns-baseline.png";
               "dns-deens.png";
               "green-arrow.png";
               "key-insight.png";
               "kloc.png";
               "memory-model.png";
               "openflow-controller.png";
               "red-arrow.png";
               "scaling-instances.png";
               "specialisation.png";
               "thread-scaling.png";
               "threat-model-dom0.png";
               "threat-model.png";
               "vapps-current.png";
               "vapps-specialised-1.png";
               "vapps-specialised-2.png";
               "vapps-specialised-3.png";
               "zero-copy-io.png";
             ];
  };
 
  { permalink = "xensummit13";
    given = date (2013, 10, 25);
    speakers = [People.anil; People.jon];
    venue = "XenSummit 2013";
    title = "MirageOS and XAPI 2013 Project Update";
    assets = [ "arch2.png";
               "modules1.png";
               "modules2.png";
               "modules3.png"; "uniarch.png"; "jon-smallbw1.jpg";
               "architecture-xapi-project.png";
               "architecture.png";
               "block-storage.png";
               "boot-time.png";
               "cothreads.png";
               "deens-performance.png";
               "dns-all.png";
               "dns-baseline.png";
               "dns-deens.png";
               "green-arrow.png";
               "key-insight.png";
               "kloc.png";
               "memory-model.png";
               "openflow-controller.png";
               "red-arrow.png";
               "scaling-instances.png";
               "specialisation.png";
               "thread-scaling.png";
               "threat-model-dom0.png";
               "threat-model.png";
               "vapps-current.png";
               "vapps-specialised-1.png";
               "vapps-specialised-2.png";
               "vapps-specialised-3.png";
               "zero-copy-io.png";
             ];
  };
  { permalink = "oscon13";
    given = date (2013, 07, 26);
    speakers = [People.mort; People.anil];
    venue = "OSCON 2013";
    title = "Mirage: Extreme Specialisation of Cloud Appliances";
    assets = [ "arch2.png";
               "block-storage.png";
               "boot-time.png";
               "cothreads.png";
               "deens-performance.png";
               "dns-all.png";
               "dns-baseline.png";
               "dns-deens.png";
               "green-arrow.png";
               "key-insight.png";
               "kloc.png";
               "memory-model.png";
               "openflow-controller.png";
               "red-arrow.png";
               "scaling-instances.png";
               "specialisation.png";
               "thread-scaling.png";
               "threat-model-dom0.png";
               "threat-model.png";
               "vapps-current.png";
               "vapps-specialised-1.png";
               "vapps-specialised-2.png";
               "vapps-specialised-3.png";
               "zero-copy-io.png";
             ];
  };
  { permalink = "jslondon13";
    given = date (2013, 08, 29);
    speakers = [People.anil];
    venue = "Jane Street London 2013";
    title = "My Other Internet is a Mirage";
    assets = [ "arch2.png";
               "block-storage.png";
               "boot-time.png";
               "cothreads.png";
               "deens-performance.png";
               "dns-all.png";
               "dns-baseline.png";
               "dns-deens.png";
               "green-arrow.png";
               "key-insight.png";
               "kloc.png";
               "memory-model.png";
               "openflow-controller.png";
               "red-arrow.png";
               "scaling-instances.png";
               "specialisation.png";
               "thread-scaling.png";
               "threat-model-dom0.png";
               "threat-model.png";
               "vapps-current.png";
               "vapps-specialised-1.png";
               "vapps-specialised-2.png";
               "vapps-specialised-3.png";
               "zero-copy-io.png";
             ];
  };
  { permalink = "foci13";
    given = date (2013, 08, 12);
    speakers = [People.anil];
    venue = "FOCI 2013";
    title = "Lost in the Edge: Finding Your Way with Signposts";
    assets = [ "nat.png"; "arch.png" ];
  };

]

let exists x = 
  List.exists (fun e -> x = "/slides/" ^ e.permalink) decks

let index ~(path:string) ~(req:Cohttp.Request.t) = 
  let title p = p.title ^ " (" ^ p.venue ^ ")" in
  Html.(
    "<!doctype html>\n"
    ^ (html 
         ((head 
             ("<meta charset='utf-8'>\n"
              ^ title "Mirage Decks :: Index"
             ))
          ^ (body 
               (ul
                  (String.concat "\n" 
                     (List.map (fun p -> li (link (p.permalink ^ "/") p.title)) 
                        decks))
               ))
         ))
    )

let string_of_stream s = Lwt_stream.to_list s >|= Cstruct.copyv

let slides path fs deck = 
  let template s vs = 
    (* XXX. grim hack. abstract this. *)
    let title_re = Re_str.regexp "{{ title }}" in
    let replaced = Re_str.replace_first title_re deck.title s in
    replaced
  in

  lwt h = match_lwt fs#read Reveal.header with
    | Some b -> string_of_stream b
    | None -> failwith "[slides] render: header"
  in 
  lwt f = match_lwt fs#read Reveal.footer with
    | Some b -> string_of_stream b
    | None -> failwith "[slides] render: footer"
  in 
  let path = "/slides" ^ path ^ "index.html" in
  printf "[slides] path:'%s'\n%!" path;
  lwt content = match_lwt fs#read path with
    | Some b -> string_of_stream b
    | None -> failwith "[slides] render: content"
  in 
  let body = (template h deck) ^ content ^ f in
  CL.Server.respond_string ~status:`OK ~body ()

let asset path fs deck = 
  let path = "/slides" ^ path in
  printf "[asset] path:'%s'\n%!" path;
  lwt body = match_lwt fs#read path with
    | Some b -> string_of_stream b
    | None -> failwith "[slides] render: asset"
  in 
  let headers = C.Header.of_list Html.octets_t in
  CL.Server.respond_string ~headers ~status:`OK ~body ()

