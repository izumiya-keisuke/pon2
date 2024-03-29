## This module implements Nazo Puyo permuters.
##

{.experimental: "strictDefs".}
{.experimental: "strictFuncs".}
{.experimental: "views".}

import ./[solve]
import ../core/[field, nazopuyo, pairposition]
import ../private/app/[permute]

when not defined(js):
  import std/[cpuinfo]
  import suru

# ------------------------------------------------
# Permute
# ------------------------------------------------

iterator permute*[F: TsuField or WaterField](
    nazo: NazoPuyo[F],
    fixMoves: seq[Positive],
    allowDouble: bool,
    allowLastDouble: bool,
    showProgress = false,
    parallelCount: Positive =
      when defined(js):
        1
      else:
        max(1, countProcessors())
    ,
): PairsPositions {.inline.} =
  ## Yields pairs&positions of the nazo puyo that is obtained by permuting
  ## pairs and has a unique solution.
  let pairsPositionsSeq =
    nazo.allPairsPositionsSeq(fixMoves, allowDouble, allowLastDouble)

  when not defined(js):
    var bar: SuruBar
    if showProgress:
      bar = initSuruBar()
      bar[0].total = pairsPositionsSeq.len
      bar.setup

  for pairsPositions in pairsPositionsSeq:
    var nazo2 = nazo
    nazo2.puyoPuyo.pairsPositions = pairsPositions

    let answers = nazo2.solve(earlyStopping = true, parallelCount = parallelCount)

    when not defined(js):
      bar.inc
      bar.update

    if answers.len == 1:
      yield answers[0]

  when not defined(js):
    if showProgress:
      bar.finish
