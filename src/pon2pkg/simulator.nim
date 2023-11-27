## This module implements [Puyo Puyo](https://puyo.sega.jp/) and
## [Nazo Puyo](https://vc.sega.jp/3ds/nazopuyo/) simulators.
## With `import pon2pkg/simulator`, you can use all features provided by this
## module.
## Also, you can write such as `import pon2pkg/simulatorpkg/simulator` to import
## submodules individually.
##
## Submodule Documentations:
## - [Simulator Core](./simulatorpkg/simulator.html)
## - [Native Simulator](./simulatorpkg/native.html)
## - Web Simulator
##

{.experimental: "strictDefs".}

import ./simulatorpkg/[simulator]

export simulator.SimulatorState, simulator.Simulator, simulator.KeyEvent,
  simulator.initKeyEvent, simulator.initSimulator, simulator.`rule`,
  simulator.`kind`, simulator.`mode`, simulator.`rule=`, simulator.`kind=`,
  simulator.`mode=`, simulator.tsuNazoPuyo, simulator.waterNazoPuyo,
  simulator.originalTsuNazoPuyo, simulator.originalWaterNazoPuyo,
  simulator.pairs, simulator.originalPairs, simulator.withNazoPuyo,
  simulator.withOriginalNazoPuyo, simulator.withEnvironment,
  simulator.withOriginalEnvironment, simulator.withField,
  simulator.withOriginalField, simulator.toggleInserting, simulator.toggleFocus,
  simulator.moveCursorUp, simulator.moveCursorDown, simulator.moveCursorRight,
  simulator.moveCursorLeft, simulator.deletePair, simulator.writeCell,
  simulator.shiftFieldUp, simulator.shiftFieldDown, simulator.shiftFieldRight,
  simulator.shiftFieldLeft, simulator.flipFieldV, simulator.flipFieldH,
  simulator.`requirementKind=`, simulator.`requirementColor=`,
  simulator.`requirementNumber=`, simulator.undo, simulator.redo,
  simulator.moveNextPositionRight, simulator.moveNextPositionLeft,
  simulator.rotateNextPositionRight, simulator.rotateNextPositionLeft,
  simulator.forward, simulator.backward, simulator.reset, simulator.toUri,
  simulator.operate

when defined(js):
  import ./simulatorpkg/[web]

  export web.toKeyEvent, web.runKeyboardEventHandler,
    web.initKeyboardEventHandler, web.initPuyoSimulatorDom
else:
  import ./simulatorpkg/[native]

  export native.toKeyEvent, native.SimulatorControl, native.SimulatorWindow,
    native.runKeyboardEventHandler, native.initKeyboardEventHandler,
    native.initSimulatorControl, native.initSimulatorWindow