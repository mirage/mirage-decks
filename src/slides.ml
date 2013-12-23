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

open Mirage_types.V1
open Cohttp
open Cow
open Lwt

module Deck = struct
  module Date = struct

    type t = {
      year: int;
      month: int;
      day: int;
    } with xml

    let t (year, month, day) = { year; month; day }

    let to_html d =
      let xml_of_month m =
        let str = match m with
          | 1  -> "Jan" | 2  -> "Feb" | 3  -> "Mar" | 4  -> "Apr"
          | 5  -> "May" | 6  -> "Jun" | 7  -> "Jul" | 8  -> "Aug"
          | 9  -> "Sep" | 10 -> "Oct" | 11 -> "Nov" | 12 -> "Dec"
          | _  -> "???" in
        <:xml<$str:str$>>
      in
      <:xml<
        <span class="date">
          <span class="month">$xml_of_month d.month$</span>
          <span class="day">$int:d.day$</span>,
          <span class="year">$int:d.year$</span>
        </span>
      >>

    let compare {year=ya;month=ma;day=da} {year=yb;month=mb;day=db} =
      match ya - yb with
      | 0 -> (match ma - mb with
          | 0 -> da - db
          | n -> n
        )
      | n -> n

  end

  type t = {
    permalink: string;
    given: Date.t;
    speakers: Atom.author list;
    venue: string;
    title: string;
  }

  let compare a b = Date.compare b.given a.given

end

let decks =
  let open Deck in
  [{ permalink = "clweds13";
     given = Date.t (2013, 12, 04);
     speakers = [People.anil];
     venue = "Wednesday Seminar, Cambridge Computer Laboratory";
     title = "MirageOS: a functional library operating system";
   };

   { permalink = "cam13";
     given = Date.t (2013, 12, 03);
     speakers = [People.anil];
     venue = "ACS Lecture, Cambridge Computer Laboratory";
     title = "Modular Operating System Construction";
   };

   { permalink = "fb13";
     given = Date.t (2013, 11, 14);
     speakers = [People.anil];
     venue = "Facebook HQ";
     title = "MirageOS: compiling functional library operating systems";
   };

   { permalink = "fop13";
     given = Date.t (2013, 11, 29);
     speakers = [People.mort];
     venue = "FP Lab 2013";
     title = "MirageOS: Tomorrow's Cloud, Today";
   };

   { permalink = "qcon13";
     given = Date.t (2013, 11, 11);
     speakers = [People.anil];
     venue = "QCon 2013";
     title = "MirageOS: developer tools of tomorrow";
   };

   { permalink = "xensummit13";
     given = Date.t (2013, 10, 25);
     speakers = [People.anil; People.jon];
     venue = "XenSummit 2013";
     title = "MirageOS and XAPI 2013 Project Update";
   };

   { permalink = "oscon13";
     given = Date.t (2013, 07, 26);
     speakers = [People.mort; People.anil];
     venue = "OSCON 2013";
     title = "Mirage: Extreme Specialisation of Cloud Appliances";
   };

   { permalink = "jslondon13";
     given = Date.t (2013, 08, 29);
     speakers = [People.anil];
     venue = "Jane Street London 2013";
     title = "My Other Internet is a Mirage";
   };

   { permalink = "foci13";
     given = Date.t (2013, 08, 12);
     speakers = [People.anil];
     venue = "FOCI 2013";
     title = "Lost in the Edge: Finding Your Way with Signposts";
   };
  ]

let index ~req ~path =
  let open Cowabloga in
  let content =
    let decks = decks
                |> List.sort Deck.compare
                |> List.map (fun d ->
                    <:html<
                      <li>
                        $Deck.Date.to_html d.Deck.given$
                        <a href="$str:d.Deck.permalink$">
                          $str:d.Deck.title$ ($str:d.Deck.venue$)
                        </a>
                      </li>
                    >>)
    in
    <:html< <ul>$list:decks$</ul> >>
  in
  let title = "openmirage.org | decks" in
  return (Foundation.(page ~body:(body ~title ~headers:[] ~content)))

module Reveal = struct

  let t ~deck ~slides =
    let open Deck in
    let speakers = deck.speakers
           |> List .map (fun p -> p.Atom.name)
           |> String.concat ", "
    in
    let description = deck.venue in
    let title =
      "openmirage.org | decks | " ^ " [ " ^ deck.permalink ^ " ]" ^ deck.title
    in
    let base = "/" ^ deck.permalink ^ "/" in
    <:html<
      <html lang="en">
        <head>
          <meta charset="utf-8" />
          <title>$str:title$</title>
          <meta name="description" content="$str:description$" />
          <meta name="author" content="$str:speakers$" />
          <meta name="apple-mobile-web-app-capable" content="yes" />
          <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />

          <meta name="viewport"
                content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

          <link rel="stylesheet" href="/reveal-2.4.0/css/reveal.min.css"> </link>
          <link rel="stylesheet" href="/reveal-2.4.0/lib/css/zenburn.css"> </link>
          <link rel="stylesheet" href="/reveal-2.4.0/css/print/pdf.css"
                media="print"> </link>
          <link rel="stylesheet" href="/reveal-2.4.0/css/theme/horizon.css" id="theme"
                media="all"> </link>
          <link rel="stylesheet" href="/css/site.css" media="all"> </link>

          <base href=$str:base$ />

          <!--[if lt IE 9]>
              <script src="/reveal-2.4.0/lib/js/html5shiv.js"> </script>
          <![endif]-->
        </head>
        <body>
          <div class="reveal">
            <div class="slides">
              $slides$
              <div id="footer">

              <a id="index" href="/"> <img src="/img/home.png" /> </a>
                <div id="slide-number"> </div>
              </div>
            </div>
          </div>

          <script src="/reveal-2.4.0/lib/js/head.min.js"> </script>
          <script src="/reveal-2.4.0/js/reveal.min.js"> </script>
          <script src="/reveal-2.4.0/js/init.js"> </script>
        </body>
      </html>
    >>

end

let deck readf ~deck =
  let open Cowabloga in
  let d = List.find (fun d -> d.Deck.permalink = deck) decks in
  lwt body =
    readf (d.Deck.permalink ^ "/index.html") >>= fun slides ->
    return (Reveal.t d (Cow.Html.of_string slides))
  in
  return (Foundation.page ~body)

let asset readf ~deck ~asset =
  let d = List.find (fun d -> d.Deck.permalink = deck) decks in
  readf (d.Deck.permalink ^ "/" ^ asset)
