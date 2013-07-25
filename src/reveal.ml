let version = "2.4.0"

let header = "templates/reveal-2.4.0-header.html"
let footer = "templates/reveal-2.4.0-footer.html"

let urls = 
  let prefix = "/reveal-" ^ version in
  List.map (fun p -> (p, prefix ^ p))
    [ "/css/print/paper.css";
      "/css/print/pdf.css";
      "/css/reveal.min.css"; 
      "/css/theme/default.css";
      "/css/theme/sky.css";
      "/css/theme/solarized.css";
      "/css/theme/horizon.css";
      "/css/theme/horizon-fonts.css";
      "/css/theme/horizon.png";
      "/css/theme/ucam.png";
      "/css/theme/uon.png";
      "/css/theme/horizon-starburst.png";

      "/js/reveal.min.js";
      
      "/lib/css/zenburn.css";
      "/lib/font/league_gothic-webfont.svg";
      "/lib/font/league_gothic-webfont.ttf";
      "/lib/font/league_gothic-webfont.woff";
      "/lib/js/classList.js";
      "/lib/js/head.min.js";

      "/plugin/highlight/highlight.js";
      "/plugin/highlight/highlight.js";
      "/plugin/markdown/markdown.js";
      "/plugin/markdown/marked.js";
      "/plugin/notes/notes.html";
      "/plugin/notes/notes.js";
      "/plugin/zoom-js/zoom.js";
    ]
