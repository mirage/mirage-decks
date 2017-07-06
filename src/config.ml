open Mirage

let port =
  let doc = Key.Arg.info
      ~doc:"Listening port."
      ~docv:"PORT" ~env:"PORT" ["port"]
  in
  Key.(create "port" Arg.(opt int 80 doc))

let keys = Key.([ abstract port ])

let fs_key = Key.(value @@ kv_ro ())
let assetsfs = generic_kv_ro ~key:fs_key "../assets"
let slidesfs = generic_kv_ro ~key:fs_key "../slides"

let httpsvr =
  let stackv4 = generic_stackv4 default_network in
  http_server @@ conduit_direct ~tls:false stackv4

let packages = List.map package [
    "tyxml";
    "mirage-http";
    "logs";
    "mirage-logs";
    "magic-mime"
  ]

let http_job =
  foreign ~packages ~keys "Server.Main"
    (http @-> kv_ro @-> kv_ro @-> job)

let () =
  register ~packages "decks.openmirage.org" [
    http_job $ httpsvr $ assetsfs $ slidesfs
  ]
