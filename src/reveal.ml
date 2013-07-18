let version = "2.4.0"

let urls = 
  let prefix = "reveal-" ^ version in
  let remap s = 
    Re_str.(let re = regexp "^/slides" in replace_first re prefix s) 
  in
  List.map (fun p -> ( [p], remap p ))
    [ "/slides/css/print/paper.css";
      "/slides/css/print/pdf.css";
      "/slides/css/reveal.min.css"; 
      "/slides/css/theme/default.css";

      "/slides/js/reveal.min.js";
      
      "/slides/lib/css/zenburn.css";
      "/slides/lib/font/league_gothic-webfont.svg";
      "/slides/lib/font/league_gothic-webfont.ttf";
      "/slides/lib/font/league_gothic-webfont.woff";
      "/slides/lib/js/classList.js";
      "/slides/lib/js/head.min.js";

      "/slides/plugin/highlight/highlight.js";
      "/slides/plugin/highlight/highlight.js";
      "/slides/plugin/markdown/markdown.js";
      "/slides/plugin/markdown/marked.js";
      "/slides/plugin/notes/notes.html";
      "/slides/plugin/notes/notes.js";
      "/slides/plugin/zoom-js/zoom.js";
    ]
