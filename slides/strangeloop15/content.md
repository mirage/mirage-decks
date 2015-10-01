<!-- .slide: class="title" -->

# Non-Imperative Network Programming

Mindy Preston <small>University of Cambridge</small>
[@mindypreston](https://twitter.com/mindypreston)

[https://www.somerandomidiot.com](https://www.somerandomidiot.com)<br/>


----

## Disclaimers

Opinions expressed are mine alone.

I'm new to FP!


----

## Contents

* Definitions
* Network Interfaces As We Learn Them
* Interfaces as Module Types
* Nice Things to Have
* Questions


----

## "Non-Imperative"

Generally, the properties I'm looking for are:

> * it is *independent*: it computes irrespective of other computation state
> * it is *stateless*: each action is unrelated to any previous action
> * it is *deterministic*: the same inputs will return the same outputs

<!--TODO: check spelling, link-->&mdash;[Michael R. Bernstein, "What Is Declarative Programming"](http://michaelrbernste.in/2013/06/20/what-is-declarative-programming)

We're going to get to "more declarative", but not to "non-imperative".

Note:
I'd also like to attempt to explain what I mean by "non-imperative".  I run in circles that throw the term "declarative" around a lot, but this is really what I'm trying to get at -- interfaces and code that fulfill these properties.  We're going to examine some approaches that are *more* declarative than the network programming paradigms we traditionally teach in systems courses, but we're not going to get all the way to a working interface that unambiguously fulfills all these criteria.


----

## "Network Programming"

The part of your code that is concerned with sending messages to, and receiving messages from, programs running on other computers ("nodes") on the opposite end of >= 1 network link.

```text
+======================================+
|  Application (e.g., DNS resolver)    |
+======================================+
|  Transport   (e.g., UDP)             |
+======================================+
|  Network     (e.g., IPv4)            |
+======================================+
|  Link        (e.g., Ethernet)        |
+======================================+
|  Physical    (e.g., 100Mb copper)    |
+======================================+
```

Note:
I'd also like to clarify what I mean by "network programming".  I'm talking about the layers of abstractions we use to send messages between computers over potentially lossy network links.  

Most of the time, application programmers don't get to think about the full depth of this stack.  We have a different abstraction presented to us, because the operating system represents the network to us with certain abstractions.

I'm not qualified to talk about distributed systems, so there will be no photographs of things on fire in this talk.


----

## Contents

x Definitions

* **Network Interfaces As We Learn Them**
* Interfaces as Module Types
* Nice Things to Have
* Questions


----

## What We Traditionally Get

Traditional OSes want to handle networking for you.

```
     Application         
        |  ^
        v  | 
       Sockets           
        |  ^
        v  |
   Kernel Memory        
        |  ^
        v  |
(Virtual) Network Hardware     
```

Note:
In traditional operating system architectures, the application's access to the network is mediated by the operating system and the API it chooses to present to the application.  Most of the time, that's the sockets API.  By accessing the sockets API, the application can request that some stuff happens in the kernel to get the data out to network hardware and onto the wire.  There's not really another choice for doing this in Unix, for the most part.  If you're doing network programming in a UNIX-y environment, at some point it's going through sockets.

The sockets API was originally designed for C, but most languages have their own interfaces for it.  Let's have a quick look at it in OCaml and see whether the functions look like they might be something that's independent, stateless, and deterministic.


----

## Some Socket Functions

A selection from OCaml:

```ocaml
val socket : socket_domain -> socket_type -> int ->
             file_descr
(** create a new socket with
   a given network layer implementation,
   transport layer implementation,
   and (optional) protocol type *)

val connect : file_descr -> sockaddr -> unit
(** connect a socket to an address; 
    will throw exceptions for non-socket file_descr
    or connection errors *)
```

Note:

Here's a small selection from the representation of the sockets API in OCaml's Unix module.  
That `connect` isn't very declarative, is it?  It does a side-effecting operation on the file_descr we pass in.  (Incidentally, errors are fairly likely when calling this function -- this is usually the point in an application's control flow where someone realizes there's a remote outage.)


----

## What Did We Specify?

```ocaml
val socket : socket_domain -> socket_type -> int ->
             file_descr
(** create a new socket with
   a given network layer implementation,
   transport layer implementation,
   and (optional) protocol type *)
```

* what kind of network we expect to talk on
* what sort of transport (i.e., reliable/unreliable) we want
* some possible protocol disambiguation

Note:
Let's take a closer look at what we specified when we created this socket.  That was our chance to give some input to the network on how exactly we want the operating system to deal with our network traffic, but we didn't really get to say a whole lot, did we?


----

## Sockets, the OS, and Implicit State

There's a *lot* of implicit state.

```text
$ sudo sysctl net | wc -l
688
```

Note:
Interacting with the network through the operating system involves a lot of implicit state inferred by the operating system.  I've stuck here the output of a command that counts approximately how many tunable network parameters are being considered when I use the networking interface in my installation of Ubuntu.  688 is a lot!


----

## Implicit State

Our application might care about some of these!

```text
$ sudo sysctl net.core.somaxconn
net.core.somaxconn = 128
```

:(

Note:
I might not care about every one of those 688 settings when I'm running an application, but chances are pretty good that there's at least one in there that I care about.  For example, here's a setting limiting my operating system to 128 waiting incoming connections; if I'm trying to run a load balancer, I'll bet I want to change that number.  Moreover, I'll bet I always want that number changed on any machine that I might be running that load balancer on.

We have a lot of DevOps tools for attempting to make the values of settings like this consistent over time and over multiple machines.  They're all essentially out-of-band updates, which take place outside of the application.  My application wants that state, but it has no in-band way to demand it, and may not even have a nice interface for making sure it's set when it runs!


----

## Contents

x Definitions

x Network Interfaces As We Learn Them

* **Interfaces as Module Types**
* Nice Things to Have
* Questions


----

## Democratize Device Access

What if we could choose &mdash; or even make &mdash; our *own* abstractions?

```
      Application         
        |  ^
        v  | 
    Libraries We <3
        |  ^
        v  |
(Virtual) Network Hardware     
```

We could make whatever we wanted be implicit or explicit!

Note:
What if, instead of having the operating system mediate our access to the network hardware, we could choose from a bunch of different abstractions or maybe even build our own?


----

## How Can We Do It?

**Unikernels!**

Traditional OS:

* write your code
* compile for an operating system
* run on an operating system
  + (that's probably running on virtualized hardware)

Unikernels:

* write your code
* compile your code *into* an operating system
* run on virtualized hardware

Note:
Replace the process of compiling for a traditional operating system with compiling a unikernel!


----

## Abstractions For Everyone!

```
+============================+
| Application Code           |
+============================+
| Transport Layer Library    |
+============================+
| Network Layer Library      |
+============================+ ==> unikernel
| Link Layer Library         |
+============================+
| Virtual Network HW Library |
+============================+
| Language Runtime           |
+============================+
```

Note:
We still have to have some library that interfaces with virtual network hardware on possibly-imperative terms, but we can get to expressive, declarative code much lower in the stack than we could in a traditional OS.

We can also choose to use libraries that don't make decisions for us.  I could choose (or write!) a TCP library that required the user to set the maximum number of waiting connections, and make that number explicit throughout the program.


----

## Imposing Structure

If we want to make this change...

```
+=========================+     +=========================+  
| Transport Layer Library |     | Transport Layer Library |
+=========================+     +=========================+
| IPv4 Library            | ==> | IPv6 Library            |
+=========================+     +=========================+
| Link Layer Library      |     | Link Layer Library      |
+=========================+     +=========================+
```

it helps if the IPv4 and IPv6 libraries agree on common functions.

It helps even more if that agreement is expressed in the type system!


----

## Imposing Structure

Layers of the stack correspond to modules in MirageOS.

Interfaces between layers (which correspond to modules) are constrained by module types.

```ocaml
module type NETWORK (* virtual network hardware *)
module type ETHIF   (* ethernet layer *)
module type IPV4    (* IPv4 layer *)
module type IPV6    (* IPv6 layer *)
module type IP      (* IP layer (whether v4 or v6) *)
module type UDP     (* UDP (unreliable transport) layer *)
module type TCP     (* TCP (reliable transport) layer *)
module type FLOW    (* connections between endpoints *)
module type CHANNEL (* buffered byte-streams *)
```

Note:
Here's a quick overview of the definitions for module types we have, which largely correspond to network layers.  Applications can choose specific implementations to match these module types and use them interchangeably.


----

## How Do We Send Data?

Let's have a look at `FLOW`, the module type for connections between endpoints.

```ocaml
module type FLOW = sig
  type +'a io
  type buffer
  type flow
  type error

  val read : flow ->
    [ `Ok of buffer
    | `Eof | `Error of error ] io

  val write : flow -> buffer ->
    [ `Ok of unit
    | `Eof | `Error of error ] io
end
```

Note: We have some expected primitives -- read and write, with some polymorphic variants for errors.


----

## How Do We Send Data Reliably?

The `FLOW` module type doesn't have any way to make a variable of type `flow`.

But `module type TCP` does:

```ocaml
  val create_connection: t -> ipaddr * int ->
    [ `Ok of flow | `Error of error ] io
```

Note:
We can create TCP connections by invoking `create_connection`, then manipulate them with functions from whichever implementation we pick that fulfills FLOW.


----

## How Do We Run Servers?

`module type TCP` also contains an `input` function:

```ocaml
type callback = flow -> unit io
val input: t -> listeners:(int -> callback option) -> ipinput
(** [input t listeners] defines a mapping of threads
   that are willing to accept new flows on a given port.
   If the [callback] returns [None], the input function
   will refuse connections on a port. *)
```

We can define a function and then just register it for input!


----

## A Trivial Server

```ocaml
module Main (C: V1_LWT.CONSOLE) (S: V1_LWT.STACKV4) = struct
  let rec discard c flow =
    S.TCPV4.read flow >>= fun result ->
    match result with
    | `Eof -> report_and_close c flow "Closing normally."
    | `Error _ -> report_and_close c flow "Read error;
      closing."
    | `Ok _ -> discard c flow
  let start console stack =
     S.listen_tcpv4 stack ~port:9 (discard console);
     S.listen stack
end
```

Note:
`discard` reads forever, throwing away all data.  I've omitted `report_and_close` for space reasons, but its three lines are the only thing missing here -- this is otherwise a 100% complete unikernel ready for packaging.

Those who are familiar with OCaml may be asking "wait a minute, what's a `STACKV4`?"  Because it's pretty common to want a "full stack" from ethernet up to UDP and TCP, Mirage has a convenience module for providing that.  You can also explicitly ask for the libraries you'd like.


----

## Full-Stack Developers

Building the whole stack explicitly:

```ocaml
module Main (C: CONSOLE)(N: NETWORK) (Clock : V1.CLOCK)
            (Random: V1.RANDOM) = struct
  module E = Ethif.Make(N)
  module A = Arpv4.Make(E)(Clock)(OS.Time)
  module I = Ipv4.Make(E)(A)
  module U = Udp.Make(I)
  module T = Tcp.Flow.Make(I)(OS.Time)(Clock)(Random)
  module D = Dhcp_clientv4.Make(C)(OS.Time)(Random)(U)
```

Note:
Here's what it looks like to build up the modules representing the whole stack in Mirage.  OCaml allows us to parameterize modules with other modules, so each module takes its dependencies as an argument.  That way, we can consistently use whichever implementation the user passed to us.


----

## "Non-Imperative"

This is definitely *cool*, but is it any more *declarative*?

* The layers of our stack are *explicit* and *deliberate* (+deterministic)
* We can build applications in terms of pure functions over inputs (+stateless)
  * ...but we have side-effecting operations and local state within modules) (-stateless)
* We can define functions to process data without implicit external dependencies (++independent)

Note:
So is this a clear win over the traditional operating system and sockets?  I think we can make a better argument for the independence and determinism of code in this environment.  We can even make a case for its statelessness, if we're careful to draw the boundaries properly -- since modules may be keeping their own internal state, we can't make a claim to be "stateless", but we're certainly exposing state more appropriately than we were with a traditional OS and sockets.


----

## Contents

x Definitions

x Network Interfaces As We Learn Them

x Interfaces as Module Types

* **Nice Things to Have**

* Questions


----

## Why We Can Have Nice Things

Virtualized networks are further virtualizable!

We can give a parameterized network that has useful testing features:

* records traffic to memory (i.e., `tcpdump`)
* drops 15% of traffic (or 50%, or...)
* mangles messages in semantically interesting ways
* has latency of 10x what's expected
* responds to all messages with a ping flood


----

## More Nice Things We Can Have

We can pass random number generators that return from a constant stream!

* always get the same sequence, IP ID, etc numbers for TCP connections
* intentionally random behavior becomes predictable, so it's easier to spot variance


----

## Clocks Are A Thing

Fake clocks are great!

* see whether everything breaks when your clock goes backward one minute out of every ten
  * (spoiler: it will)
* speed up or entirely mock out timing-dependent operations like cache expiration


----

## Instrumentation

```ocaml
module B = Basic_backend.Make
module V = Lossy_netif.Make(B)
module E = Ethif.Make(V)
module A = Arpv4.Make(E)(Fast_clock)(Fast_time)
```

We can combine this with property-based testing to see whether dropped messages cause us to make invalid state transitions in TCP, or a number of other exciting things!


----

## Irmin

Irmin: library for persistent stores with built-in snapshot, branching, & reverting mechanisms

Mediate and track access to data structures in a type-aware way


----

## What Updating Irmin Looks Like

* Clone a new branch from primary
* Make edits to the branch
* Attempt to merge the branch back into primary


----

## Merges

```
$ git merge names
Auto-merging upnp.ml
CONFLICT (content): Merge conflict in upnp.ml
Automatic merge failed; fix conflicts and then commit the result.
$ grep -C2 ======= upnp.ml
<<<<<<< HEAD
    S.listen_udpv4 stack ~port:1901 output_packet;
=======
    S.listen_udpv4 stack ~port:1900 receive;
>>>>>>> names
```

+ Conflict is avoidable here: changes aren't mutually exclusive
+ Why doesn't Git know that?


## Example: ARP

A lookup table between `Ipaddr.V4.t` and `Macaddr.t` with expiration.

Multiple code paths to access the cache, two potentially side-effecting

+ Packet processing
+ Expiration
+ Lookups from External Entities


## Order Doesn't Matter

+ Set some rules for conflicts & always return something

```ocaml
  let merge _path ~(old : Nat_table.Entry.t Irmin.Merge.promise) t1 t2 =        
    let winner =                                                                
      match compare t1 t2 with                                                  
      | n when n <= 0 -> t1                                                     
      | n -> t2                                                                 
    in                                                                          
    Irmin.Merge.OP.ok winner  
```

+ History!


----

## Introspection/Editing with Git Tools

+ Flipping between in-memory and Git-backed FS:

```ocaml
module A_fs = Irmin_arp.Arp.Make(Irmin_unix.Irmin_git.FS)
module A_mem = Irmin_arp.Arp.Make(Irmin_mem.Make)   
module A = A_fs (* change to A_mem for in-memory store! *)
```


----

## Contents

x Definitions

x Network Interfaces As We Learn Them

x Interfaces as Module Types

x Nice Things to Have

* **Questions**


----

## Acknowledgements

Great thanks to Katherine Ye, David P.-Branner, Amy Hanlon, Rose Ames, Dan Luu, and Leah Hanson for help and encouragement.

Thanks to the wonderful folks at OCaml Labs.

Enormous gratitude to the Recurse Center and Outreachy.

Thank you, Strange Loop!
