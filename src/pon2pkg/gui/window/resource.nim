## This module implements resources handling.
##

const distribute {.booldefine.} = false # used for GitHub release

import options
import os

import nigui
import puyo_core

type Resource* = tuple
  ## Resources data.
  cellImages: array[Cell, Image]
  cellImageWidth: int
  cellImageHeight: int

# ------------------------------------------------
# Entry Point
# ------------------------------------------------

proc loadResource*: Option[Resource] =
  ## Returns the resources.
  ## If the loading fails, returns :code:`none(Resource)`.
  const FileNames: array[Cell, string] = [
    "none.png",
    "",
    "garbage.png",
    "red.png",
    "green.png",
    "blue.png",
    "yellow.png",
    "purple.png"]

  # HACK: resource directory are different during development, installation and distribution
  let
    resourceDirAtRoot = getAppDir() / "resources"
    resourceDir = if distribute: getCurrentDir() / "resources" else:
      if resourceDirAtRoot.dirExists: resourceDirAtRoot else: getAppDir() / "src" / "resources"

  var resource: Resource
  for cell, fileName in FileNames:
    if fileName == "":
      continue

    let filePath = resourceDir / fileName
    if not filePath.fileExists:
      return

    let img = newImage()
    img.loadFromFile filePath
    resource.cellImages[cell] = img

  resource.cellImageWidth = resource.cellImages[NONE].width
  resource.cellImageHeight = resource.cellImages[NONE].height

  return some resource
