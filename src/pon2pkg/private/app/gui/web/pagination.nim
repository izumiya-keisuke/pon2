## This module implements the editor pagination node.
##

{.experimental: "strictDefs".}
{.experimental: "strictFuncs".}
{.experimental: "views".}

import std/[strformat, sugar]
import karax/[karax, karaxdsl, vdom]
import ../../../../app/[gui]

proc initEditorPaginationNode*(guiApplication: ref GuiApplication): VNode {.inline.} =
  ## Returns the editor pagination node.
  let showIdx =
    if guiApplication[].replay.pairsPositionsSeq.len == 0:
      0
    else:
      guiApplication[].replay.index.succ

  result = buildHtml(
    nav(class = "pagination", role = "navigation", aria - label = "pagination")
  ):
    button(
      class = "button pagination-link", onclick = () => guiApplication[].prevReplay
    ):
      span(class = "icon"):
        italic(class = "fa-solid fa-backward-step")
    button(class = "button pagination-link is-static"):
      text &"{showIdx} / {guiApplication[].replay.pairsPositionsSeq.len}"
    button(
      class = "button pagination-link", onclick = () => guiApplication[].nextReplay
    ):
      span(class = "icon"):
        italic(class = "fa-solid fa-forward-step")
