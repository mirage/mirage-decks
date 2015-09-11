<!-- .slide: class="title" -->

# Persistent Networking with Irmin and MirageOS

Mindy Preston <small>University of Cambridge</small>
[@mindypreston](https://twitter.com/mindypreston)

_on behalf of:_ Magnus Skjegstad, Thomas Gazagnaire, Richard Mortier and Anil Madhavapeddy

[https://irmin.io](https://irmin.io)<br/>
[https://mirage.io](https://mirage.io)<br/>
[http://decks.openmirage.org/ocaml15-irminnet/](http://decks.openmirage.org/ocaml15-irminnet/)

<small>
  Press &lt;esc&gt; to view the slide index, and the &lt;arrow&gt; keys to
  navigate.
</small>


----

## "Network Datastores"

* ARP cache
* NAT table
* DNS cache
* DHCP client lease status
* IP fragmentation/reassembly
* TCP connection state, seq/ack numbers, window status
* upstream network: DHCP server lease status, IDS/IPS, ...


----

## MirageOS + Irmin = <3

+ MirageOS: library operating system: code like networking and storage looks like your application-layer code
  + Lift data structures out of kernel memory

+ Irmin: library for persistent stores with built-in snapshot, branching, & reverting mechanisms
  + Mediate and track access to data structures in a type-aware way


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

Multiple code paths to access the cache:

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


## Irmin-Arp in Action

* Virtual network of 10 nodes with ARP stacks sending TCP messages back and forth
* Git-FS backend for introspection and modification
* ARP:
  - initial broadcast
  - subsequent request/reply
  - entries expire after 60s


## Another Demo: NAT + Irmin_http

* CubieTruck has two network interfaces: WiFi and Ethernet
* Xen hypervisor assigns a virtual bridge to each
* MirageOS unikernel has an interface on each (plus a management interface)
* Unikernel acts as a NAT device
  * Network packets on the WiFi interface are rewritten to appear to come from the Ethernet interface


## NAT + ARP

* NAT: translate packets from one (src_ip, src_port, dst_ip, dst_port) to another (src_ip, src_port, dst_ip, dst_port)
* But IPs change!
* Instead of lengthy connection timeout and retry, an aware NAT table could just remap them


## Issues

* "the database that never forgets"
* access control
  * certificates and restricted channels to access the store are very coarse-grained


## Performance

* Run NATting unikernel on local Xen host across two virtual bridges (xenbr0, xenbr1) with 32MB of RAM
* Run a DNS server on xenbr0
* Run a client unikernel on xenbr1
* Client unikernel resolves a name using the DNS server on xenbr0
* Measure time delta between packet arrival on xenbr0 and xenbr1
* DNS queries require table entry insertion; DNS responses only require a lookup


## MirageOS Hashtable NAT:

+ max latency for lookup: ~140us
+ max latency for insertion: ~450us


## MirageOS Hashtable NAT:

<p class="center">
  <img src="hashtable_32mb_udp_latency.png"/>
</p>


## MirageOS Irmin NAT:
+ max latency for lookup: ~220us
  + (down from 450us last week)
+ max latency for insertion: ~10,000us (!)
  + (down from 25,000us yesterday)


## MirageOS Irmin NAT:

<p class="center">
  <img src="irmin_32mb_udp_latency.png"/>
</p>


## Imagined Futures

+ Integration between XenStore and MirageOS unikernels


## Thanks!

* Questions?

<small>
+ Some of the research leading to these results has received funding from the European Union's Seventh Framework Programme FP7/2007-2013 under the UCN project, grant agreement no 611001.
</small>

