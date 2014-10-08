<!-- .slide: class="title" -->

# Compile your Own Cloud with Mirage OS

Thomas Gazagnaire <small>University of Cambridge</small>
[@eriangazag](http://twitter.com/eriangazag)

**Functional Conf, Bangalore, Oct 2014**

[http://openmirage.org/](http://openmirage.org/)<br/>
[http://nymote.org/](http://nymote.org/)<br/>
[http://decks.openmirage.org/functionalconf14](http://decks.openmirage.org/functionalconf14/#/)

<small>
  Press &lt;esc&gt; to view the slide index, and the &lt;arrow&gt; keys to
  navigate.
</small>


----

## Systems Programming

> It's considered good programming practice to focus
> on compositionality: build software out of small, well-defined
> modules that combine to give rise to other modules with different
> behaviors.
>
> **This is simply too difficult to do in distributed systems. Why?**

&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
*-- Marius Eriksen, Principal Engineer, Twitter* *([source](http://monkey.org/~marius/sosp13.html))*


## From simple servers...

Traditional systems programming has involved building services in
*one* environment.  e.g. Server, client, or embedded.


##  ...To deep-sea diving

Traditional systems programming has involved building services in
*one* environment.  A modern programmer deals with diverse targets:

- **Cloud services** with unpredictable traffic spikes and failures.
- **Smartphone programming** on ARM/x86 with power budgets.
- **JavaScript** user interfaces with asynchronous web clients.
- **Internet of Things** devices that have little ARM M0 processors.
- **Kernel modules** to extend operating system functionality.

> No code reuse means we repeat the mistakes of the past.


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


## The Odd Inversion

We build applications in a **safe, compositional style** using
functional programming.

...and then surround it in **15 million lines of unsafe code** to
interact with the outside world.

> With such powerful programming language abstractions,
> why hasn't the operating system disappeared from our
> stack?


## Introducing [Mirage OS 2.0](http://openmirage.org/)

These slides were written using Mirage on Mac OSX:

- They are hosted in a **~1Mb Xen unikernel** written in statically type-safe
  OCaml, including device drivers and network stack.

- Their application logic is just a **couple of source files**, written
  independently of any OS dependencies.

- Running on an **ARM** CubieBoard2, and hosted on the cloud.

- Binaries small enough to track the **entire deployment** in Git!

> Focus on *portability*, *modularity*, *safety* and *perfomance*.


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


## Memory Management

<img height="500" src="memory-model.png" />


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


## Docker HTTP Latency

<p class="stretch center">
<img src="docker-http.png" />
</p>


## Mirage (Jitsu) HTTP Latency

<p class="stretch center">
<img src="jitsu-http.png" />
</p>


## HTTP Latency Summary

For the initial HTTP request from a cold start, observed latency is:

* a full Linux VM: > 5 seconds
* a Docker container: ~1.4 seconds
* a Jitsu unikernel: ~0.3 seconds

> Unikernels are compact enough to boot and respond to network traffic in
real-time.


## Summary

Mirage OS v2.0 is our response to tackle the increasing complexity embedded into our computing systems.

In this talk, I will focus on:

+ __[OCaml](https://ocaml.org])__, our main programming language.
+ __Mirage v2.0 workflow__.
+ __[Irmin](http://openmirage.org/blog/introducing-irmin)__, Git-like
  distributed branchable storage.
+ __[OCaml-TLS](http://openmirage.org/blog/introducing-ocaml-tls)__, a
  from-scratch native OCaml TLS stack.

Many more topics are covered on our [blog](https://openmirage.org/blog)!


----

# OCaml


## OCaml

> OCaml is an industrial strength programming language supporting
  functional, imperative and object-oriented styles
  [ocaml.org/](https://ocaml.org)

+ Pragmatic
  + use the right style for the job
+ statically typed
  + good for performance
  + good for insuring global invariance (safety)


## OCaml

+ Descendant of ML (~1970). Brothers: F#, Haskell
+ OCaml created by Xavier Leroy from INRIA (1996)
+ In the curriculum of the major CS programs
  + In US: Harvard, Cornell, Brown, Princeton, UCLA, ...
  + In Europe: ENS, UPMC, ... (France), Cambridge, Oxford (UK), ...
  + In Asia: Singapore, Nagoya (Japon), __India__?

> Strong roots in academia


## OCaml

+ From mission-critical, to compiler related, through web programming
  + Jane-street, Bloomberg, Lexifi, ...
  + Citrix, Red-hat, ...
  + Facebook, Haxe Foundation, ...
  + CEA, Dassault, Thales, ANSSI, ...
+ Rather small ecosystem of consulting and service companies
+ OCaml Labs created 2 years ago in Cambridge

> Major Industrial users


## OPAM: Source Management

A library OS needs good package management. Mix of Cabal (Haskel) and homebrew (OSX).

* __No upper bounds__ on packages, and continuous integration to pick
  up violations.
* __Distributed git workflow__ for feature branches (package collections can be composed).
* __External constraint solver__ support via CUDF (can use Debian tools
  such as aspcud).

> Every single Mirage library is distributed via OPAM, and many are
> usable in normal Unix.


## OPAM: Contributors

<img src="contributors.png" style="align:centre" />


## OPAM: Package Growth

<img src="packages.png" />


## Experiences with OCaml

+ __OCaml is the baseline language for all new code__
  + Our C runtime is small, and getting smaller.
  + Is fully event-driven and non-preemptive.
  + Safe modularity at scale is incredible.
+ __Rewriting protocols wasn&rsquo;t that hard__
  + An extremely useful learning experience.
  + Clean slate often highlights research opportunities.
  + Pickup by industry has been vital.
+ __Unikernels fit perfectly on the cloud__
  + Internet protocol building blocks.
  + Seamless interop with legacy code through VMs.


----

# Mirage OS Workflow


## Mirage OS 2.0 Workflow

1) Write your OCaml application once using the Mirage module types.

    + Do not worry (too much) about portability


## Mirage OS 2.0 Workflow

<p class="stretch center">
  <img src="modules1.png" />
</p>


## Mirage OS 2.0 Workflow

2) Compile it and debug under Unix using the `mirage` tool.

````
export NET=socket
mirage configure --unix && mirage build
./main.native
````

<br />

Use your usual debugging tools!


## Mirage OS 2.0 Workflow

<p class="stretch center">
  <img src="modules2.png" />
</p>


## Mirage OS 2.0 Workflow

3) Once debugged, simply retarget it to the mirage network stack, and rebuild!

````
export NET=direct
mirage configure --unix && mirage build
sudo ifconfig tap0 create
sudo ./main.native
sudo ifconfig tap0 10.0.0.1
````

<br />

Does not use the kernel network stack anymore!


## Mirage OS 2.0 Workflow

<p class="stretch center">
  <img src="modules3.png" />
</p>


## Mirage OS 2.0 Workflow

4) Once debugged, simply retarget it to Xen, and rebuild!

````
mirage configure --xen && mirage build
sudo xl create -c main.xl
````

<br />

Does not use the kernel anymore.


## Mirage OS 2.0 Workflow

<br />

> Write your application once, configure it multiple times

<br />

+ All the magic happens via the OCaml module system.
+ The `mirage` tool hides (most) of the complexity to the user


----

# Irmin


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


## Irmin: Mirage 2.0 Storage

Using Git is so practical we want to use it everywhere!

+ Not only source code and binaries, but also __application data__!
+ Irmin uses the same concepts as **Git** (commit, merge, branches) but expose them as libraries
- A **key = value** store
- runs in both **userspace** and **kernelspace**
- **Preserves history** by default
- **Backend support** for in-memory, Git and HTTP/REST stores.

Mirage unikernels thus version control all their data,
and have a **distributed provenance graph** of all activities.


## Irmin: Base Concepts

### Object DAG _(or the "Blob Store")_

- __Append-only__ and easily distributed.
- Provides __stable serialisation__ of structured values.
- __Backend independent__ storage
  - memory or on-disk persistence
  - encryption or plaintext
- Position and architecture independent pointers
  - such as via SHA1 checksum of blocks.


## Irmin: Base Concepts

### History DAG _(or the "Git Store")_

- __Append-only__ and easily distributed.
- Can be stored in the Object DAG store.
- Keeps track of __history__.
  - Ordered __audit log__ of all operations.
  - Useful for __merge__ (3-way merge is easier than 2-way)
- Snapshots and reverting operations for free.


## Irmin: Base Concepts

### Mutabke Tags _(or the "Local State")_

- __Mutable__ and __not__ distrbuted
- Keep track of the current state of the current process
- Contains only pointers to the History DAG


## Irmin: Base Concepts

<img src="store.png" height="450px"/>


## Irmin: Tooling

> `opam install irmin`

- Command-line frontend that uses:
  - **storage**: in-memory format or Git
  - **network**: custom format, Git or HTTP/REST
  - **interface**: JSON interface for storing content easily

- OCaml library that supplies:
  - merge-friendly data structures
  - backend implementations (Git, HTTP/REST)

- BSD-licensed


## Irmin: use-case

+ Irmin as a Xenstore backend [David Scott, from Citrix]

<div class="flex-video">
  <iframe width="480" height="360" src="//www.youtube-nocookie.com/embed/DSzvFwIVm5s" frameborder="0" allowfullscreen="1"> &nbsp; </iframe>
</div>


----

# OCaml-TLS


## OCaml-TLS

+ Mirage operating system uses OCaml

+ Memory safety, abstraction, modularity


## OCaml-TLS: Motivation

+ Mirage operating system uses OCaml

+ Memory safety, abstraction, modularity

+ But for security call unsafe insecure C code??

+ Each line of C code is one line too much!!


## OCaml-TLS: Motivation

+ Protocol logic encapsulated in declarative functional core

+ Side effects isolated in frontends

+ Concise, useful, well-designed API

<p class="stretch center">
  <img src="aftas-mirleft.jpg" />
</p>


## TLS: What is TLS?

+ Cryptographically secure channel (TCP) between two nodes

+ Most widely used security protocol (since > 15 years)

+ Protocol family (SSLv3.0, TLS 1.0, 1.1, 1.2)

+ Algorithmic agility: negotiation of key exchange, cipher and hash

+ Uses X.509 (ASN.1 encoding) PKI for certificates


## TLS: Attacks

+ Apple's "goto fail"

+ Heartbleed

+ "Change cipher suite" message

+ Timing attacks (Lucky13, Bleichenbacher, ..)


## OCaml-TLS: Code statistics

+ Disclaimer: ``cloc`` statistics, use with a grain of salt

+ Linux kernel, glibc (1187), apache (209), OpenSSL (354): 17553kloc code (mostly C)

+ Mirage OS, cohttp, OCaml-TLS: 125kloc (75k C, 43k OCaml, 7k assembly)
   + 26k C: OCaml runtime
   + 17k C: MiniOS
   + 22k C: OpenLibm
   + 8k C + 7k asm: gmp


## OCaml-TLS: Results

+ Live demo at [https://tls.openmirage.org/](https://tls.openmirage.org)

+ Interoperability (server served > 50000 sessions)

+ Missing features: ~~client authentication~~, session resumption, ECC ciphersuites

+ Performance: roughly 5 times slower than OpenSSL, but most time spent in C (3DES)


## OCaml-TLS: Conclusion

> `opam install tls`

+ It is *possible* to re-implement a widely used (and critical) protocol in 6 months!

+ Thanks to Hannes Mehnert and David Kaloper huge efforts!

+ BSD-licensed


----

# Conclusion


## Mirage: New Features in 2.0

Mirage OS 2.0 is an important step forward, supporting **more**, and **more
diverse**, **backends** with much **greater modularity**.

For information about the new components we cannot cover here, see
[openmirage.org](http://openmirage.org/blog/):

+ __[Xen/ARM](http://openmirage.org/blog/introducing-xen-minios-arm)__, for
  running unikernels on embedded devices	.
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

- **Choices**:
  * [Mirage OS](http://openmirage.org) (OCaml), [HaLVM](http://halvm.org) (Haskell),
  * [Ling](http://erlangonxen.org/) (Erlang), [OSv](http://osv.io/) (Java)
- **Scenarios**: Static websites, dynamic content, custom routers.
- **Performance**: There's no hiding behind abstractions. Fun contest in evaluating abstraction cost.

> Most important: need contributors to build the library base of safe protocol implementations


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


## <http://openmirage.org/>

A Linux Foundation Incubator Project lead from the University of Cambridge and Citrix Systems.

Featuring blog posts on new features by:

[Anil Madhavapeddy](http://anil.recoil.org),
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
  <br />
  Contributions very welcome at [openmirage.org](http://openmirage.org)
</p>
