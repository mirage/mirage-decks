(*
 * Copyright (c) 2013 Richard Mortier <mort@cantab.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

open V1_LWT
open Cohttp
open Cow
open Lwt

let (|>) x f = f x (* ...else only in 4.01 not 4.00.1 *)

let decks =
  let open Deck in
  [
    { permalink = "31c3";
      given = Date.t (2014, 12, 27);
      speakers = [People.david ; People.hannes];
      venue = "31st Chaos Communication Congress";
      title = "Trustworthy secure modular operating system engineering";
      style = Reveal262;
    };
  ]

let index ~req ~path =
  let open Cowabloga in
  let content =
    let decks = decks
                |> List.sort Deck.compare
                |> List.map (fun d ->
                    let speakers =
                      d.Deck.speakers
                      |> List.map (fun s -> Cow.Html.to_string (
                          match s.Atom.uri with
                          | Some u ->
                            <:html<
                              <em><a href="$str:u$">$str:s.Atom.name$</a></em>
                            >>
                          | None ->
                            <:html<<em>$str:s.Atom.name$</em>&>>
                        ))
                      |> String.concat ", "
                      |> Cow.Html.of_string
                    in
                    <:html<
                      <article>
                        $Deck.Date.to_html d.Deck.given$
                        <h4><a href="$str:d.Deck.permalink$">
                          $str:d.Deck.title$
                        </a></h4>
                        <p>
                          <strong>$str:d.Deck.venue$</strong>;
                          $speakers$
                        </p>
                        <p><br /></p>
                      </article>
                    >>)
    in
    <:html< <ul>$list:decks$</ul> >>
  in
  let body =
    <:html<
      <html lang="en">
        <head>
          <meta charset="utf-8"/>
          <meta name="viewport" content="width=device-width"/>
          <meta name="apple-mobile-web-app-capable" content="yes" />
          <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />

          <title>openmirage :: slide decks</title>
          <meta name="description" content="OpenMirage presentations and lectures" />

          <link rel="stylesheet" href="/css/foundation.min.css"> </link>
          <link rel="stylesheet" href="/css/magula.css"> </link>
          <link rel="stylesheet" href="/css/site.css" media="all"> </link>

          <link rel="stylesheet" href="/css/decks.css"> </link>
          <script src="/js/vendor/custom.modernizr.js"> </script>
          <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:400,600,700"
                rel="stylesheet" type="text/css"> </link>
        </head>
        <body>
          <div class="contain-to-grid fixed">
            <nav class="top-bar" data-topbar="">
              <ul class="title-area">
                <li class="name">
                  <h1><a id="logo" href="http://openmirage.org/">
                    <img src="/img/mirage-logo-small.png" alt="Logo" />
                  </a></h1>
                </li>
              </ul>
              <section class="top-bar-section" />
            </nav>
          </div>

          <div class="row"><div class="small-12 columns" role="content">
            <h2>Presentations <small>and talks using Mirage</small></h2>
            $content$
          </div></div>

          <script src="/js/vendor/jquery-2.0.3.min.js"> </script>
          <script src="/js/foundation.min.js"> </script>
          <script src="/js/foundation/foundation.topbar.js"> </script>
          <script> <![CDATA[ $(document).foundation(); ]]> </script>
          <script type="text/javascript">
            var _gaq = _gaq || [];
            _gaq.push(['_setAccount', 'UA-19610168-1']);
            _gaq.push(['_trackPageview']);

            (function() {
              var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
              ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
              var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
            })();
          </script>
        </body>
      </html>
    >>
  in
  return (Foundation.page ~body)

let deck readf ~deck =
  let d = List.find (fun d -> d.Deck.permalink = deck) decks in
  let title = "openmirage.org | decks | " in
  let open Deck in
  match d.style with
  | Reveal240 -> Reveal240.page readf title d
  | Reveal262 -> Reveal262.page readf title d

let asset readf ~deck ~asset =
  let (/) a b = a ^ "/" ^ b in
  let d = List.find (fun d -> d.Deck.permalink = deck) decks in
  readf (d.Deck.permalink / asset)
