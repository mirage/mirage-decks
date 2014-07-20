<!-- .slide: class="first" -->

# __Nymote__: Git Your <br/>**Own** Cloud Here

Anil Madhavapeddy <small>University of Cambridge</small>
[@avsm](http://twitter.com/avsm)

Richard Mortier <small>University of Nottingham</small>
[@mort\_\_\_](http://twitter.com/mort___)

[http://openmirage.org](http://openmirage.org/)
[http://nymote.org](http://nymote.org/)
[http://decks.openmirage.org/oscon14/](http://decks.openmirage.org/oscon14/#/)

<small>
  Press &lt;esc&gt; to view the slide index, and the &lt;arrow&gt; keys to
  navigate.
</small>


----

## Last year...

We told you about [Mirage OS Unikernels](http://openmirage.org/):

+ small, single-purpose networked appliances,

+ high-performance __and__ type-safe,

+ developed on Unix, deployed on Xen in the cloud


## This year...

Things have moved on apace!

Thanks to an army of contributors, we'll show you how **we've improved Mirage's
multiscale programming support**, so we can target:

  + Small ARM-based systems (smartphones, Internet-of-Things)
  + Browsers
  + The Cloud



## Introducing [Mirage OS 2.0](http://openmirage.org/)

These slides were written using Mirage on OSX:

- They are hosted in a **~1MB Xen unikernel written in statically type-safe
  OCaml**, including device drivers, TCP and HTTP stack.

- Their application logic is just a **couple of source files**, written as a
  portable functor independent of OS dependencies.

- You are seeing them as a unikernel **running here on a CubieBoard2**, and they
  are also hosted **on Amazon's EC2 public cloud**, with the binaries small
  enough to be tracked in Git.

[Mirage OS]: http://openmirage.org/


----

## [nymote.org](http://nymote.org/)

Why? Mirage is the foundation for the **personal cloud**:

+ We need to claim control over our online lives rather than abrogate it to The
  Cloud.

+ Doing so means we **all** need to be able to run **our own infrastructure**.

+ **Without having to become (Linux) sysadmins!**


## Stepping Back...

The enemy is **complexity**:

+ Applications are **deeply intertwined with system APIs**, and so lack
  portability.

+ Modern operating systems offer **dynamic support** for **multiple running
  applications**.

It all offers **too much scope for uncontrolled interaction**!

+ Ad hoc application configuration under `/etc/`
+ Choices of distribution and version
+ System configuration details, e.g., firewalls


## Multiscale Principles

Can we **disentangle applications from the operating system**?

- Break up core OS logic into modular libraries.

- Do not assume the presence of an ambient operating system kernel in
  application code.

- Target multiple platforms from a single development environment.


## Multiscale Programming

Can we disentangle applications from the operating system?

- The **OCaml** language gives us a **powerful module system** and simple
  runtime semantics.

- Applications become **functors** (functions from modules to modules) **across
  their OS dependencies**.

- Compilation becomes a **staged specialization** process that continues until
  the target is output.


----

## Compiler in the Middle

<p class="stretch">
  <img src="uniarch1a.png" />
</p>


## Compiler in the Middle

<p class="stretch">
  <img src="uniarch1b.png" />
</p>


## Compiler in the Middle

<p class="stretch">
  <img src="uniarch1c.png" />
</p>


## Compiler in the Middle

<p class="stretch">
  <img src="uniarch1d.png" />
</p>


## Orchestration

Unikernels are small and can be tracked in GitHub!

+ Mirage website changes are committed to **[mirage/mirage-www](https://github.com/mirage/mirage-www)**

+ Repository is built by **[Travis-CI](https://travis-ci.org)**

+ Output pushed to **[mirage/mirage-www-deployment](https://github.com/mirage/mirage-www-deployment)**

+ Cloud toolstack spawns VMs based on pushes there.

Our *entire* cloud-facing deployment is version-controlled from the source code
up!


----

## Wrapping Up




----

## <http://twitter.com/mort___>

<p style="font-size: 48px; font-weight: bold;
          display: float; margin-top: 3em; padding: 2ex 2em;
          text-align: center">
  Thanks! Questions?
</p>

<p style="font-size: 40px; display: float; padding: 2ex 2em; text-align: center">
  (...and please rate the talk!)
</p>
