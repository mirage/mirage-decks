<!-- .slide: class="title" -->

##Trustworthy secure modular operating system engineering
###fun(ctional) operating system and security protocol engineering

David Kaloper and Hannes Mehnert<br/>
<br/>
31st Chaos Communication Congress, 27th Dec 2014


----
## TCB of IM Client

+ Client software itself
+ Dependent libraries (crypto, XML parsing, communication)
+ GUI framework (picture, font renderer)
+ Programming language runtime
+ C library
+ Memory allocator
+ Operating system kernel (TCP/IP, device drivers)
+ Hardware
+ Compilers

Attack vector is sum of attack vectors in all components!


----
## Trusted Computing Base

> Trusted computing base (TCB) of a computer system is all hardware and software that is critical to its security; bugs inside the TCB jeopardize security properties of entire system.

&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
*&mdash; *([Wikipedia](http://en.wikipedia.org/wiki/Trusted_computing_base)), shortened*


----
## What can we do?


----
## Compartments

<p class="stretch center">
  <img src="container.jpg"/>
</p>

Limits the impact of a successful attack.

+ `chroot`, Solaris Zones, FreeBSD jail, Linux containers, Docker
+ Hypervisor such as Xen, KVM, ... used for Amazon EC2, Rackspace, ...


----
## Compartments

+ Can an attacker escape a `chroot`?

<p class="stretch center">
  <img src="jail.jpg"/>
</p>


----
## More layers

Detect known attacks by adding another layer.

<p class="stretch center">
  <img src="ids.jpg" alt="source http://seit.unsw.adfa.edu.au/research/details2.php?page_id=28"/>
</p>

+ ASLR stack protection
+ Firewall
+ Intrusion detection systems


----
## Piling Layers

> All problems in computer science can be solved by another level of indirection... Except for the problem of too many layers of indirection.
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
*&mdash; *David Wheeler

<p class="stretch center">
  <img src="complex.png"/>
</p>


----

<p class="stretch center">
  <img src="system-is-wrong.jpg"/>
</p>


----
## Clean slate

+ Software systems are complex
+ Communication via protocols - implement and interact with the world
+ API of the Internet: TCP/IP, DHCP, DNS, HTTP, TLS, SASL, XMPP, GIT, SSH, IMAP, ...
+ Persistent data storage


----
## Our Tools

+ Programming language
+ Abstraction features
+ Libraries


----
## Programming Language

+ Concise readable code is the goal
+ Focus on problem, do not distract with boilerplate
+ Abstraction crucial for handling complex systems
    + Variables, functions, higher-order functions, modules, ..


----
## Type systems

+ Type systems spot errors at compile time
+ Early error detection crucial for critical services
+ Type driven development


----
## Side Effects

Side effects are mutation of state which are observable outside of a function in addition to their return value.

+ Hard to reason locally when side effects are there
+ Functional programming marks them explicitly

<p class="stretch center">
  <img src="smash-state.jpg"/>
</p>


----
## Functional programming

+ Allows readable **declarative** programming
+ Combinators compose small functions

````
let l1 = [ 1 ; 2 ; 3 ] in
List.map (fun x -> x + 1) l1

>> [ 2 ; 3 ; 4 ]

l1
>> [ 1 ; 2 ; 3 ]
````


----
## Unikernel

> __Unikernels__ are specialised virtual machine images compiled from the
> modular stack of application code, system libraries and configuration


----
## Mirage OS

+ Started in 2009 at University of Cambridge, UK
+ BSD/MIT licensed
+ OCaml, a modular functional programming language
+ Compiles to a Xen virtual machine (amongst others)
+ 2MB virtual machine size (for HTTPS server)


----
## Mirage on Xen

<p class="stretch center">
  <img src="stack.png" />
</p>

+ OCaml runtime
+ Single address space
+ No C library


----
## Modularity

+ Modules are composable units assembling complex systems together
+ Libraries can use modules as parameters
+ Mirage is a modularized OS
+ Same application code can use various stacks


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
+ 1GB DDR3
+ 10/100 ethernet, support USB WiFi
+ 2x USB 2.0 HOST, micro SD, SATA
+ HDMI
+ ...


----
## Xen security

+ Handle each PCI ID in a separate VM (like Qubes)
+ Shared memory for input/output of ethernet card
+ Inter-VM communication


----
## What Mirage can

+ TCP/IP, DHCP, HTTP, DNS, IMAP, ...
+ Irmin, persistent branchable store (similar to git)
+ TLS
+ Deployment via git - small VM size


----
## Performance

+ Similar to Linux on ARM (serving static HTTP data)
+ Startup time really fast 20ms
+ DNS server starts unikernel when service requested
+ Services on-demand


----
## Tracing

+ Visualise all events currently being processed
+ Debug tool for unikernels (no shell/logs)

<p class="stretch center">
  <img src="tracer.png" />
</p>


----
## OCaml-TLS

<p class="stretch center">
  <img src="aftas-mirleft.jpg" />
</p>

+ Early 2014 in Mirleft - before `goto fail`, Heartbleed


----
## OCaml-TLS

+ Crypto primitives `nocrypto`
+ X.509 certificate verification (ASN.1)
+ Design goal: small API
+ Complex TLS APIs are used wrongly (see "The most dangerous code in the wild" and "Frankencert")


----
## Nocrypto

> Never develop your own crypto library

+ Someone has to do that (esp. with Heartbleed etc.)
+ Variety is better than monoculture
+ Read relevant literature
+ Don't invent your own cryptosystem!


----
## Nocrypto

+ Cipher cores in C - allocation and loop free code
+ Cipher modes in OCaml - ECB, CBC, CTR, GCM, CCM
+ Fortuna RNG
+ RSA/DSA/DH (bignums via GNU gmp)
+ Hashes and HMAC - cores again in C


----
## ASN.1

+ Abstract syntax notation, version 1
+ Language for describing tag-length-value data

```
-- Simple name bindings
UniqueIdentifier ::= BIT STRING

-- Products
Validity ::= SEQUENCE {
  notBefore Time,
  notAfter  Time
}

-- Sums
Time ::= CHOICE {
  utcTime     UTCTime,
  generalTime GeneralizedTime
}
```


----
## Asn1-combinators

+ Parser and generator combinators
+ BER and DER encoding
+ Up to full X.509v3 certificates


----
## X.509 authenticator

````
val chain_of_trust : ?time:float -> Cert.t list -> t

val server_fingerprint : ?time:float -> hash:hash ->
  fingerprints:(string * Cstruct.t) list -> t
````

Hostname is always verified!

Either RFC 5280 chain of trust or trust on first use.


----
## OCaml-TLS

+ Protocol logic in pure core

````
val handle_tls : state -> Cstruct.t ->
  | `Ok of [ `Ok of state | `Eof | `Alert of alert ]
         * [ `Response of Cstruct.t option ]
         * [ `Data of Cstruct.t option ]
  | `Fail of alert * [ `Response of Cstruct.t ]

