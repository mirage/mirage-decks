open Tyxml.Html

module Date = struct

  type t = {
    year: int;
    month: int;
    day: int;
  }

  let t (year, month, day) = { year; month; day }

  let to_html d =
    let string_of_month = function
        | 1  -> "Jan" | 2  -> "Feb" | 3  -> "Mar" | 4  -> "Apr"
        | 5  -> "May" | 6  -> "Jun" | 7  -> "Jul" | 8  -> "Aug"
        | 9  -> "Sep" | 10 -> "Oct" | 11 -> "Nov" | 12 -> "Dec"
        | _  -> "???"
    in
      div ~a:[a_class ["date"]] [
        div ~a:[a_class ["month"]] [ pcdata (string_of_month d.month) ];
        div ~a:[a_class ["day"]] [ pcdata (string_of_int d.day) ] ;
        div ~a:[a_class ["year"]] [ pcdata (string_of_int d.year) ] ;
      ]

  let compare {year=ya; month=ma; day=da} {year=yb; month=mb; day=db} =
    match ya - yb with
    | 0 -> (match ma - mb with
        | 0 -> da - db
        | n -> n
      )
    | n -> n

end

type style =
  | Reveal240
  | Reveal262 of string option

type t = {
  permalink: string;
  given: Date.t;
  speakers: People.t list;
  venue: string;
  title: string;
  style: style;
}

let compare a b = Date.compare b.given a.given
