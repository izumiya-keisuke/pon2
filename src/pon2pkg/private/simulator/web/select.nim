## This module implements the select node.
##

{.experimental: "strictDefs".}
{.experimental: "strictFuncs".}
{.experimental: "views".}

import std/[sugar]
import karax/[karax, karaxdsl, kbase, vdom]
import ../../../corepkg/[misc]
import ../../../simulatorpkg/[simulator]

const SelectedClass = kstring"button is-selected is-primary"

proc selectNode*(simulator: var Simulator): VNode {.inline.} =
  ## Returns the select node.
  let
    editButtonClass =
      if simulator.mode == Edit: SelectedClass else: kstring"button"
    playButtonClass =
      if simulator.mode == Play: SelectedClass else: kstring"button"
    replayButtonClass =
      if simulator.mode == Replay: SelectedClass else: kstring"button"

    tsuButtonClass =
      if simulator.rule == Tsu: SelectedClass
      else: kstring"button"
    waterButtonClass =
      if simulator.rule == Water: SelectedClass
      else: kstring"button"

    regularButtonClass =
      if simulator.kind == Regular: SelectedClass else: kstring"button"
    nazoButtonClass =
      if simulator.kind == Nazo: SelectedClass else: kstring"button"

  result = buildHtml(tdiv):
    tdiv(class = "buttons has-addons mb-0"):
      button(class = editButtonClass, onclick = () => (simulator.mode = Edit)):
        span(class = "icon"):
          italic(class = "fa-solid fa-pen-to-square")
      button(class = playButtonClass, onclick = () => (simulator.mode = Play)):
        span(class = "icon"):
          italic(class = "fa-solid fa-gamepad")
      button(class = replayButtonClass,
             onclick = () => (simulator.mode = Replay)):
        span(class = "icon"):
          italic(class = "fa-solid fa-film")
    tdiv(class = "buttons has-addons mb-0"):
      button(class = tsuButtonClass, onclick = () => (simulator.rule = Tsu)):
        text "通"
      button(class = waterButtonClass,
             onclick = () => (simulator.rule = Water)):
        text "水中"
    tdiv(class = "buttons has-addons"):
      button(class = regularButtonClass,
             onclick = () => (simulator.kind = Regular)):
        text "とこ"
      button(class = nazoButtonClass, onclick = () => (simulator.kind = Nazo)):
        text "なぞ"
