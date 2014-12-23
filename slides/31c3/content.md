<!-- .slide: class="title" -->

##Trustworthy secure modular operating system engineering
###fun(ctional) operating system and security protocol engineering

David Kaloper and Hannes Mehnert<br/>
<br/>
31st Chaos Communication Congress, 27th Dec 2014


----
## Trusted Computing Base

> The trusted computing base (TCB) of a computer system is the set of all hardware, firmware, and/or software components that are critical to its security, in the sense that bugs or vulnerabilities occurring inside the TCB might jeopardize the security properties of the entire system.

&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
*&mdash; *([Wikipedia](http://en.wikipedia.org/wiki/Trusted_computing_base))*


----
## TCB of IM Client

+ Client software itself
+ Libraries it depends on (OpenSSL, libotr, libpurple)
+ GUI framework (picture, font renderer)
+ Programming language runtime (Python? Ruby?)
+ C library
+ Memory allocator
+ Operating system kernel (TCP/IP, device drivers)
+ Hardware
+ Compilers

Attack vector is sum of attack vectors in all components!


----
## What can we do?

+ Compartmentalize
+ Mitigate known vulnerabilities
+ Shrink the TCB


----
## Compartments

<p class="stretch center">
  <img src="container.jpg"/>
</p>

Limits the impact of a successful attack.

+ `chroot`, FreeBSD jail, Linux containers
+ Hypervisor (Xen / KVM / VMWare / VirtualBox / ...)


----
## Compartments

+ Can an attacker escape a `chroot`?

<p class="stretch center">
  <img src="jail.jpg"/>
</p>


----
## Mitigation

Detect known attacks by adding another layer.

<p class="stretch center">
  <img src="ids.jpg" alt="source http://seit.unsw.adfa.edu.au/research/details2.php?page_id=28"/>
</p>

+ ASLR Stack protection
+ Firewall
+ IDS


----
## Minimize TCB

> All problems in computer science can be solved by another level of indirection... Except for the problem of too many layers of indirection.
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
*&mdash; *David Wheeler

<p class="stretch center">
  <img src="complex.png"/>
</p>


----
## Wrong Approach

<p class="stretch center">
  <img src="system-is-wrong.jpg"/>
</p>


----
## Programming Languages

+ Focus on problem, do not distract with boilerplate
+ Abstraction crucial for handling complex systems
    + Variables, functions, higher-order functions, modules, ..
+ Type systems spot errors at compile time
+ Automation in certain areas: memory management


----
## Side Effects

Always dangerous areas in your program. Mark these explicitly!

+ Network input/output
+ Mutable memory

<p class="stretch center">
  <img src="smash-state.jpg"/>
</p>


----
## Functional programming

+ Allows readable **declarative** programming
+ Combinators compose tiny mathematical functions

<p class="stretch center">
  <img src="functional-xkcd.png"/>
</p>


----
## Complexity

Complexity kills you:

+ Applications are **deeply intertwined** with system APIs, and so lack
  portability
+ Modern operating systems offer **dynamic support** for **many users** to run
  **multiple applications** simultaneously

Almost unbounded scope for uncontrolled interaction!

+ Ad hoc application configuration under `/etc`
+ Shell scripts manage configurations and deployment
+ But: shell becomes part of TCB (Shellshock!)


----
<p class="stretch center">
  <img src="RiseUpSun.png"/>
</p>


----
## Clean slate

+ Services communicate via binary protocols
+ Seemless migration requires those protocols
+ API of the Internet: TCP/IP, DHCP, DNS, HTTP, TLS, SASL, XMPP, GIT, SSH, ...
+ Persistent data storage


----
## Mirage OS

+ Modular operating system
+ Since 2009 project at University of Cambridge, UK
+ BSD/MIT licensed
+ OCaml - modular functional programming language
+ Not a general purpose OS
+ Application and configuration specific binaries!


----
## Unikernel

> __Unikernels__ are specialised virtual machine images compiled from the
> modular stack of application code, system libraries and configuration

<br/>
This means they realise several benefits:
<!-- .element: class="fragment" data-fragment-index="2" -->

+ __Contained__, simplifying deployment and management
+ __Compact__, reducing attack surface and boot times
+ __Efficient__, able to fit 10,000s onto a single host
+ __Portable__, to many compilation environments beyond Xen

<!-- .element: class="fragment" data-fragment-index="2" -->


----
## Modularize the OS

<p class="stretch center">
  <img src="modules1.png" />
</p>


----
## Modularize the OS

<p class="stretch center">
  <img src="modules2.png" />
</p>


----
## Modularize the OS

<p class="stretch center">
  <img src="modules3.png" />
</p>


----
## Intermission

<p class="stretch center">
  <img src="a20-cubieboard.png"/>
</p>


----
## Cubieboard 2

+ __AllWinnerTech SOC A20, ARM Cortex-A7 Dual-Core__
+ GPU: ARM Mali400 MP2 (OpenGL ES 2.0/1.1)
+ 1GB DDR3, 3.4GB internal NAND flash
+ 10/100 ethernet, support USB WiFi
+ 2x USB 2.0 HOST, mini USB 2.0 OTG, micro SD, SATA
+ HDMI 1080P display output
+ IR, line in, line out, 96 extend PIN interface, including I2C, SPI, RGB/LVDS, CSI/TS, FM-IN, ADC, CVBS, VGA, SPDIF-OUT, R-TP, and more
+ roughly 40 &euro;


----
## Modularize the OS

Run the same library _and_ application code as:

+ UNIX binary
+ Xen virtual machine (ARM or AMD64)
+ Rackspace/Amazon EC2/... instance
+ FreeBSD kernel module*
+ Inside of your web browser*


----
## Mirage on Xen

<p class="stretch center">
  <img src="stack.png" />
</p>

+ Single address space
+ No processes, file system, user management
+ No C library (but openlibm and printf)
+ OCaml runtime including garbage collector


----
## Modularity (code!)

+ Applications are abstracted over devices (console, TCP/IP stack)


----
## Libraries

+ Irmin, persistent branchable store (similar to git)
+ Git
+ OCaml-TLS
+ HTTP, DNS, TCP/IP, DHCP, ...
+ Unikernel size is small (HTTPS including TCP/IP and OCaml runtime < 2MB)
+ Development and deployment via git


----
## Performance

+ On par with Linux on ARM serving HTTP
+ Startup time below 20ms
+ Start service after DNS request was processed


----
## Tracing

<p class="stretch center">
  <img src="tracer.png" />
</p>


----
## OCaml-TLS

+ Early 2014 in Mirleft - before `goto fail`, Heartbleed
+ Crypto primitives `nocrypto`
+ X.509 certificate verification (ASN.1)
+ Design goal: small API footprint (unlike OpenSSL)

<p class="stretch center">
  <img src="aftas-mirleft.jpg" />
</p>


----
## Nocrypto

> Never develop your own crypto library

+ Cipher cores in C - allocation and loop free code
+ Cipher modes in OCaml - ECB, CBC, CTR, GCM, CCM
+ Fortuna RNG
+ Bignum (via GMP), RSA/DSA/DH
+ Hashes and HMAC - cores again in C
+ Timing


----
## ASN.1

+ Composable parsers and unparsers using GADTs
+ No magic 0 bytes
+ No manual decoding
+ BER/DER - all the way up to X.509v3 certificates


----
## X.509 authenticator

````
val chain_of_trust : ?time:float -> Cert.t list -> t

val server_fingerprint : ?time:float -> hash:hash
  -> fingerprints:(string * Cstruct.t) list -> t
````

Hostname is always verified!

Either RFC 5280 chain of trust or trust on first use.


----
## OCaml-TLS

+ Protocol logic encapsulated in declarative functional core
+ Side effects isolated in frontends
+ `lwt` (event-based on UNIX) and `mirage`
+ Expose API to C as shared object (planned)


----
## What is TLS?

+ Cryptographically secure channel (TCP) between two nodes
+ Most widely used security protocol (since > 15 years)
+ Protocol family (SSLv3.0, TLS 1.0, 1.1, 1.2)
+ Algorithmic agility: negotiation of key exchange, cipher and hash
+ X.509 (ASN.1 encoding) PKI for certificates


----
## Handshake

Tracing of our server side stack

Showing live at

````
cd mirage/tls-demo-server
./main.native
````

[https://127.0.0.1:4433](https://127.0.0.1:4433)


----
## OCaml-TLS

+ Interoperability both client and server side (demo server served > 50000 sessions)
+ Pull requests for client authentication, AEAD ciphers, SNI
+ No session resumption
+ No ECC (yet)
+ Started in January, first release in July - 3 months, 5 hackers rule!
+ 350kloc (OpenSSL) vs 20kloc (OCaml-TLS)
+ [Blog series about OCaml-TLS, ...](http://openmirage.org/blog/introducing-ocaml-tls)


----
## Moving Forward

+ [Conduit](https://github.com/mirage/ocaml-conduit) - abstracting over connections (shared memory (Xen vchan), TCP, TLS, ..)
+ [Ocaml-OTR](https://github.com/hannesm/ocaml-otr) - (no SMP) - 4 weeks (including DSA)
+ [Jackline](https://github.com/hannesm/jackline) - command-line XMPP client - 4 weeks

<p class="stretch center">
  <img src="jackline.png" />
</p>

----
## Trusted Code Base

+ Linux network device driver (separate Xen domain)
+ Xen hypervisor
+ MiniOS (printf, other stubs)
+ OpenLibm math library
+ GNU multiple precision library
+ OCaml runtime
+ OCaml libraries: cstruct, zarith, cohttp, x509, asn1, tls, nocrypto
+ OCaml and C compiler


----
## Conclusion

+ Functional operating systems are real now!
+ Why OCaml? Also Haskell (HalVM), Erlang on Xen, ...
+ Fuck legacy and traditions, let's start to build secure and resilient systems!
+ Keep it simple, complexity is the enemy
+ Join our #nolibc movement
+ [http://openmirage.org](http://openmirage.org)


----
## We need help

+ Try it, run it, break it
+ Join the movement: audit code, write tests, fuzz it, ...
+ Discuss design choices and code snippets with us
+ Implement your favorite protocol
+ Here at 31c3: serving you espresso at coffeenerds (4th floor, [@espressobicycle](https://twitter.com/espressobicycle)) while discussing


----
## Thanks

+ Anil Madhavapeddy
+ Peter Sewell - talks here<br/>
Day 4, 12:45, Saal 1 - `Why computers are so @#!*`
+ Daniel B&uuml;nzli, Thomas Leonard, Thomas Gazagnaire, Dave Scott, Richard Mortier, John Crowcraft
+ Edwin T&ouml;r&ouml;k, Andreas Bogk, Gregor Kopf
+ Mirage team in Cambridge, OCaml Labs
+ miTLS team - formally verified TLS stack in F7/F#
+ All we forgot (sorry!)
