open Lwt.Infix
open Tyxml

let link_css ?(a=[]) css = Html.link ~a ~rel:[`Stylesheet] ~href:css ()

let page ~readf ~site d =
  let ( / ) a b = a ^ "/" ^ b in

  readf (d.Deck.permalink / "index.html") >>= fun content ->

  let head =
    let speakers =
      d.Deck.speakers |> List.map (fun p -> p.People.name) |> String.concat ", "
    in
    let open Html in
    head (title (pcdata Deck.(site ^ " [ " ^ d.permalink ^ " ] " ^ d.title))) [
      meta ~a:[a_charset "utf-8"] ();
      meta ~a:[a_name "description"; a_content d.Deck.venue] ();
      meta ~a:[a_name "author"; a_content speakers] ();
      meta ~a:[a_name "apple-mobile-web-app-capable"; a_content "yes"] ();
      meta ~a:[a_name "apple-mobile-web-app-status-bar-style";
               a_content "black-translucent"] ();
      meta ~a:[a_name "viewport";
               a_content "width=device-width, initial-scale=1.0,\
                         \ maximum-scale=1.0, user-scalable=no"] ();

      link_css "/reveal-2.4.0/css/reveal.min.css";
      link_css "/reveal-2.4.0/lib/css/zenburn.css";
      link_css ~a:[a_media [`Print]] "/reveal-2.4.0/css/print/pdf.css";
      link_css
        ~a:[a_id "theme"; a_media [`All]] "/reveal-2.4.0/css/theme/horizon.css";
      link_css ~a:[a_media [`All]] "/css/site.css";

      base ~a:[a_href ("/" ^ d.Deck.permalink ^ "/")] ();
      (Xml.comment
         {__|[if lt IE 9]
             <script src="/reveal-2.4.0/lib/js/html5shiv.js"> </script>
             <![endif]|__}
       |> tot)
    ]
  in
  let body =
    let open Html in
    body [
      div ~a:[a_class ["reveal"]] [
        div ~a:[a_class ["slides"]] [
          Unsafe.data content;

          div ~a:[a_id "footer"] [
            a ~a:[a_id "index"; a_href "/"] [
              img ~src:"/img/home.png" ~alt:"Home" ()
            ];
            div ~a:[a_id "slide-number"] []
          ]
        ]
      ];
      script ~a:[a_src "/reveal-2.4.0/lib/js/head.min.js"] (pcdata " ");
      script ~a:[a_src "/reveal-2.4.0/js/reveal.min.js"] (pcdata " ");
      script ~a:[a_mime_type "text/javascript"]
        (Unsafe.data {__|
// Full list of configuration options available here:
// https://github.com/hakimel/reveal.js#configuration
Reveal.initialize({
    controls: true,
    progress: true,
    history: true,
    center: false,
    margin:0.07,
    // available themes are in /css/theme
    theme: Reveal.getQueryHash().theme,
    // default/cube/page/concave/zoom/linear/fade/none
    transition: Reveal.getQueryHash().transition || 'fade',
    // Optional libraries used to extend on reveal.js
    dependencies: [
        { src: '/reveal-2.4.0/lib/js/classList.js',
          condition: function() {return !document.body.classList;}
          },
        { src: '/reveal-2.4.0/plugin/markdown/marked.js',
          condition: function() {
            return !!document.querySelector( '[data-markdown]' );
          }},
        { src: '/reveal-2.4.0/plugin/markdown/markdown.js',
          condition: function() {
            return !!document.querySelector( '[data-markdown]' );
          }},
        { src: '/reveal-2.4.0/plugin/highlight/highlight.js',
          async: true,
          callback: function() { hljs.initHighlightingOnLoad(); }
          },
        { src: '/reveal-2.4.0/plugin/zoom-js/zoom.js', async: true,
           condition: function(){return !!document.body.classList;}
          },
        { src: '/reveal-2.4.0/plugin/notes/notes.js', async: true,
          condition: function() {return !!document.body.classList;}
          }
    ]
});
var slideNumber = document.querySelector('#slide-number');
var updateSlideNumber = function(event) {
    slideNumber.textContent =
        (event.indexh > 0)
        ? event.indexh + '\u2014' + (event.indexv + 1)
        : '';
}
Reveal.addEventListener('ready', updateSlideNumber);
Reveal.addEventListener('slidechanged', updateSlideNumber);
|__}
        );
    ]
  in
  Lwt.return (Render.to_string @@ Html.html ~a:[Html.a_lang "en"] head body)
