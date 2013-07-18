open Cow
open Printf
open Lwt

module Html = struct

  let html_t = ["content-type","text/html"]
  let html_t = ["content-type","application/atom+xml; charset=UTF-8"]
  
  let wrap ?(cl="") ?(id="") ?(literals=[]) tag body =
    let cl = match cl with "" -> "" | s -> sprintf "class='%s'" s in
    let id = match id with "" -> "" | s -> sprintf "id='%s'" s in
    sprintf "<%s>\
  %s\
  </%s>" (String.concat " " [ tag; cl; id ]) body tag

  let html = wrap "html"
  let head ?cl ?id ?literals body = wrap "head" ?cl:None ?id:None ?literals:None body
  
  let body ?cl ?id ?literals body = 
    lwt b = Pages.file_template body >|= Markdown.of_string >|= Markdown.to_html in
    wrap "body" ?cl:None ?id:None ?literals:None (Html.to_string b)

  let title = wrap "title"
  let div = wrap "div"
end

type presentation = {
  permalink: string;
  updated: Wiki.date;
  author: Atom.author;
  venue: string;
  title: string;
  slides: string;
}

let date = Wiki.date

let presentations = [
  { permalink = "oscon13";
    updated = date (2013, 07, 18, 00, 00);
    author = People.mort;
    venue = "OSCON 2013";
    title = "Mirage at OSCON 2013";
    slides = "oscon13.md";
  };
]

let permalink_exists x = List.exists (fun e -> e.permalink = x) presentations

let render preso = 
  Html.(
    "<!doctype html>\n"
    ^ (html 
         (head 
            ("<meta charset='utf-8'>\n"
             ^ title slide.title
            ))
       ^ (body preso.slides)
    )
  )

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
