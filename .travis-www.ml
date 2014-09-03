open Mirage

let ipaddr = 
   let address = Ipaddr.V4.of_string_exn "46.43.42.134" in
   let netmask = Ipaddr.V4.of_string_exn "255.255.255.128" in
   let gateways = [Ipaddr.V4.of_string_exn "46.43.42.129" ] in
   { address; netmask; gateways }

(* If the Unix `MODE` is set, the choice of configuration changes:
   MODE=crunch (or nothing): use static filesystem via crunch
   MODE=fat: use FAT and block device (run ./make-fat-images.sh) *)
let mode =
  try match String.lowercase (Unix.getenv "FS") with
    | "fat" -> `Fat
    | _     -> `Crunch
  with Not_found -> `Crunch

let fat_ro dir =
  kv_ro_of_fs (fat_of_files ~dir ())

(* In Unix mode, use the passthrough filesystem for files to avoid a huge
   crunch build time *)
let fs =
  match mode, get_mode () with
  | `Fat,    _     -> fat_ro "../assets"
  | `Crunch, `Xen  -> crunch "../assets"
  | `Crunch, `Unix -> direct_kv_ro "../assets"

let tmpl =
  match mode, get_mode () with
  | `Fat,    _     -> fat_ro "../slides"
  | `Crunch, `Xen  -> crunch "../slides"
  | `Crunch, `Unix -> direct_kv_ro "../slides"

let net =
  try match Sys.getenv "NET" with
    | "direct" -> `Direct
    | "socket" -> `Socket
    | _        -> `Direct
  with Not_found -> `Direct

let dhcp =
  try match Sys.getenv "DHCP" with
    | "" -> false
    | _  -> true
  with Not_found -> false

let stack console =
  match net, dhcp with
  | `Direct, true  -> direct_stackv4_with_dhcp console tap0
  | `Direct, false -> direct_stackv4_with_static_ipv4 console tap0 ipaddr
  | `Socket, _     -> socket_stackv4 console [Ipaddr.V4.any]

let server =
  conduit_direct (stack default_console)

let http_srv =
  let mode = `TCP (`Port 80) in
  http_server mode server

let main =
  let libraries = [ "cow.syntax"; "cowabloga" ] in
  let packages = [ "cow";"cowabloga" ] in
  foreign ~libraries ~packages "Server.Main"
    (console @-> kv_ro @-> kv_ro @-> http @-> job)

let () =
  register "www" [
    main $ default_console $ fs $ tmpl $ http_srv
  ]
