<!-- .slide: class="title" -->

##Mirage OS and OCaml-TLS -- Fun operating system engineering

Hannes Mehnert<br/>
University of Cambridge<br/>
<i>(OCaml-TLS is joined work with David Kaloper)</i><br/>
<br/>
ITU University Copenhagen, 9th September 2014

[https://github.com/mirleft/ocaml-tls/](https://github.com/mirleft/ocaml-tls/)<br/>


----
## Overview

+ Mirage OS

+ Transport layer security

+ OCaml TLS (including live demo)

+ Statistics and conclusion


----
## Talk

<p class="stretch center">
  <img src="a20-cubieboard.png"/>
</p>


----
## Interlude: Cubieboard 2

+ AllWinnerTech SOC A20, ARM Cortex-A7 Dual-Core
+ GPU: ARM Mali400 MP2 (OpenGL ES 2.0/1.1)
+ 1GB DDR3
+ 3.4GB internal NAND flash
+ 10/100 ethernet, support USB WiFi
+ 2x USB 2.0 HOST, mini USB 2.0 OTG, micro SD, SATA
+ HDMI 1080P display output
+ IR, line in, line out, 96 extend PIN interface, including I2C, SPI, RGB/LVDS, CSI/TS, FM-IN, ADC, CVBS, VGA, SPDIF-OUT, R-TP, and more


----
## Motivation for Mirage OS

+ General purpose operating systems are huge

+ Security issues

+ Configuration complexity

+ Management complexity

+ Who runs her own mail server these days?


----
## Mirage OS - library operating system

<p class="stretch center">
  <img src="stack.png" />
</p>


----
## Mirage OS

+ Based on XEN hypervisor

+ Written entirely in OCaml

+ Single address space

+ Event-based

+ No processes


----
## OCaml

+ Functional programming language

+ Compiler with native and bytecode backend

+ Community of both academia and companies

+ Composable module system


----
## Modularizing the OS

<p class="stretch center">
  <img src="modules1.png" />
</p>


----
## Demonstration

show source code!
````
setenv NET socket
mirage configure && mirage build
./main.native
````


----
## Modularizing the OS

<p class="stretch center">
  <img src="modules2.png" />
</p>


----
## Demonstration

````
mirage configure && mirage build
sudo ifconfig tap0 create
sudo ./main.native
sudo ifconfig tap0 10.0.0.1
````


----
## Modularizing the OS

<p class="stretch center">
  <img src="modules3.png" />
</p>


----
## Demonstration

````
ssh cubie
cd tls-mvp-server
mirage configure && mirage build
sudo xl create -c tls-serer.xl
````


----
## Design goals of OCaml-TLS

+ Protocol logic encapsulated in declarative functional core

+ Side effects isolated in frontends

+ Concise, useful, well-designed API

<p class="stretch center">
  <img src="aftas-mirleft.jpg" />
</p>


----
## What is TLS?

+ Cryptographically secure channel (TCP) between two nodes

+ Most widely used security protocol (since > 15 years)

+ Protocol family (SSLv3.0, TLS 1.0, 1.1, 1.2)

+ Algorithmic agility: negotiation of key exchange, cipher and hash

+ Uses X.509 (ASN.1 encoding) PKI for certificates


----
## Protocol details

+ Security properties:

    + Authentication (optional mutual)
    + Secrecy
    + Integrity
    + Confidentiality
    + Forward secrecy (using ephemeral Diffie Hellman)

+ Handshake, Change Cipher Spec, Alert, Application Data, Heartbeat subprotocols


----
## Authentication (X.509)

+ Client has set of trust anchors (CA certificates)

+ Server has certificate signed by a CA

+ During handshake client receives server certificate chain

+ Client verifies that server certificate is signed by a trust anchor


----
## Handshake

Showing live at

````
cd mirage/tls-demo-server
./main.native
````

[https://127.0.0.1:4433](https://127.0.0.1:4433)


----
## Attacks

+ Apple's "goto fail"

+ Heartbleed

+ "Change cipher suite" message

+ Timing attacks (Lucky13, Bleichenbacher, ..)


----
## OCaml-TLS stats

+ Interoperability (server served > 50000 sessions)

+ Missing features: client authentication, session resumption, ECC ciphersuites

+ Performance: roughly 5 times slower than OpenSSL, but most time spent in C (3DES)


----
## OCaml-TLS Future

+ Prepare another release

+ Performance improvements

+ Implement missing features

+ Finish porting to Mirage directly on Xen

+ Establish trust into OCaml-TLS: please read our code!


----
## Code statistics

+ Disclaimer: ``cloc`` statistics, use with a grain of salt

+ Linux kernel, glibc (1187), apache (209), OpenSSL (354): 17553kloc code (mostly C)

+ Mirage OS, cohttp, OCaml-TLS: 125kloc (75 C, 43 OCaml, 7 assembly)
   + 26 C: OCaml runtime
   + 17 C: MiniOS
   + 22 C: OpenLibm
   + 8 C + 7 asm: gmp


----
## Trusted Code Base

+ Linux network device driver (separate Xen domain)
+ Xen hypervisor
+ OpenLibm math library
+ MiniOS
+ GNU multiple precision library
+ OCaml runtime
+ OCaml and C compiler
+ Various OCaml libraries: cstruct, zarith, cohttp, x509, asn1, tls, nocrypto


----
## Conclusion

+ Operating systems in a functional language is fun and achievable!

+ Working hard on support for various protocols

+ Join the #nolibc movement

+ Everything BSD-licensed, and available via OPAM

+ [Blog series about OCaml-TLS http://openmirage.org/blog/introducing-ocaml-tls](http://openmirage.org/blog/introducing-ocaml-tls)

+ [http://openmirage.org](http://openmirage.org)


----
## Planned Research

+ Language based techniques for constant time behaviour (information flow research?)

+ Automated specification-covering TLS test generation

+ Expose OCaml-TLS as C shared object

+ TCP/IP specification-covering test generation (using HOL formalisation of TCP/IP)


----
## Thanks

+ David Kaloper (co-author of TLS, nocrypto, ASN.1, X.509)
+ Anil Madhavapeddy
+ Peter Sewell
+ Richard Mortier, John Crowcraft, miTLS team, mirage team, ...
+ [http://openmirage.org](http://openmirage.org)
