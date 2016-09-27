open Mirage

let fs_key = Key.(value @@ kv_ro ())
let assetsfs = generic_kv_ro ~key:fs_key "../assets"
let slidesfs = generic_kv_ro ~key:fs_key "../slides"

let stackv4 = generic_stackv4 default_console tap0
let httpsvr = http_server @@ conduit_direct ~tls:false stackv4

let libraries = [ "tyxml" ]
let packages = [ "tyxml" ]
let http_job =
  foreign ~libraries ~packages "Server.Main"
    (clock @-> http @-> kv_ro @-> kv_ro @-> job)

let () =
  register ~libraries ~packages "decks" [
    http_job $ default_clock $ httpsvr $ assetsfs $ slidesfs
  ]
