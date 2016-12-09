(*
 * Copyright (c) 2013 Anil Madhavapeddy <anil@recoil.org>
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

type t = {
  name: string;
  uri: string option;
  email: string option;
}

let anil = {
  name = "Anil Madhavapeddy";
  uri = Some "http://anil.recoil.org";
  email = Some "anil@recoil.org";
}

let magnus = {
  name = "Magnus Skjegstad";
  uri = Some "http://www.skjegstad.com";
  email = Some "magnus@v0.no";
}

let thomas = {
  name = "Thomas Gazagnaire";
  uri = Some "http://gazagnaire.org";
  email = Some "thomas@gazagnaire.org";
}

let raphael = {
  name = "Raphael Proust";
  uri = Some "https://github.com/raphael-proust";
  email = Some "raphlalou@gmail.com";
}

let dave = {
  name = "Dave Scott";
  uri = Some "http://dave.recoil.org/";
  email = Some "dave@recoil.org";
}

let balraj = {
  name = "Balraj Singh";
  uri = None;
  email = Some "balraj.singh@cl.cam.ac.uk";
}

let mort = {
  name = "Richard Mortier";
  uri = Some "http://mort.io/";
  email = Some "mort@cantab.net";
}

let vb = {
  name = "Vincent Bernardoff";
  uri = Some "https://github.com/vbmithr";
  email = Some "vb@luminar.eu.org";
}

let jon = {
  name = "Jon Ludlam";
  uri = Some "http://jon.recoil.org";
  email = Some "jon@recoil.org"
}

let hannes = {
  name = "Hannes Mehnert";
  uri = Some "https://github.com/hannesm";
  email = Some "hannes@mehnert.org"
}

let david = {
  name = "David Kaloper";
  uri = Some "https://github.com/pqwy";
  email = Some "david@numm.org"
}

let crowcroft = {
  name = "Jon Crowcroft";
  uri = Some "www.cl.cam.ac.uk/~jac22";
  email = Some "jon.crowcroft@cl.cam.ac.uk";
}

let mindy = {
  name = "Mindy Preston";
  uri = Some "https://www.somerandomidiot.com";
  email = Some "mindy.preston@cl.cam.ac.uk";
}

let amir = {
  name = "Amir Chaudhry";
  uri = Some "http://amirchaudhry.com";
  email = Some "amirmc@gmail.com";
}

let rights = Some "All rights reserved by the author"
