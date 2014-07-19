open Cow

module Date = struct

  type t = {
    year: int;
    month: int;
    day: int;
  } with xml

  let t (year, month, day) = { year; month; day }

  let to_html d =
    let xml_of_month m =
      let str = match m with
        | 1  -> "Jan" | 2  -> "Feb" | 3  -> "Mar" | 4  -> "Apr"
        | 5  -> "May" | 6  -> "Jun" | 7  -> "Jul" | 8  -> "Aug"
        | 9  -> "Sep" | 10 -> "Oct" | 11 -> "Nov" | 12 -> "Dec"
        | _  -> "???" in
      <:xml<$str:str$>>
    in
    <:xml<
        <div class="date">
          <div class="month">$xml_of_month d.month$</div>
          <div class="day">$int:d.day$</div>
          <div class="year">$int:d.year$</div>
        </div>
      >>

  let compare {year=ya;month=ma;day=da} {year=yb;month=mb;day=db} =
    match ya - yb with
    | 0 -> (match ma - mb with
        | 0 -> da - db
        | n -> n
      )
    | n -> n

end

type t = {
  permalink: string;
  given: Date.t;
  speakers: Atom.author list;
  venue: string;
  title: string;
}

let compare a b = Date.compare b.given a.given