val send_application_data : state -> Cstruct.t list ->
  (state * Cstruct.t) option
````


----
## OCaml-TLS

+ Effectful layers for `lwt` and `mirage`
+ Network input and output
+ Hide details from developer

````
val accept : X509_lwt.priv -> Lwt_unix.file_descr ->
  ((ic * oc) * Lwt_unix.sockaddr) Lwt.t

val connect : X509_lwt.authenticator -> string * int ->
  (ic * oc) Lwt.t
````


----
## What is TLS?

+ Transport layer security
+ Most widely used security protocol since 1999
+ Algorithmic agility: negotiation of key exchange, cipher and hash
+ Trust anchors (certificate authorities)


----
## Handshake

Tracing of our server side stack

Showing live at

````
cd mirage/tls-demo-server
./main.native
````

[https://tls.openmirage.org](https://tls.openmirage.org)


----
## OCaml-TLS

+ Interoperability both client and server side (demo server served > 50000 sessions)
+ Develop working TLS stack in small time frame is doable
+ Learned patterns for robust implementation of security protocols
+ 350 000 loc (OpenSSL) vs 100 000 (PolarSSL) 20 000 loc (OCaml-TLS)
  (used `cloc` for counting)


----
## Open issues in OCaml-TLS

+ Pull requests for client authentication, AEAD ciphers, SNI
+ No session resumption
+ No elliptic curve cryptography


----
## Moving Forward

+ Healthy functional code base easy to extend
+ [Conduit](https://github.com/mirage/ocaml-conduit) - abstracting over connections (shared memory (Xen vchan), TCP, TLS, ..)
+ November: [Ocaml-OTR](https://github.com/hannesm/ocaml-otr) - DSA for nocrypto, no socialists millionairs problem
+ December: [Jackline](https://github.com/hannesm/jackline) - command-line XMPP client

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
+ [Blog series about OCaml-TLS, ...](http://openmirage.org/blog/introducing-ocaml-tls)
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
Why computers are so @#!* - Day 4, 12:45, Saal 1
+ Daniel B&uuml;nzli, Thomas Leonard, Thomas Gazagnaire, Dave Scott, Richard Mortier, Jon Crowcraft
+ Edwin T&ouml;r&ouml;k, Andreas Bogk, Gregor Kopf
+ Mirage team in Cambridge, OCaml Labs
+ miTLS team - formally verified TLS stack in F7/F#
+ All we forgot (sorry!)
