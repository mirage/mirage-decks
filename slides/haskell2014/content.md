<!-- .slide: class="title" -->

# __Unikernels__: Functional Operating System Design

Anil Madhavapeddy <small>University of Cambridge</small>
[@avsm](http://twitter.com/avsm)

[http://openmirage.org/](http://openmirage.org/)<br/>
[http://decks.openmirage.org/haskell2014/](http://decks.openmirage.org/haskell2014/#/)

<small>
  Press &lt;esc&gt; to view the slide index, and the &lt;arrow&gt; keys to
  navigate.
</small>


----

## Introducing [Mirage OS 2.0](http://openmirage.org/)

These slides were written using Mirage on Mac OSX:

- They are hosted in a **938kB Xen unikernel** written in statically type-safe
  OCaml, including device drivers and network stack.

- Their application logic is just a **couple of source files**, written
  independently of any OS dependencies.

- Running on an **ARM** CubieBoard2, and hosted on the cloud.

- Binaries small enough to track the **entire deployment** in Git!


## Introducing [Mirage OS 2.0](http://openmirage.org/)

<p class="stretch center">
  <img src="decks-on-arm.png" />
</p>


## Leaning Tower of Cloud

<div class="left" style="width: 65%">
  <p>Numerous pain points:</p>
  <ul>
    <li>**Complex** configuration management.</li>
    <li>Duplicated functionality leads to **inefficiency**.</li>
    <li>VM image size leads to **long boot times**.</li>
    <li>Lots of code means a **large attack surface**.</li>
  </ul>
</div>

<p class="right">
  <img src="pisa.jpg" />
  <br /><small>
    https://flic.kr/p/8N1hWh
  </small>
</p>


## The Odd Inversion

We build applications in a **safe, compositional style** using
functional programming.

...and then surround it in **15 million lines of unsafe code** to
interact with the outside world.

> With such powerful programming language abstractions,
> why hasn't the operating system disappeared from our
> stack?


## Complexity Kills You

The enemy is **complexity**:

+ Applications are **deeply intertwined** with system APIs, and so lack
  portability.

+ Modern operating systems offer **dynamic support** for **many users** to run
  **multiple applications** simultaneously.

Almost unbounded scope for uncontrolled interaction!

<!-- .element: class="fragment" data-fragment-index="1" -->

+ Choices of distribution and version.
+ Ad hoc application configuration under `/etc/`
+ Platform configuration details, e.g., firewalls.

<!-- .element: class="fragment" data-fragment-index="1" -->


## Docker: Containerisation

<p class="stretch center">
  <img src="container.jpg" />
</p>

<p class="right">
  <small>
    https://flic.kr/p/qSbck
  </small>
</p>


## Docker: Containerisation

Docker bundles up all this state making it easy to transport, install and manage.

<p class="stretch center">
  <img src="stack-docker.png" />
</p>


## Can We Do Better?

**Disentangle applications from the operating system**.

- Break up operating system functionality into modular libraries.

- Link only the system functionality your app needs.

- Target alternative platforms from a single codebase.


## The Unikernel Approach

> Unikernels are specialised virtual machine images compiled from the full stack
> of application code, system libraries and config

<br/>
This means they realise several benefits:
<!-- .element: class="fragment" data-fragment-index="1" -->

+ __Contained__, simplifying deployment and management.
+ __Compact__, reducing attack surface and boot times.
+ __Efficient__, able to fit 10,000s onto a single host.

<!-- .element: class="fragment" data-fragment-index="1" -->


## It's All Functional Code

Capture system dependencies in code and compile them away.<br/>
<span class="right" style="width: 15em">
  &nbsp;
</span>

<p class="stretch center">
  <img src="stack-abstract.png" />
</p>


## Retarget By Recompiling

Swap system libraries to target different platforms:<br/>
<span class="right">**develop application logic using native Unix**.</span>

<p class="stretch center">
  <img src="stack-unix.png" />
</p>


## Retarget By Recompiling

Swap system libraries to target different platforms:<br/>
<span class="right">**test unikernel using Mirage system libraries**.</span>

<p class="stretch center">
  <img src="stack-unix-direct.png" />
</p>


## Retarget By Recompiling

Swap system libraries to target different platforms:<br/>
<span class="right">**deploy by specialising unikernel to Xen**.</span>

<p class="stretch center">
  <img src="stack-x86.png" />
</p>


## End Result?

Unikernels are compact enough to boot and respond to network traffic in
real-time.

<table style="border-bottom: 1px black solid">
  <thead style="font-weight: bold">
    <td style="border-bottom: 1px black solid; width: 15em">Appliance</td>
    <td style="border-bottom: 1px black solid">Standard Build</td>
    <td style="border-bottom: 1px black solid">Dead Code Elimination</td>
  </thead>
  <tbody>
    <tr style="background-color: rgba(0, 0, 1, 0.2)">
      <td>DNS</td><td>0.449 MB</td><td>0.184 MB</td>
    </tr>
    <tr>
      <td>Web Server</td><td>0.674 MB</td><td>0.172 MB</td>
    </tr>
    <tr style="background-color: rgba(0, 0, 1, 0.2)">
      <td>Openflow learning switch</td><td>0.393 MB</td><td>0.164 MB</td>
    </tr>
    <tr>
      <td>Openflow controller</td><td>0.392 MB</td><td>0.168 MB</td>
    </tr>
  </tbody>
</table>


## End Result?

Unikernels are compact enough to boot and respond to network traffic in
real-time.

<img src="boot-time.png" />


----

## Not the ML Workshop

How in an OS written in OCaml relevant to Haskell?
<br />Much common ancestry!
<hr />

| OCaml             | Haskell      |
| -----             | -------      |
| Strict            | Lazy         |
| References        | Pure         |
| Modules/Functors  | Type Classes |

<hr />
We will focus on __modularity__: the use of modules and functors at scale in
OS construction at this talk.


## Functor Terminology!

* **Haskell**: Functor is a type class that lets you map functions
over the parameterised type using fmap.

* **OCaml**: Similar concept, except that it operates over *modules*
(a collection of functions and types) instead of a single type.

  * OCaml functor is a module that is parameterised across other
    modules (see [Real World OCaml Chap 9](https://realworldocaml.org/v1/en/html/functors.html)).

  * Functors and modules are a separate language from the core OCaml language. *([A Modular Module System](http://caml.inria.fr/pub/papers/xleroy-modular_modules-jfp.pdf), Xavier Leroy in JFP 10(3):269-303, 2000)*.


## Mirage OS 2.0 Workflow

As easy as 1&mdash;2&mdash;3!

1. Write your OCaml application using the Mirage module types.
   + Express its configuration as OCaml code too!

           $ mirage configure app/config.ml --unix


## Mirage OS 2.0 Workflow

As easy as 1&mdash;2&mdash;3!

1. Write your OCaml application using the Mirage module types.
   + Express its configuration as OCaml code too!

2. Compile it and debug under Unix using the `mirage` tool.

         $ cd app
         $ make depend # install library dependencies
         $ make build  # build the unikernel


## Mirage OS 2.0 Workflow

As easy as 1&mdash;2&mdash;3!

1. Write your OCaml application using the Mirage module types.
   + Express its configuration as OCaml code too!

2. Compile it and debug under Unix using the `mirage` tool.

3. Once debugged, simply retarget it to Xen, and rebuild!

          $ mirage configure app/config.ml --xen
          $ cd app && make depend && make build

   + All the magic happens via the OCaml module system.



## Modular Architecture
 
From an ML point-of-view, MirageOS is: 
 
1. A collection of __module types__, describing structural parts of an 
   operating system (including device drivers).
 
2. A collection of independent __libraries that implement the 
   module types.__  Only libraries that application needs
   are linked.
 
3. Use __functors to model dependencies__ between libraries/components. 
   The functor arguments are the module types defined in 1. 


## Module Types: Devices

```
module type DEVICE = sig

  type +'a io
  type t
  type id

  val id : t -> id

  val connect: id -> [ `Error of exn | `Ok of t ] io

  val disconnect : t -> unit io

end
```

Generic interface to any device driver...


## Module Types: Flows

```
module type FLOW = sig

  type +'a io
  type buffer
  type flow

  val read : flow -> [`Ok of buffer | `Eof | `Error of exn ] io

  val write : flow -> buffer -> [`Ok of unit | `Eof | `Error of exn ] io

  val writev : flow -> buffer list -> [`Ok of unit | `Eof | `Error of exn ] io

end

```

...or any I/O flows in the system.


## Module Types: Inclusion

```
module type TCPV4 = sig

  type buffer
  type ipv4
  type ipv4addr
  type flow

  include DEVICE with
  with type id := ipv4

  include FLOW with
  with type 'a io  := 'a io
  and  type buffer := buffer
  and  type flow   := flow
```

...and they can be composed together into other module types, avoiding
the diamond problem.


## Module Types: Entropy

```
module type ENTROPY = sig

  include DEVICE
  type buffer

  type handler = source:int -> buffer -> unit
  (** A [handler] is called whenever the system has extra entropy to announce.
   * No guarantees are made about the entropy itself, other than it being
   * environmentally derived. In particular, the amount of entropy in the buffer
   * can be far lower than the size of the [buffer].
   *
   * [source] is a small integer, describing the provider but with no other
   * meaning.
   **)

  val handler : t -> handler -> unit io
end
```

Complex driver models can be expressed abstractly
(see [V1.ml](https://github.com/mirage/mirage/tree/master/types/)).


## Module Types: Refinement

```
module type FLOW = FLOW
  with type 'a io = 'a Lwt.t
   and type buffer = Cstruct.t

module type NETWORK = NETWORK
  with type 'a io = 'a Lwt.t
   and type page_aligned_buffer = Io_page.t
   and type buffer = Cstruct.t
   and type macaddr = Macaddr.t

module type ETHIF = ETHIF
  with type 'a io = 'a Lwt.t
   and type buffer = Cstruct.t
   and type macaddr = Macaddr.t
   and type ipv4addr = Ipaddr.V4.t
```

The abstract types can be specialised into concrete
library types for common uses
(see [V1_LWT.ml](https://github.com/mirage/mirage/tree/master/types/)).


----

## From Modules to Functors
 
Functors are used everywhere in Mirage to describe OS layers: 
 
- Similar to FoxNet, but for the __whole OS__. We have a full 
  implementation of the network stack (including TLS) in OCaml.
 
- Very __flexible approach__ for customising OS stacks for weird applications
  (HTTP over UPnP over UDP...)

- Lots of __separate implementations__ of the module signatures:
  Unix, Xen microkernels, Javascript, kernel modules, ... 


## Writing a component

A Mirage component usually contains:

- __code parameterised by functors__: very limited dependencies, usually only on
  the Mirage module types.


## Example: Website

```
module Main (C:CONSOLE) (FS:KV_RO) (H:HTTP.Server) = struct

  let start c fs http =
    ...

    let callback conn_id request body =
      C.log "HTTP request received" ...
      >>= fun () ->
      let uri = H.Request.uri request in
      dispatcher (split_path uri)
    in
    let conn_closed (_,conn_id) () = ...  in
    http { S.callback; conn_closed }

end
```


## Modularizing the OS

<p class="stretch center">
  <img src="modules1.png" />
</p>


## Modularizing the OS

<p class="stretch center">
  <img src="modules2.png" />
</p>


## Modularizing the OS

<p class="stretch center">
  <img src="modules3.png" />
</p>



## Writing a component

A Mirage component usually contains:

- code parameterised by functors: very limited dependencies, usually only on
  the Mirage module types.  __No OS dependencies__.

- a collection of libraries where the functors are (fully or partially) applied,
  suitable for interactive use.

> Functors clearly separate the dependencies between OS components
> and break down the monolithic into components.


## The Bad News

Functors are rather heavyweight constructs, and need to be applied in some concrete
combination to make an executable.

The module language is much more limited than the core host language, so we embed
it inside the host language as an eDSL!

> __Metaprogramming__:  manipulate functors as values in the
  host language, and emit resulting module applications as a program stage.


----

## Mirage eDSL: module types

To simplify building applications, we use an eDSL.

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

This describes all the __module types__ (`NETWORK`, `TCPV4`, etc...)


## Mirage eDSL: module types

The eDSL also describes concrete module implementations for a given
signature (e.g. a socket TCPv4 stack vs direct OCaml one).

```
type 'a impl
(** The type of values representing module implementations. *)

val ($): ('a -> 'b) impl -> 'a impl -> 'b impl
(** [m $ a] applies the functor [a] to the functor [m]. *)

val foreign: string -> 'a typ -> 'a impl
(** [foreign name constr typ] states that the module named
    by [name] has the module type [typ]. *)

val typ: 'a impl -> 'a typ
(** Return the module signature of a given implementation. *)
```


## Example: Website

```
let net =
  try match Sys.getenv "NET" with
    | "direct" -> `Direct
    | "socket" -> `Socket
    | _        -> `Direct
  with Not_found -> `Direct

let dhcp = ...

let stack console =
  match net, dhcp with
  | `Direct, true  -> direct_stackv4_with_dhcp console tap0
  | `Direct, false -> direct_stackv4_with_default_ipv4 console tap0
  | `Socket, _     -> socket_stackv4 console [Ipaddr.V4.any]
```
<!-- .element: class="no-highlight" -->

When given a console, this builds a network stack:

```
# val stack : console impl -> stackv4 impl
```
<!-- .element: class="no-highlight" -->


## Example: Website

```
let server =
  let conduit = conduit_direct (stack default_console) in
  http_server (`TCP (`Port 80)) conduit

let main = foreign "Dispatch.Main"
  (console @-> kv_ro @-> http @-> job)

let () =
  register "www" [ main $ default_console $ fs $ server ]
```
<!-- .element: class="no-highlight" -->

Website can be recompiled as:

* Xen unikernel with all data built into image.
* Xen unikernel with data dynamically read from disk.
* Unix binary with data passed through to filesystem.
* Unix binary with OCaml userlevel TCP/IP stack


## eDSL: Summary

* Application is a **parameterised module** over dependencies.
  - ML functors separate OS functionality into modular chunks.
  - Mirage provides a library of module types.
* **Metaprogramming** is used to manipulate these modules.
  - Mirage eDSL manipulates module types and implementations in OCaml.
  - Config file is interpreted to generate executable kernel.
  - Flexible way to specify precise device driver policy.


----

## Git Your Own Cloud

Unikernels are **small enough to be tracked in GitHub**. For example, for the
[Mirage website](http://openmirage.org/):

1. Source code updates are merged to **[mirage/mirage-www](https://github.com/mirage/mirage-www)**;

2. Repository is continuously rebuilt by
  **[Travis CI](https://travis-ci.org/mirage/mirage-www)**; if successful:

3. Unikernel pushed to  **[mirage/mirage-www-deployment](https://github.com/mirage/mirage-www-deployment)**;
  and our

4. Cloud toolstack spawns VMs based on pushes there.

**Our *entire* cloud-facing deployment is version-controlled from the source code
up**!


## Implications

**Historical tracking of source code and built binaries in Git(hub)**.

+ `git tag` to link code and binary across repositories.
+ `git log` to view deployment changelog.
+ `git pull` to deploy new version.
+ `git checkout` to go back in time to any point.
+ `git bisect` to pin down deployment failures.


## Implications

Historical tracking of source code and built binaries in Git(hub).

**Low latency deployment of security updates**.

+ No need for Linux distro to pick up and build the new version.
+ Updated binary automatically built and pushed.
+ Pick up latest binary directly from repository.
+ Statically type-checked language prevents classes of attack.


## Implications

Historical tracking of source code and built binaries in Git(hub).

Low latency deployment of security updates.

**Unified development for cloud and embedded environments**.

+ Write application code once.
+ Recompile to swap in different versions of system libraries.
+ Use compiler optimisations for exotic environments.


## OPAM: Source Management

A library OS needs good package management.  Learn from Cabal.

* __No upper bounds__ on packages, and continuous integration to pick 
  up violations.
* __Distributed git workflow__ for feature branches (package collections can be composed).
* __External constraint solver__ support via CUDF (can use Debian tools
  such as aspcud).

> Every single Mirage library is distributed via OPAM, and many are
> usable in normal Unix (via Lwt/Async) due to functors.


## OPAM: Contributors

<img src="contributors.png" style="align:centre" />


## OPAM: Package Growth

<img src="packages.png" />


----

## Wrapping Up

Mirage OS 2.0 is an important step forward, supporting **more**, and **more
diverse**, **backends** with much **greater modularity**.

For information about the many components we could not cover here, see
[openmirage.org](http://openmirage.org/blog/):

+ __[Irmin](http://openmirage.org/blog/introducing-irmin)__, Git-like
  distributed branchable storage.
+ __[OCaml-TLS](http://openmirage.org/blog/introducing-ocaml-tls)__, a
  from-scratch native OCaml TLS stack.
+ __[Vchan](http://openmirage.org/blog/update-on-vchan)__, for low-latency
  inter-VM communication.
+ __[Ctypes](http://openmirage.org/blog/modular-foreign-function-bindings)__,
  modular C foreign function bindings.


## Get Involved!

Unikernels are an incredibly interesting way to code functionally at scale.
Nothing stresses a toolchain like building a whole OS.

- **Choices**: [Mirage OS](http://openmirage.org) in OCaml, [HaLVM](http://halvm.org) in Haskell.
- **Scenarios**: Static websites, dynamic content, custom routers.
- **Performance**: There's no hiding behind abstractions.  HalVM *vs* Mirage is a fun contest in evaluating abstraction cost.

> Most important: need contributors to build the library base of safe protocol implementations (TLS has been done!)


## Why? [nymote.org](http://nymote.org/)

We need to claim control over our online lives rather than abrogate it to
_The Cloud_:

+ Doing so means we **all** need to be able to run **our own infrastructure**.

+ **Without** having to become (Linux) **sysadmins**!

> <center>How can we achieve this?</center>

<br/>
Mirage/ARM is the foundation for building **personal clouds**, securely
interconnecting and synchronising our devices.

<!-- .element: class="fragment" data-fragment-index="1" -->


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

</p>
