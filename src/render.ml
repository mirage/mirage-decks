let preamble = {__|<!DOCTYPE html>
<!--[if IE 8]><html class=\"no-js lt-ie9\" lang=\"en\" ><![endif]-->
<!--[if gt IE 8]><!--><html class=\"no-js\" lang=\"en\" ><!--<![endif]-->
|__}

let to_string ?(preamble=preamble) html =
  Format.asprintf "%s%a" preamble (Tyxml.Html.pp ()) html
