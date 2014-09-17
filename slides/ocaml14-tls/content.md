<!-- .slide: class="title" -->

##Transport Layer Security purely in OCaml

<u>Hannes Mehnert</u> and David Kaloper<br/>
University of Cambridge<br/>
<br/>
OCaml 2014, G&ouml;teborg, 5th Sep 2014

[https://github.com/mirleft/ocaml-tls/](https://github.com/mirleft/ocaml-tls/)<br/>


----

## Current state

+ Mirage operating system uses OCaml

+ Memory safety, abstraction, modularity


----

## Current state

+ Mirage operating system uses OCaml

+ Memory safety, abstraction, modularity

+ But for security call unsafe insecure C code??

+ Each line of C code is one line too much!!


----

## Motivation

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

Showing live!


----

## Attacks

+ Apple's "goto fail"

+ Heartbleed

+ "Change cipher suite" message

+ Timing attacks (Lucky13, Bleichenbacher, ..)


----

## OCaml-TLS stats

+ Code size: OpenSSL 350kloc, LibreSSL 300kloc, PolarSSL 50kloc, <b>OCaml-TLS 10kloc</b>

+ Interoperability (server served > 50000 sessions)

+ Missing features: client authentication, session resumption, ECC ciphersuites

+ Performance: roughly 5 times slower than OpenSSL, but most time spent in C (3DES)


----

## Future

+ Prepare another release

+ Performance improvements

+ Generation of comprehensive test suites

+ Implement missing features

+ Finish porting to Mirage directly on Xen

+ Establish trust into OCaml-TLS: read our code!


----

## Conclusion

+ Took roughly 3 months to implement (still polishing)

+ Modular functional language encapsulates protocol logic (separation of side effects)

+ Nocrypto library (`opam install nocrypto`)

+ ASN.1, X.509 libraries (`opam install asn1-combinators x509`)

+ TLS (`opam install tls`) with mirage and lwt frontends

+ [Blog series http://openmirage.org/blog/introducing-ocaml-tls](http://openmirage.org/blog/introducing-ocaml-tls)