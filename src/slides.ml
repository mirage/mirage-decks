open Cow
open Lwt
open Printf

type date = {
  year: int;
  month: int;
  day: int;
} with xml

let date (year, month, day) = { year; month; day }

module Html = struct

  let html_t = ["content-type","text/html"]
  let html_t = ["content-type","application/atom+xml; charset=UTF-8"]
  
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
}

let decks = [
  { permalink = "revealjs";
    given = date (1970, 01, 01);
    speakers = [];
    venue = "";
    title = "Reveal.js sample";
  };
  { permalink = "oscon13";
    given = date (2013, 07, 18);
    speakers = [People.mort; People.anil];
    venue = "OSCON 2013";
    title = "Mirage at OSCON 2013";
  };
]

let exists x = 
  List.exists (fun e -> x = "/slides/" ^ e.permalink) decks

let index ~(path:string) ~(req:Cohttp.Request.t) = 
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
                     (List.map (fun p -> li (link p.permalink p.title)) 
                        decks))
               ))
         ))
    )

let render req fs deck = 
  let string_of_stream s =
    Lwt_stream.to_list s >|= Cstruct.copyv
  in
  lwt h = match_lwt fs#read Reveal.header with
    | Some b -> string_of_stream b
    | None -> failwith "[slides] render: header"
  in 
  lwt f = match_lwt fs#read Reveal.footer with
    | Some b -> string_of_stream b
    | None -> failwith "[slides] render: footer"
  in 
  let path = "/slides/" ^ deck.permalink ^ "/index.html" in
  printf "[slides] path:'%s'\n%!" path;
  lwt content = match_lwt fs#read path with
    | Some b -> string_of_stream b
    | None -> failwith "[slides] render: content"
  in 
  return (h ^ content ^ f)
(*
  in 
  lwt f = fs#read Reveal.footer >>= function
    | Some b -> string_of_stream b
    | None -> failwith "[slides] render: footer"
  in 
  lwt content = fs#read deck.slides >>= function
    | Some b -> string_of_stream b
    | None -> failwith ("[slides] render: content: " ^ deck.slides)
  in

  [h; content; f]
 *)
