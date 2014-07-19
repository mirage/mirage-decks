open Lwt
open Cow
open Deck

let page readf site d =
  let (/) a b = a ^ "/" ^ b in

  let read_template t = readf ("templates" / t) in
  lwt preamble = read_template "preamble.html" in
  lwt bodyh = read_template "reveal-2.4.0-header.html" in
  lwt bodyf = read_template "reveal-2.4.0-footer.html" in

  lwt body = readf (d.permalink / "index.html") in

  let head =
    let open Deck in
    let speakers = d.speakers
                   |> List.map (fun p -> p.Atom.name)
                   |> String.concat ", "
    in
    let description = d.venue in
    let title = site ^ " [ " ^ d.permalink ^ " ]" ^ d.title in
    let base = "/" ^ d.permalink ^ "/" in
    <:html<
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
    >>
  in

  return (preamble ^ (Cow.Html.to_string head) ^ bodyh ^ body ^ bodyf)
