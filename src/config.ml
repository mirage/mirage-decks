open Mirage

let assets =
  Driver.KV_RO {
    KV_RO.name = "assets";
    dirname    = "../assets";
  }

let slides =
  Driver.KV_RO {
    KV_RO.name = "slides";
    dirname    = "../slides";
  }

let http =
  Driver.HTTP {
    HTTP.port  = 80;
    address    = None;
    ip         = IP.local Network.Tap0;
  }

let () =
  Job.register [
    "Site.Main", [Driver.console; assets; slides; http]
  ]
