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

open Cow

let anil = {
  Atom.name = "Anil Madhavapeddy";
  uri       = Some "http://anil.recoil.org";
  email     = Some "anil@recoil.org";
}

let thomas = {
  Atom.name = "Thomas Gazagnaire";
  uri       = Some "http://gazagnaire.org";
  email     = Some "thomas@gazagnaire.org";
}

let raphael = {
  Atom.name = "Raphael Proust";
  uri       = Some "https://github.com/raphael-proust";
  email     = Some "raphlalou@gmail.com";
}

let dave = {
  Atom.name = "Dave Scott";
  uri       = Some "http://dave.recoil.org/";
  email     = Some "dave@recoil.org";
}

let balraj = {
  Atom.name = "Balraj Singh";
  uri       = None;
  email     = Some "balraj.singh@cl.cam.ac.uk";
}

let mort = {
  Atom.name = "Richard Mortier";
  uri       = Some "http://mort.io/";
  email     = Some "mort@cantab.net";
}

let vb = {
  Atom.name = "Vincent Bernardoff";
  uri       = Some "https://github.com/vbmithr";
  email     = Some "vb@luminar.eu.org";
}

let jon = {
  Atom.name = "Jon Ludlam";
  uri       = Some "http://jon.recoil.org";
  email     = Some "jon@recoil.org"
}


let rights = Some "All rights reserved by the author"
