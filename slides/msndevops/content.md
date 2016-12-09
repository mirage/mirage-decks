<!-- .slide: class="title" -->

# Unikernels, MirageOS, Library Operating Systems, You

@mindypreston

[https://mirage.io](https://mirage.io)
[https://somerandomidiot.com](https://somerandomidiot.com)

```ocaml
                        ##         .
                  ## ## ##        ==
               ## ## ## ## ##    ===
           /"""""""""""""""""\___/ ===
      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
           \\______ o           __/
             \\    \\         __/
              \\____\\_______/

```
[http://docker.io](http://docker.io)


----

# Where To?

+ non-uni-kernels
+ "Library Operating System"
+ composing unikernels
+ fun things to do with libraries
+ wilder realities than so far imagined


----

## By Way of Contrast

```
+------------------------+---------------+
| User-level Application | External Libs |
+------------------------+---------------+
       API in Your Language
+----------------------------------------+
|     Runtime (or not!), shared libs     |
+----------------------------------------+
      Sockets, syscalls, & such       
+----------------------------------------+
| scheduler, memory management, power,   |
| network, filesystems, clock, entropy,  |
| keyboard, video, ...                   |
+----------------------------------------+
| Hypervisor                             |
+----------------------------------------+
| Silicon bits                           |
+----------------------------------------+
```


----

## the kernel is privileged

+ the kernel defines the API it'll answer to
+ your language's bindings or runtime have to talk on its terms


----

## the kernel is privileged

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

```c
int socket(int domain, int type, int protocol);
int connect(int sockfd, const struct sockaddr *addr,
              socklen_t addrlen);
```


----

## the kernel is different

+ different assumptions, APIs, and invariants
+ probably a different language than you're used to
+ different update/upgrade & maintenance system than anything else


----

## the kernel wants us to think it's important

+ support for hardware (ex: drivers)
+ support for software (ex: filesystems)
+ management of resources
+ privilege separation


----

## let's look at that stack again

```
+------------------------+---------------+
| User-level Application | External Libs |
+------------------------+---------------+
       API in Your Language
+----------------------------------------+
|     Runtime (or not!), shared libs     |
+----------------------------------------+
      Sockets, syscalls, & such       
+----------------------------------------+
| scheduler, memory management, power,   |
| network, filesystems, clock, entropy,  | (kernel)
| keyboard, video, ...                   |
+----------------------------------------+
| Hypervisor                             |
+----------------------------------------+
| Silicon bits                           |
+----------------------------------------+
```


----

## virtual machines

+ something that looks like an entire computer (and might think it is)... but it isn't
+ run >1 "computer" (operating system + other stuff) on only 1 physical machine


----

## hypervisor

+ software that provides the illusion of isolation to virtual machines
+ generally, you also want it to support hardware and manage resources


----

## stack revisited

```
+------------------------+---------------+
| User-level Application | External Libs |
+------------------------+---------------+
       API in Your Language
+----------------------------------------+
|     Runtime (or not!), shared libs     |
+----------------------------------------+
      Sockets, syscalls, & such       
+----------------------------------------+
| scheduler, memory management, power,   |
| network, filesystems, clock, entropy,  | (kernel)
| keyboard, video, ...                   |
+----------------------------------------+
| scheduler, memory management, power,   |
| network, filesystems, clock, entropy,  | (hypervisor)
| keyboard, video, ...                   |
+----------------------------------------+
| Silicon bits                           |
+----------------------------------------+
```


----

## DRY

```
+---------------------------------------------------------+
| User-level Application                                  |
+---------------------------------------------------------+
                 API in Your Language
+---------------------------------------------------------+
| Networking | Storage | Timekeeping | Randomness | ....  |
+------------+---------+-------------+------------+-------+
                 API in Your Language
+---------------------------------------------------------+
| Application runtime                                     |
+---------------------------------------------------------+
| Hypervisor                                              |
+---------------------------------------------------------+
| Silicon bits                                            |
+---------------------------------------------------------+
```


----

## that's what a unikernel is

+ our rad application
+ libraries that know how to talk to hypervisor
+ (and maybe a runtime)


----

## library operating system

* "library operating system" is the bunch of libraries that help us write applications that can run without a traditional OS
* if you want to run an application you use in your library with a library operating system, let's talk!


----

## Composing Libraries into an Operating System

```ocaml
type output =
  | Unix_process
  | Xen_unikernel
  | Virtio_kvm_unikernel
  | Ukvm_unikernel

val compose : application -> dependencies list ->
              implementations list -> output
```


----

## why that's rad

+ we can write, read, and debug those libraries in a language we're used to, with the abstractions & invariants we're used to
+ systems code for everyone :D


----

## some personal experiences

+ the library operating system project I work with is called MirageOS
+ it's a framework for generating unikernels in OCaml
+ (OCaml is a programming language I like)


----

## demo time

* what's that URL that's hosting these slides, anyway?


----

## what we built & ran

* an artifact that runs directly on a hypervisor which we specified entirely in the language we wrote the application in
* if we want to run on a different hypervisor or with different libraries, we need to rebuild it entirely
* (the "with different libraries" includes "with a different patchset")


----

## operating system is libraries: great

* if I don't like how something works, I can rewrite it
* if I don't like an API, I can substitute my own
* if something doesn't work, I'm more equipped to find out why and fix it
* the set of stuff I have to care about patching is way, way smaller


----

## we have libraries of operating system: great

* I can use these libraries in other contexts
* testing gets way way easier


----

## what isn't fixed

* I still have to care about the security of my application & the libraries it uses
* I still have to write applications that do the right thing
* I still need something to run my code on
* sometimes there are bugs :(
* I like a programming language that isn't very popular


----

## library operating systems

+ there are a lot of them, and most aren't in OCaml
+ some are better fits for more traditional ways of thinking about & dealing with applications


----

## arbitrary legacy stuff

+ Rump: NetBSD kernel as a set of userspace libraries
  + Rumprun: link your application against these libraries automatically
+ OSv: POSIX interfaces to freshly-written userspace library implementations of kernel functionality


----

## other language-specific unikernels

* HaLVM (Haskell)
* IncludeOS (C++)
* Ling (Erlang)
* ... [unikernel.org]


----

## future stuff

* solo5, bhyve/xhyve/hyperkit, and the lightweight hypervisor (zOMG MirageOS 3)
  - minimize the size of the hypervisor layer too!
* what's the difference between a unikernel running in a lightweight hypervisor & a process running in an OS?


----

## boundaries and isolation

+ we trust(*cough*) hypervisors to provide stronger isolation than traditional operating systems
+ a lot of people want massively disaggregated and decentralized infrastructure


----

## what is a unikernel?

+ one answer: an attempt to do a better job of aligning systems abstractions to application abstractions
+ another answer: an attempt to democratize systems programming
+ another answer: a refusal to accept the authority of the monolithic operating system
+ another answer: containers are so last year


----

## thanks :)

+ these slides: https://github.com/yomimono/mirage-decks, mirage-dev branch
+ stuff about mirageOS: https://mirage.io
+ stuff about unikernels: https://unikernel.org
+ me: @mindypreston on twitter , @yomimono on github

----
