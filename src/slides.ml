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
    { permalink = "oscon14";
      given = Date.t (2014, 07, 24);
      speakers = [People.mort];
      venue = "OSCON 2014";
      title = "Nymote: Git Your Own Cloud Here";
    };
    { permalink = "cl-mirage20";
      given = Date.t (2014, 06, 26);
      speakers = [People.anil];
      venue = "Cambridge Computer Lab";
      title = "Mirage 2.0: less is more";
      style = Reveal240;
    };

    { permalink = "clucn14-irminsule";
      given = Date.t (2014, 04, 02);
      speakers = [People.thomas];
      venue = "Cambridge Computer Lab";
      title = "Irminsule - Status Report";
      style = Reveal240;
    };

    { permalink = "clucn14";
      given = Date.t (2014, 04, 02);
      speakers = [People.mort; People.anil];
      venue = "Cambridge Computer Lab";
      title = "Nottingham/Cambridge UCN Kickoff";
      style = Reveal240;
    };

    { permalink = "fpx14";
      given = Date.t (2014, 03, 14);
      speakers = [People.anil];
      venue = "Functional Programming eXchange 2014";
      title = "My Other Internet is a Mirage";
      style = Reveal240;
    };

    { permalink = "t2review14";
      given = Date.t (2014, 03, 13);
      speakers = [People.anil];
      venue = "T2 EU Review ";
      title = "Liquid scheduling with unikernels";
      style = Reveal240;
    };

    { permalink = "fosdem14";
      given = Date.t (2014, 02, 02);
      speakers = [People.anil; People.mort];
      venue = "FOSDEM 2014";
      title = "MirageOS: compiling function library operating systems";
      style = Reveal240;
    };

    { permalink = "clweds13";
      given = Date.t (2013, 12, 04);
      speakers = [People.anil];
      venue = "Wednesday Seminar, Cambridge Computer Laboratory";
      title = "MirageOS: a functional library operating system";
      style = Reveal240;
    };

    { permalink = "cam13";
      given = Date.t (2013, 12, 03);
      speakers = [People.anil];
      venue = "ACS Lecture, Cambridge Computer Laboratory";
      title = "Modular Operating System Construction";
      style = Reveal240;
    };

    { permalink = "fb13";
      given = Date.t (2013, 11, 14);
      speakers = [People.anil];
      venue = "Facebook HQ";
      title = "MirageOS: compiling functional library operating systems";
      style = Reveal240;
    };

    { permalink = "fop13";
      given = Date.t (2013, 11, 29);
      speakers = [People.mort];
      venue = "FP Lab 2013";
      title = "MirageOS: Tomorrow's Cloud, Today";
      style = Reveal240;
    };

    { permalink = "qcon13";
      given = Date.t (2013, 11, 11);
      speakers = [People.anil];
      venue = "QCon 2013";
      title = "MirageOS: developer tools of tomorrow";
      style = Reveal240;
    };

    { permalink = "xensummit13";
      given = Date.t (2013, 10, 25);
      speakers = [People.anil; People.jon];
      venue = "XenSummit 2013";
      title = "MirageOS and XAPI 2013 Project Update";
      style = Reveal240;
    };

    { permalink = "oscon13";
      given = Date.t (2013, 07, 26);
      speakers = [People.mort; People.anil];
      venue = "OSCON 2013";
      title = "Mirage: Extreme Specialisation of Cloud Appliances";
      style = Reveal240;
    };

    { permalink = "jslondon13";
      given = Date.t (2013, 08, 29);
      speakers = [People.anil];
      venue = "Jane Street London 2013";
      title = "My Other Internet is a Mirage";
      style = Reveal240;
    };

    { permalink = "foci13";
      given = Date.t (2013, 08, 12);
      speakers = [People.anil];
      venue = "FOCI 2013";
      title = "Lost in the Edge: Finding Your Way with Signposts";
      style = Reveal240;
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
