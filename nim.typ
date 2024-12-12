// render a series of nim piles
#let nim = (..args,
  tile-size: (1em, 1em),
  spacing: (1em, 0.2em),
  hlabel: (i, pile) => pad(3pt)[#pile],
  vlabel: none,
  cell: (pile) => rect(fill: black),
  floor: () =>  line(length: 100%, stroke: 3pt)) => {

  let piles = args.pos();
  let height = calc.max(..piles);
  let (col-extra, col-extra-fn) = if vlabel != none {
    ((auto,), (vlabel(n),))
  } else {
    ((), ())
  };
  let row-extra = ();
  if floor != none {
    row-extra.push(auto)
  }
  if hlabel != none {
    row-extra.push(auto)
  }


  grid(
    column-gutter: spacing.at(0),
    row-gutter: spacing.at(1),
    columns: piles.len() * (tile-size.at(1),) + col-extra,
    rows: height * (tile-size.at(0),) + row-extra,
    ..range(0, height).map(n => {
      (
        ..if vlabel != none { (vlabel(n),) } else { () },
        ..range(0, piles.len()).map(
          pile => if piles.at(pile) >= height - n {
            cell(pile)
          } else {
            []
          }
        )
      )
    }).flatten(),
    ..if floor != none { (..col-extra.map(_ => []), grid.cell(colspan: piles.len())[#floor()],) } else { ()},
    ..if hlabel != none { (..col-extra.map(_ => []), ..range(0, piles.len()).map(n => align(horizon + center)[#hlabel(n, piles.at(n))])) } else { () }
  )
  
}
