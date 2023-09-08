## This module implements the entry point for making a web page.
##

import dom
import sugar
import options
import uri

import karax / [karax, karaxdsl, vdom, kdom]

import nazopuyo_core
import puyo_core
import puyo_simulator

import ./answer
import ./controller
import ../manager

# ------------------------------------------------
# API
# ------------------------------------------------

proc keyboardEventHandler*(manager: var Manager, event: KeyEvent) {.inline.} =
  ## Keyboard event handler.
  let needRedraw = manager.operate event
  if needRedraw and not kxi.surpressRedraws:
    kxi.redraw

proc keyboardEventHandler*(manager: var Manager, event: dom.Event) {.inline.} =
  ## Keybaord event handler.
  # assert event of KeyboardEvent # HACK: somehow this assertion fails
  manager.keyboardEventHandler cast[KeyboardEvent](event).toKeyEvent

proc makeKeyboardEventHandler*(manager: var Manager): (event: dom.Event) -> void {.inline.} =
  ## Returns the keyboard event handler.
  (event: dom.Event) => manager.keyboardEventHandler event

proc makePon2Dom*(manager: var Manager, setKeyHandler = true): VNode =
  ## Returns the DOM.
  if setKeyHandler:
    document.onkeydown = manager.makeKeyboardEventHandler

  let simulatorDom = manager.simulator[].makePuyoSimulatorDom(setKeyHandler = false)
  return buildHtml(tdiv(class = "columns is-mobile is-variable is-1")):
    tdiv(class = "column is-narrow"):
      simulatorDom
    tdiv(class = "column is-narrow"):
      section(class = "section"):
        tdiv(class = "block"):
          manager.controllerFrame
        if manager.answers.isSome:
          tdiv(class = "block"):
            manager.answerFrame

proc makePon2Dom*(
  nazoEnv: NazoPuyo or Environment,
  positions = none Positions,
  mode = IzumiyaSimulatorMode.PLAY,
  showCursor = false,
  setKeyHandler = true,
): VNode {.inline.} =
  ## Returns the DOM.
  var manager = nazoEnv.toManager(positions, mode, showCursor)
  return manager.makePon2Dom setKeyHandler

# ------------------------------------------------
# Web Page Generator
# ------------------------------------------------

var
  pageInitialized = false
  globalManager: Manager

proc isMobile: bool {.importjs:"navigator.userAgent.match(/iPhone|Android.+Mobile/)".}

proc makePon2Dom(routerData: RouterData): VNode =
  ## Returns the DOM with izumiya-format URL.
  if pageInitialized:
    return globalManager.makePon2Dom

  pageInitialized = true
  let query = if routerData.queryString == cstring"": "" else: ($routerData.queryString)[1 .. ^1]

  var uri = initUri()
  uri.scheme = "https"
  uri.hostname = $IZUMIYA
  uri.path = "/puyo-simulator/playground/index.html"
  uri.query = query

  let nazo = uri.toNazoPuyo
  if nazo.isSome:
    globalManager = nazo.get.nazoPuyo.toManager(nazo.get.positions, nazo.get.izumiyaMode.get, not isMobile())
    return globalManager.makePon2Dom

  let env = uri.toEnvironment
  if env.isSome:
    globalManager = env.get.environment.toManager(env.get.positions, env.get.izumiyaMode.get, not isMobile())
    return globalManager.makePon2Dom

  return buildHtml:
    text "URL形式エラー"

proc makeWebPage* {.inline.} =
  ## Makes the web page.
  makePon2Dom.setRenderer
