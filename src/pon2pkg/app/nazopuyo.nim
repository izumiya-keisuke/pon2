## This module implements Nazo Puyo wrap for all rules.
##

{.experimental: "strictDefs".}
{.experimental: "strictFuncs".}
{.experimental: "views".}

import ../core/[field, nazopuyo, rule]

type NazoPuyoWrap* = object ## Nazo puyo type that accepts all rules.
  rule*: Rule
  tsu*: NazoPuyo[TsuField]
  water*: NazoPuyo[WaterField]

using
  self: NazoPuyoWrap
  mSelf: var NazoPuyoWrap

# ------------------------------------------------
# Constructor
# ------------------------------------------------

func initNazoPuyoWrap*[F: TsuField or WaterField](
    nazo: NazoPuyo[F]
): NazoPuyoWrap {.inline.} =
  ## Returns a new nazo puyo wrap.
  when F is TsuField:
    result.rule = Tsu
    result.tsu = nazo
    result.water = initNazoPuyo[WaterField]()
  else:
    result.rule = Water
    result.tsu = initNazoPuyo[TsuField]()
    result.water = nazo

# ------------------------------------------------
# Flatten
# ------------------------------------------------

template flattenAnd*(self; body: untyped): untyped =
  ## Runs `body` with `nazoPuyo` exposed.
  case self.rule
  of Tsu:
    let nazoPuyo {.inject.} = self.tsu
    body
  of Water:
    let nazoPuyo {.inject.} = self.water
    body
