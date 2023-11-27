## This module implements APIs for native GUI application.
##
## `-d:ssl` compile option is required.
##

{.experimental: "strictDefs".}


import std/[sugar]
import nigui
import ./[simulator]
import ../private/simulator/native/[assets, field, immediatepairs, messages,
                                    misc, nextpair, pairs, requirement, select,
                                    share]

export misc.toKeyEvent

type
  SimulatorControl* = ref object of LayoutContainer
    ## Root control of the application window.
    simulator*: ref Simulator

  SimulatorWindow* = ref object of WindowImpl
    ## Application window.
    simulator*: ref Simulator

# ------------------------------------------------
# Keyboard Handler
# ------------------------------------------------

proc runKeyboardEventHandler*(window: SimulatorWindow, event: KeyboardEvent,
                              keys = downKeys()) {.inline.} =
  ## Keyboard event handler.
  let needRedraw = window.simulator[].operate event.toKeyEvent keys
  if needRedraw:
    event.window.control.forceRedraw

proc keyboardEventHandler(event: KeyboardEvent) =
  ## Keyboard event handler.
  let rawWindow = event.window
  assert rawWindow of SimulatorWindow

  cast[SimulatorWindow](rawWindow).runKeyboardEventHandler event

func initKeyboardEventHandler*: (event: KeyboardEvent) -> void {.inline.} =
  ## Returns the keyboard event handler.
  keyboardEventHandler

# ------------------------------------------------
# Control
# ------------------------------------------------
 
proc initSimulatorControl*(simulator: ref Simulator): SimulatorControl
                          {.inline.} =
  ## Returns the root control of GUI window.
  result = new SimulatorControl
  result.init
  result.layout = Layout_Vertical

  result.simulator = simulator

  let assetsRef = new Assets
  assetsRef[] = initAssets()

  # row=0
  let reqControl = simulator.initRequirementControl
  result.add reqControl

  # row=1
  let secondRow = newLayoutContainer Layout_Horizontal
  result.add secondRow

  # row=1, left
  let left = newLayoutContainer Layout_Vertical
  secondRow.add left

  let
    field = simulator.initFieldControl assetsRef
    messages = simulator.initMessagesControl assetsRef
  left.add simulator.initNextPairControl assetsRef
  left.add field
  left.add messages
  left.add simulator.initSelectControl reqControl
  left.add simulator.initShareControl

  # row=1, center
  secondRow.add simulator.initImmediatePairsControl assetsRef

  # row=1, right
  secondRow.add simulator.initPairsControl assetsRef

  # set size
  reqControl.setWidth secondRow.naturalWidth
  messages.setWidth field.naturalWidth

proc initSimulatorWindow*(simulator: ref Simulator, title = "ぷよぷよシミュレータ",
                          setKeyHandler = true): SimulatorWindow {.inline.} =
  ## Returns the GUI window.
  result = new SimulatorWindow
  result.init

  result.simulator = simulator

  result.title = title
  result.resizable = false
  if setKeyHandler:
    result.onKeyDown = keyboardEventHandler

  let rootControl = simulator.initSimulatorControl
  result.add rootControl

  when defined(windows):
    # HACK: somehow this adjustment is needed on Windows
    # TODO: better implementation
    result.width = (rootControl.naturalWidth.float * 1.1).int
    result.height = (rootControl.naturalHeight.float * 1.1).int
  else:
    result.width = rootControl.naturalWidth
    result.height = rootControl.naturalHeight