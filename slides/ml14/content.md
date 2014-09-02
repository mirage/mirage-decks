<!-- .slide: class="title" -->

# Metaprogramming with ML modules in the MirageOS

Anil Madhavapeddy <small>University of Cambridge</small>
[@avsm](http://twitter.com/avsm)

Thomas Gazagnaire <smalll>University of Cambridge</small>
[@eriangazag](http://twitter.com/eriangazag)

David Scott <small>Citrix</small>
[@mugofsoup](http://twitter.com/mugofsoup)

Richard Mortier <small>University of Nottingham</small>
[@mort\_\_\_](http://twitter.com/mort___)

[http://openmirage.org/](http://openmirage.org/)<br/>
[http://nymote.org/](http://nymote.org/)<br/>
[http://decks.openmirage.org/oscon14/](http://decks.openmirage.org/ml14/#/)

<small>
  Press &lt;esc&gt; to view the slide index, and the &lt;arrow&gt; keys to
  navigate.
</small>


----

## What is Mirage OS?

From a Functional Programing point of view, MirageOS is:

1. A collection of module types, describing different parts of an
   operating system (including network and storage drivers)

2. A collection of independant libraries, implementating the
   signatures. Depending on your application, you select the part of
   the OS you want to link with.

3. Use functors to model dependencies between libraries/components.
   The functor arguments are the module types defined in 1.


----

## Functors Everywhere

Functors are used everywhere in Mirage to describe the OS layers:

- Similar to FoxNets (but for the whole OS, but yes we have a full
  implementation of the network stack -- including TLS -- in OCaml)

- Lots of different backends (ie. implementation for the core OS signatures):
  Unix, Xen, Javascript, kernel module, ...

- Very flexible approach. Example of HTTP over UPnP over UDP


## Writing a component

A Mirage component usually contains:

- a library of functors: very limited dependencies, usually only on the Mirage
  module types

- a collection of libraries where the functors are (fully or partially) applied.
  This can lead to a combinatorial explosion in the number of
  libraries, so we try to choose which functor to apply carefully (lwt).

> Having functors here is excelent, as it shows clearly the dependencies
  between OS components (ex: TCP with RANDOM, CLOCK, etc.)


## Writing an application

A Mirage application needs to:

- gather all the implementations of the OS components it is interested in

- apply the functors in the right order; write some glue code and call `OS.run`
  to run the OS scheduller

- specialize the different functor to the specific backend it wants to run on

> Having functors here does not help at all: complex error message for the
  end user, need to figure how to apply the functors in the right order,
  very verbose language


----

## The Mirage eDSL: module types

To simplify building applications, we use an eDSL to describe
module types:

```
type 'a typ
(** The type of values representing module types. *)

val (@->): 'a typ -> 'b typ -> ('a -> 'b) typ
(** Construct a functor type from a type and an existing functor
    type. This corresponds to prepending a parameter to the list of
    functor parameters. For example,

    {| kv_ro @-> ip @-> kv_ro |}

    describes a functor type that accepts two arguments -- a kv_ro and
    an ip device -- and returns a kv_ro.
*)
```


## The Mirage eDSL: module types

We use an eDSL to descibre module implementation:

```
type 'a impl
(** The type of values representing module implementations. *)

val ($): ('a -> 'b) impl -> 'a impl -> 'b impl
(** [m $ a] applies the functor [a] to the functor [m]. *)

val foreign: string -> ?libraries:string list -> ?packages:string list -> 'a typ -> 'a impl
(** [foreign name libs packs constr typ] states that the module named
    by [name] has the module type [typ]. If [libs] is set, add the
    given set of ocamlfind libraries to the ones loaded by default. If
    [packages] is set, add the given set of OPAM packages to the ones
    loaded by default. *)

val typ: 'a impl -> 'a typ
(** Return the module signature of a given implementation. *)
```


## The Mirage eDSL: implementations

Direct correspondance between module types and values of type `'a typ`:

Module types | `'a typ`
-------------|----------
`NETWORK`    | `network typ`
`ETHERNET`   | `ethernet typ`

Directo correspondances between *the pair* (module implementations
$\times$ module value) *and a state* and values of type `a impl`
(similar to dynamics but for modules):

Module Impl                                   | `'a impl`
----------------------------------------------|----------
Netif $\times$ `Netfif.connect "tap0"`        | `val tap0: network impl`
Netif $\times$ (fun x -> `Netfif.connect x) ` | `val netif: string -> network impl`

An application is described by a value of type `job impl`.


## The Mirage OS eDSL

Example


## The Mirage OS eDSL: metaprogramming

From a `'job impl` value, we can do multiple things:

- `opam install` the packages which contains the libraries
- run configuration scripts (as `ocaml-crunch`)
- generate boiler-plate to assemble the functor applications and run
  the scheduler
- read the environment variables / the command-line to switch
  some implementation automatically (without changes to the user code)
  Xen Backend, pure network stack, etc


## Some difference between the module and the value language

- Optional arguments:

```
val direct_tcpv4:
  ?clock:clock impl ->
  ?random:random impl ->
  ?time:time impl ->
  ipv4 impl -> tcpv4 impl
```

Select default module implementation for `CLOCK, `RANDOM` and `TIME`.

- Error messages

TODO: show difference betweem type errors and 70k error message in Irmin


## The Mirage eDSL: extensibility

Anyone can extend the eDSL, just need to (1) defined a abstract type
corresponding to the module type and (2) define a CONFIGURABLE
implementation and pack-it using first class modules:

```
val implementation: 'a -> 'b -> (module CONFIGURABLE with type t = 'b) -> 'a impl
```


----

## <http://openmirage.org/>

Featuring blog posts by:
[Amir Chaudhry](http://amirchaudhry.com/),
[Thomas Gazagnaire](http://gazagnaire.org/),
[David Kaloper](https://github.com/pqwy),
[Thomas Leonard](http://roscidus.com/blog/),
[Jon Ludlam](http://twitter.com/jonludlam),
[Hannes Mehnert](https://github.com/hannesm),
[Mindy Preston](https://github.com/yomimono),
[Dave Scott](http://dave.recoil.org/),
and [Jeremy Yallop](https://github.com/yallop).

<p style="font-size: 48px; font-weight: bold;
          display: float; padding: 2ex 0; text-align: center">
  Thanks for listening! Questions?
</p>
