open Tyxml
open Deck

let page ~site d =
  let head =
    let open Deck in
    let theme = match d.style with Reveal262 (Some s) -> s | _ -> "horizon" in
    let speakers =
      d.speakers |> List.map (fun p -> p.People.name) |> String.concat ", "
    in
    let link_css ?(a=[]) css = Html.link ~a ~rel:[`Stylesheet] ~href:css () in
    let open Html in
    head (title (pcdata (site ^ " [ " ^ d.permalink ^ " ] " ^ d.title))) [
      meta ~a:[a_charset "utf-8"] ();
      meta ~a:[a_name "description"; a_content d.venue] ();
      meta ~a:[a_name "author"; a_content speakers] ();
      meta ~a:[a_name "apple-mobile-web-app-capable"; a_content "yes"] ();
      meta ~a:[a_name "apple-mobile-web-app-status-bar-style";
               a_content "black-translucent"] ();
      meta ~a:[a_name "viewport";
               a_content "width=device-width, initial-scale=1.0,\
                         \ maximum-scale=1.0, user-scalable=no"] ();

      link_css ~a:[a_media [`All]] "/css/site.css";
      link_css "/reveal.js-2.6.2/css/reveal.min.css";
      link_css "/highlight.js-8.2/styles/zenburn.css";
      link_css ~a:[a_id "theme"] ("/reveal.js-2.6.2/css/theme/"^theme^".css");

      base ~a:[a_href ("/" ^ d.permalink ^ "/")] ();
      (Xml.comment
         {__|[if lt IE 9]
             <script src="/reveal.js-2.6.2/lib/js/html5shiv.js"> </script>
             <![endif]|__}
       |> tot)
    ]
  in

  let body =
    let open Html in
    let script s = script ~a:[a_src s] (pcdata " ") in
    body [
      div ~a:[a_class ["reveal"]] [
        div ~a:[a_class ["slides"]] [
          section ~a:[a_user_data "markdown" "content.md";
                      a_user_data "separator" "^\n\n----\n";
                      a_user_data "vertical" "^\n\n";
                      a_user_data "notes" "^Note:";
                      a_user_data "charset" "iso-8859-15"] [
          ];

          div ~a:[a_id "footer"] [
            a ~a:[a_id "index"; a_href "/"] [
              img ~src:"/img/home.png" ~alt:"Home" ()
            ];
            a ~a:[a_id "print-pdf"; a_href "?print-pdf"] [
              img ~src:"/img/print.png" ~alt:"Print" ()
            ]
          ]
        ]
      ];
      script "/js/vendor/jquery-2.0.3.min.js";
      script "/reveal.js-2.6.2/lib/js/head.min.js";
      script "/reveal.js-2.6.2/js/reveal.min.js";
      script "/reveal.js-2.6.2/js/init.js";
    ]
  in
  Lwt.return (Render.to_string @@ Html.html head body)
