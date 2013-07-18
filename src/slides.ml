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
    sprintf "<%s>\
  %s\
  </%s>" (String.concat " " ([ tag; id; cl ] @ literals)) body tag

  let html = wrap "html"
  let head ?cl ?id ?literals body = wrap "head" ?cl:None ?id:None ?literals:None body
  
  let body = wrap "body"

  let title = wrap "title"
  let div = wrap "div"

  let ul = wrap "ul"
  let li = wrap "li"
  
  let link ?cl ?id u s = wrap "a" ~literals:[ (sprintf "href='%s'" u) ] s
end

type presentation = {
  permalink: string;
  given: date;
  speakers: Atom.author list;
  venue: string;
  title: string;
  slides: string;
}

let presentations = [
  { permalink = "oscon13";
    given = date (2013, 07, 18);
    speakers = [People.mort; People.anil];
    venue = "OSCON 2013";
    title = "Mirage at OSCON 2013";
    slides = "oscon13.md";
  };
]

let exists x = 
  List.exists (fun e -> x = "/slides/" ^ e.permalink) presentations

let index ~(path:string) ~(req:Cohttp.Request.t) = 
  Html.(
    "<!doctype html>\n"
    ^ (html 
         (head 
            ("<meta charset='utf-8'>\n"
             ^ title "Mirage Presentations :: Index"
            ))
       ^ (body 
            (ul
               (String.concat "\n" 
                  (List.map (fun p -> li (link p.permalink p.title)) 
                     presentations))
            )
       )
    )
  )

let render fs content = 
  "rednered"


(*


open Cow
open Printf
open Lwt



let render preso = 

(*       <link rel='stylesheet' href='../css/reveal.min.css'>*)

  
  
  

(*
 ^ <:html<
    <body>
      <div class="reveal">
        <div class="slides">
          $str:slide.slides$
        </div>
      </div>
      
      <script src="../lib/js/head.min.js"></script>
      <script src="../js/reveal.min.js"></script>
      <script>
        Reveal.initialize();
      </script>
    </body>
>> >|= Html.to_string
 *)

(** *)
  
let t = function
  | [] -> Html.html_t, index_page
(*
| ["atom.xml"] -> ["content-type","application/atom+xml; charset=UTF-8"], atom_feed
*)
  | x -> 
      let page = 
        try
          List.find (fun e -> e.permalink = x) presentations |> render
        with Not_found -> Pages.not_found [x]
      in
      Html.html_t, page

 *)
