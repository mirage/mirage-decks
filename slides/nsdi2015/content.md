<!-- .slide: class="title" -->

# __Jitsu__: Just-In-Time Summoning of Unikernels

Anil Madhavapeddy <small>University of Cambridge</small>
[@avsm](http://twitter.com/avsm)

Magnus Skjegstad <small>University of Cambridge</small>
[@MagnusS](http://twitter.com/magnuss)

_on behalf of:_ Thomas Gazagnaire, David Scott, Richard Mortier, Thomas Leonard, David Sheets, Amir Chaudhry, Jon Crowcroft, Balraj Singh, Jon Crowcroft, Ian Leslie

[http://openmirage.org/](http://openmirage.org/)<br/>
[http://decks.openmirage.org/nsdi2015/](http://decks.openmirage.org/nsdi2015/#/)

<small>
  Press &lt;esc&gt; to view the slide index, and the &lt;arrow&gt; keys to
  navigate.
</small>


----

## The IoT Spring

<p class="center stretch">
<img src="iot-stuff.png" />
</p>


## Faster than Light?

Many network services suffer as _latency_ increases, e.g.,

+ Siri
+ Google Glass

...to say nothing of how they operate when disconnected.

> So let's move the computation closer to the data and
> reduce dependency on a remote cloud

<!-- .element: class="fragment" data-fragment-index="1" -->


## The Past Year

* **Heartbleed**: 17% of *all* Internet secure web servers vulnerable to a single bug. Described as "catastrophic" by Bruce Schneier.
* **ShellShock**: CGI, Web, DHCP all vulnerable to code execution. Millions of sites potentially vulnerable.
* **JP Morgan**: 76 million homes and 8 million small businesses exposed in a single data breach.
* **Target**: 40 million credit cards stolen electronically.

> System security is in a disastrous state, and seemingly getting worse with IoT.


## Stronger than steel?

We earlier noted the many recent network security problems:

+ Heartbleed
+ Shellshock

...and such bugs will reoccur, now in our homes, cars, fridges

> So let's build fundamentally more robust edge network services

<!-- .element: class="fragment" data-fragment-index="1" -->


----

## The Unikernel Approach

> Unikernels are specialised virtual machine images compiled from the full stack
> of application code, system libraries and config

<br/>
This means they realise several benefits:
<!-- .element: class="fragment" data-fragment-index="1" -->

+ __Contained__, simplifying deployment and management.
+ __Compact__, reducing attack surface and boot times.
+ __Efficient__, able to better use host resources.

<!-- .element: class="fragment" data-fragment-index="1" -->


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

Unikernels can boot and respond to network traffic in
real-time.

<img src="boot-time.png" />

<small>*See Also:* HotCloud 2011, ASPLOS 2013, Communications of the ACM Jan 2014</small>


----

## Contributions

Built platform support required for ARM cloud deployments:

* **Ported unikernels to the new Xen/ARMv7 architecture**
  * *Runs VMs on commodity ARM hardware (Cubieboard)*

* **Constructed Jitsu toolstack to launch unikernels on-demand**
  * *Race-free booting of unikernels in response to DNS*

* **Evaluated *vs* alternative service isolation techniques**
  * *E.g. Docker containers*


## Artifact: [Mirage OS 2.0](http://openmirage.org/)

These slides were written using MirageOS on Mac OS X:

- They are hosted in a **2MB Xen unikernel** written in statically type-safe
  OCaml, including device drivers and network stack.

- Their application logic is just a **couple of source files**, written
  independently of any OS dependencies.

- Running on an **ARM** CubieBoard2, and hosted on the cloud.

- Binaries small enough to track the **entire deployment** in Git!


## Artifact: [Mirage OS 2.0](http://openmirage.org/)

<p class="stretch center">
  <img src="decks-on-arm.png" />
</p>


----

## Jitsu!

> __Just-in-Time Summoning of Unikernels__

A toolstack to launch unikernels on-demand with negligible latency:

+ __Performance improvements__ to Xen's boot process & toolstack
+ __Conduit__, shared-memory communication between unikernels
+ __Synjitsu__ and the Jitsu Directory Service


## Jitsu Architecture

<p class="center stretch">
  <img src="jitsu-arch.png" />
</p>


## Xen/ARM Toolstack

+ __Removal of `libc`__ reduces attack surface and image size
  + Did need to add floating point formatting routines back, copied from `musl`
  `libc`
+ Xen PV driver model only &ndash; __no hardware emulation__
  + ARM does not need all the legacy support of Xen/x86
+ __Deserialising device attachment__ and boot transactions
  + Custom merge function in the OCaml XenStore implementation reduces spurious
    conflicts during boot
  + The backend runs _dom0_ `VIF` hotplug scripts in parallel with the domain
    builder


## Deserialisation

<div>
  <div style="max-width:48%" class="left stretch">
    <img src="boot-txns.png" />
  </div>
  <div style="max-width:48%" class="right">
    <img src="jitsu-boot-time.png" />
  </div>
</div>

_Improving XenStore parallelism addresses scaling problems, and optimising boot
process dramatically reduces boot time_


## Conduit

+ Establishes __zero-copy shared-memory__ pages between peers
  + Xen grant tables map pages between VMs (`/dev/gntmap`), synchronised via
    event channels (`/dev/evtchn`)
+ Provides a __rendezvous facility__ for VMs to discover named peers
  + Also supports unikernel and legacy VM rendezvous
+ Hooks into higher-level __name services__ like DNS

+ Compatible with the __`vchan`__ inter-VM communication protocol

Code: <https://github.com/mirage/ocaml-conduit>


## Rendezvous

<div>
  <div style="max-width:58%" class="left">
    <ul>
      <li>XenStore acts as an incoming connection queue</li>
      <li>
        Client requests are registered in a new `/conduit` subtree
      </li>
      <li>
        Client picks port and writes to the target `listen` queue
      </li>
      <li>
        Connection metadata (grant table, event channel refs) is written into
        `/local/domain/domid/vchan`
      </li>
    </ul>
    <p>...and the data flows</p>
  </div>
  <div style="max-width:40%" class="right">
    <img src="xs-conduit.png" />
  </div>
</div>


## Jitsu Directory Service

Performs the role of Unix's `inetd`:

+ Jitsu VM launches at boot time to handle name resolution (whether local via
  a well known `jitsud` Conduit node in XenStore or remote via DNS)

+ When a request arrives for a live unikernel, Jitsu returns the appropriate
  endpoint

+ If the unikernel is not live, Jitsu boots it, and acts as proxy until the
  unikernel is ready


## Masking boot latency

<p class="center stretch">
  <img style="width:75%" src="synjitsu.png" />
</p>

_By buffering TCP requests into XenStore and then replaying, Synjitsu
parallelises connection setup and unikernel boot_


## Masking boot latency

<div style="max-width:49%" class="left">
  <p>
    Jitsu optimisations bring boot latency down to __~30&mdash;45 ms__ (x86) and
    __~350&mdash;400 ms__ (ARM).
  </p>
  <ul>
    <li>
      Docker time was 1.1s (Linux), 1.2s (Xen) from an SD card
    </li>

    <li>
      Mounting Docker's volumes on an `ext4` loopback volume inside of a `tmpfs`
      reduced latency but often terminated early due to many buffer IO, `ext4`
      and `VFS` errors
    </li>
  </ul>
</div>

<div style="max-width:48%" class="right">
  <img src="jitsu-startup.png" />
  <img src="jitsu-docker.png" />
</div>


----

## Demo

TODO 

<https://www.dropbox.com/s/ra5qib321d53nfi/nsdi_screencast.mov?dl=0>


----

## Ongoing Work

* **Multiprotocol Synjitsu**
  * Extend to the SSL/TLS handshake to further pipeline secure connections
  * Add vanilla TCP load balancing support
* **Wide area redirection**
  * DNS proxy to redirect to cloud if ARM node is down
  * First ARM cloud hosting via [Scaleway](http://scaleway.com)
* **More platforms**
  * Integrating [rump kernels](http://rumpkernel.org) to boot without Xen
  * Starting real home router deployments with Technicolor


## Get Involved!

Unikernels are an incredibly interesting way to code functionally at scale.
Nothing stresses a toolchain like building a whole OS.

- **Choices**: [Mirage OS](http://openmirage.org) in OCaml, [HaLVM](http://halvm.org) in Haskell, Rump Kernels or OSv for compatibility, ClickOS for routing.
- **Scenarios**: Static websites, dynamic content, custom routers.
- **Performance**: There's no hiding behind abstractions.  HalVM *vs* Mirage is a fun contest in evaluating language abstraction cost.

> Most important: need contributors to build the library base of safe protocol implementations (TLS has been done!)


## <http://openmirage.org/>

A Linux Foundation Incubator Project lead from the University of Cambridge and Citrix Systems.

Featuring blog posts on new features by:

[Amir Chaudhry](http://amirchaudhry.com/),
[Thomas Gazagnaire](http://gazagnaire.org/),
[David Kaloper](https://github.com/pqwy),
[Thomas Leonard](http://roscidus.com/blog/),
[Jon Ludlam](http://twitter.com/jonludlam),
[Hannes Mehnert](https://github.com/hannesm),
[Mindy Preston](https://github.com/yomimono),
[Dave Scott](http://dave.recoil.org/),
and [Jeremy Yallop](https://github.com/yallop).

<p style="font-size: 40px; font-weight: bold;
          display: float; padding: 2ex 0; text-align: center">
  Thanks for listening! Questions?
  <br />
  Contributions very welcome at [openmirage.org](http://openmirage.org)
  <br />
  Mailing list at <mirageos-devel@lists.xenproject.org>
</p>

