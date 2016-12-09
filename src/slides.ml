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

open Tyxml

let decks =
  let open Deck in
  [
    { permalink = "ucamafp16";
      given = Date.t (2016, 03, 06);
      speakers = [People.anil];
      venue = "ACS AFP Lecture, Cambridge Computer Laboratory";
      title = "Modular Operating System Construction";
      style = Reveal240;
    };

    { permalink = "cif16-loops";
      given = Date.t (2016, 01, 22);
      speakers = [People.mort];
      venue = "Unikernels and More: Cloud Innovators Forum 2016";
      title = "Knock, Knock: Unikernels Calling!";
      style = Reveal262 None;
    };

    { permalink = "strangeloop15";
      given = Date.t (2015, 09, 26);
      speakers = [People.mindy];
      venue = "Strange Loop 2015";
      title = "Non-Imperative Network Programming";
      style = Reveal262 None;
    };

    { permalink = "ocaml15-irminnet";
      given = Date.t (2015, 09, 04);
      speakers = [People.mindy];
      venue = "OCaml Workshop 2015";
      title = "Persistent Networking with Irmin and MirageOS";
      style = Reveal262 None;
    };

    { permalink = "polyconf15";
      given = Date.t (2015, 07, 04);
      speakers = [People.amir];
      venue = "PolyConf 2015";
      title = "Unikernels!";
      style = Reveal262 None;
    };

    { permalink = "bigtechday8";
      given = Date.t (2015, 06, 12);
      speakers = [People.mort];
      venue = "TNG Big Techday 8";
      title = "Nymote: Git your own cloud here";
      style = Reveal262 None;
    };

    { permalink = "qcon15-mirage";
      given = Date.t (2015, 06, 10);
      speakers = [People.anil];
      venue = "QCon NYC 2015";
      title = "Designing Secure Services with Unikernels";
      style = Reveal262 None;
    };

    { permalink = "qcon15-unik";
      given = Date.t (2015, 06, 06);
      speakers = [People.anil];
      venue = "QCon NYC 2015";
      title = "Unikernels: the next million operating systems";
      style = Reveal262 None;
    };

    { permalink = "iot-summit15";
      given = Date.t (2015, 05, 11);
      speakers = [People.amir];
      venue = "IoT Summit 2015";
      title = "Giving users control (and why Unikernels are the way to do it)";
      style = Reveal262 None;
    };

    { permalink = "nsdi2015";
      given = Date.t (2015, 05, 06);
      speakers = [People.anil; People.magnus; People.mort];
      venue = "USENIX Networked System Design and Implementation (NSDI)";
      title = "Jitsu: Just-in-Time Summoning of Unikernels";
      style = Reveal262 None;
    };

    { permalink = "pcampldn15";
      given = Date.t (2015, 03, 28);
      speakers = [People.amir];
      venue = "ProductCamp London 2015";
      title = "New Open Source Tech for IoT Products";
      style = Reveal262 None;
    };

    { permalink = "darmstadt-seminar";
      given = Date.t (2015, 03, 18);
      speakers = [People.crowcroft];
      venue = "TU Darmstadt";
      title = "Stage of the Mirage: Mar 2015";
      style = Reveal262 None;
    };

    { permalink = "qconlondon15";
      given = Date.t (2015, 03, 05);
      speakers = [People.anil];
      venue = "QCon London";
      title = "Building Functional Infrastructure with Mirage OS";
      style = Reveal262 None;
    };

    { permalink = "bob15";
      given = Date.t (2015, 01, 22);
      speakers = [People.anil];
      venue = "Bob Konf";
      title = "Towards Functional Operating Systems";
      style = Reveal262 None;
    };

    { permalink = "ic15-seminar";
      given = Date.t (2015, 01, 21);
      speakers = [People.anil];
      venue = "Imperial College London";
      title = "Unikernels: a Principled Foundation for Networked Services";
      style = Reveal262 None;
    };

    { permalink = "oups15-irmin";
      given = Date.t (2015, 01, 20);
      speakers = [People.thomas];
      venue = "OCaml User-meeting in PariS";
      title = "Irmin: a Git-like database Library";
      style = Reveal262 None;
    };

    { permalink = "31c3";
      given = Date.t (2014, 12, 27);
      speakers = [People.david ; People.hannes];
      venue = "31st Chaos Communication Congress";
      title = "Trustworthy secure modular operating system engineering";
      style = Reveal262 None;
    };

    { permalink = "irill14-seminar";
      given = Date.t (2014, 12, 09);
      speakers = [People.anil];
      venue = "IRILL Paris";
      title = "Stage of the Mirage: Dec 2014";
      style = Reveal262 None;
    };

    { permalink = "uw14-seminar";
      given = Date.t (2014, 12, 03);
      speakers = [People.mort];
      venue = "University of Washington, Systems Group";
      title = "Git Your Own Cloud: Summoning Unikernels";
      style = Reveal262 None;
    };

    { permalink = "osio2014";
      given = Date.t (2014, 11, 24);
      speakers = [People.anil];
      venue = "New Directions in Operating Systems 2014";
      title = "Jitsu: Just-in-Time Summoning of Unikernels";
      style = Reveal262 None;
    };

    { permalink = "codemesh2014";
      given = Date.t (2014, 11, 05);
      speakers = [People.anil];
      venue = "Codemesh 2014";
      title = "Nymote: Git Your Own Cloud Here";
      style = Reveal262 None;
    };

    { permalink = "functionalconf14";
      given = Date.t (2014, 10, 09);
      speakers = [People.thomas];
      venue = "Functional Conf 2014, Bangalore";
      title = "Compile your Own Cloud with Mirage OS";
      style = Reveal262 None;
    };

    { permalink = "bt2014";
      given = Date.t (2014, 10, 07);
      speakers = [People.anil];
      venue = "British Telecom CIO Briefing";
      title = "Let a Billion Clouds Bloom";
      style = Reveal262 None;
    };

    { permalink = "itu-copenhagen14";
      given = Date.t (2014, 09, 09);
      speakers = [People.hannes];
      venue = "IT University of Copenhagen";
      title = "Mirage OS and OCaml-TLS -- Fun operating system engineering";
      style = Reveal262 None;
    };

    { permalink = "ocaml14-tls";
      given = Date.t (2014, 09, 05);
      speakers = [People.hannes];
      venue = "OCaml 2014";
      title = "Transport Layer Security purely in OCaml";
      style = Reveal262 None;
    };

    { permalink = "haskell2014";
      given = Date.t (2014, 09, 05);
      speakers = [People.anil];
      venue = "Haskell Symposium 2014 Keynote";
      title = "Unikernels: Functional Operating System Design";
      style = Reveal262 None;
    };

    { permalink = "ml14";
      given = Date.t (2014, 09, 04);
      speakers = [People.anil; People.thomas; People.dave; People.mort; ];
      venue = "ML Workshop";
      title = "Metaprogramming with ML modules in the MirageOS";
      style = Reveal262 None;
    };

    { permalink = "xendevsummit14";
      given = Date.t (2014, 08, 18);
      speakers = [People.anil; People.dave; People.thomas];
      venue = "Xen dev summit";
      title = "MirageOS 2.0: branch consistency for Xen Stub Domains";
      style = Reveal262 None;
    };

    { permalink = "oscon14";
      given = Date.t (2014, 07, 24);
      speakers = [People.mort; People.anil];
      venue = "OSCON 2014";
      title = "Nymote: Git Your Own Cloud Here";
      style = Reveal262 None;
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
      title = "Irminsule — Status Report";
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

let deck_to_html d =
  let open Html in
  let concat sep =
    let rec aux acc sep = function
      | []      -> List.rev acc
      | h :: [] -> aux (h :: acc) sep []
      | h :: tl -> aux (sep :: h :: acc) sep tl
    in
    aux [] sep
  in

  let speakers =
    d.Deck.speakers
    |> List.map (fun s -> match s.People.uri with
        | Some u -> em [a ~a:[a_href u] [pcdata s.People.name]]
        | None   -> a [pcdata s.People.name]
      )
    |> concat (pcdata ", ")
  in

  article [
    Deck.Date.to_html d.Deck.given;
    h4 [
      a ~a:[a_href d.Deck.permalink] [pcdata d.Deck.title]
    ];
    p ( (strong [pcdata d.Deck.venue]) :: (pcdata " ") :: speakers) ;
    p [ br () ]
  ]

let link_css ?(a=[]) css = Html.link ~a ~rel:[`Stylesheet] ~href:css ()

let index () =
  let open Html in
  let script src = script ~a:[a_src src] (pcdata " ") in
  let head =
    head (title (pcdata "openmirage :: slide decks")) [
      meta ~a:[a_charset "utf-8"] ();
      meta ~a:[a_name "viewport"; a_content "width=device-width"] ();
      meta ~a:[a_name "apple-mobile-web-app-capable"; a_content "yes"] ();
      meta ~a:[a_name "apple-mobile-web-app-status-bar-style";
               a_content "black-translucent"] ();
      meta ~a:[a_name "description";
               a_content "OpenMirage presentations and lectures"] ();
      link_css "/css/foundation.min.css";
      link_css "/css/magula.css";
      link_css ~a:[a_media [`All]] "/css/site.css";
      link_css "/css/decks.css";
      script "/js/vendor/custom.modernizr.js";
      link_css ~a:[a_mime_type "text/css"]
        "http://fonts.googleapis.com/css?family=Source+Sans+Pro:400,600,700"
    ]
  in

  let body =
    body [
      div ~a:[a_class ["contain-to-grid"]] [
        nav ~a:[a_class ["top-bar"]; a_user_data "topbar" ""] [
          ul ~a:[a_class ["title-area"]] [
            li ~a:[a_class ["name"]] [
              h1 [
                a ~a:[a_id "logo"; a_href "https://mirage.io/"] [
                  img ~src:"/img/mirage-logo-small.png" ~alt:"Logo" ()
                ]
              ]
            ]
          ];
          section ~a:[a_class ["top-bar-section"]] []
        ];
        div ~a:[a_class ["row"]] [
          div ~a:[a_class ["small-12"; "columns"];
                  (Unsafe.string_attrib "role" "content")
                 ]
            [
              h2 [
                (pcdata "Presentations ");
                small [pcdata "and talks using Mirage"]
              ];
              ul (decks |> List.sort Deck.compare
                  |> List.map (fun d ->
                      li ~a:[a_class ["index-entry"]] [deck_to_html d]
                    )
                 )
            ]
        ]
      ];

      script "/js/vendor/jquery-2.0.3.min.js";
      script "/js/foundation.min.js";
      script "/js/foundation/foundation.topbar.js";
      Html.script (cdata_script "$(document).foundation();");
      Html.script ~a:[a_mime_type "text/javascript"]
        (pcdata {__|
var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-19610168-1']);
_gaq.push(['_trackPageview']);

(function() {
  var ga = document.createElement('script');
  ga.type = 'text/javascript';
  ga.async = true;
  ga.src =
    ('https:' == document.location.protocol ? 'https://ssl' : 'http://www')
    + '.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0];
  s.parentNode.insertBefore(ga, s);
})();
|__}
        )
    ]
  in

  Lwt.return (Render.to_string @@ Html.html ~a:[Html.a_lang "en"] head body)

let deck ~readf ~deck =
  let d = List.find (fun d -> d.Deck.permalink = deck) decks in
  let title = "openmirage.org | decks | " in
  Deck.(match d.style with
      | Reveal240 -> Reveal240.page ~readf ~site:title d
      | Reveal262 _ -> Reveal262.page ~site:title d
    )

let asset ~readf ~deck ~asset =
  let d = List.find (fun d -> d.Deck.permalink = deck) decks in
  readf (d.Deck.permalink ^ "/" ^ asset)
