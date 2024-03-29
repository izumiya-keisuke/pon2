## This module implements assets handling.
##
## This module requires the compile option `-d:ssl`.
##

{.experimental: "strictDefs".}
{.experimental: "strictFuncs".}
{.experimental: "views".}

import std/[httpclient, net, options, appdirs, dirs, files, paths, strformat]
import nigui
import ../../../../core/[cell]

type Assets* = ref object
  cellImages*: array[Cell, Image]
  cellImageSize*: tuple[height: Natural, width: Natural]

const FilePaths: array[Cell, Path] = [
  Path "none.png",
  Path "hard.png",
  Path "garbage.png",
  Path "red.png",
  Path "green.png",
  Path "blue.png",
  Path "yellow.png",
  Path "purple.png",
]

proc initAssets*(timeoutSec = 180): Assets =
  ## Returns the assets.
  ##
  ## This function automatically downloads the missing assets.
  ## Downloading requires the compile option `-d:ssl`.
  result.new

  let client = newHttpClient(timeout = timeoutSec * 1000)
  defer:
    client.close

  let assetsDir = getDataDir() / "pon2".Path / "assets".Path / "puyo-small".Path
  assetsDir.createDir

  result.cellImages[None] = newImage() # HACK: dummy to suppress warning
  for cell, path in FilePaths:
    let fullPath = assetsDir / path
    if not fullPath.fileExists:
      echo "[pon2] Downloading ", path.string, " ..."

      {.push warning[Uninit]: off.}
      client.downloadFile(
        "https://github.com/izumiya-keisuke/pon2/raw/main/" &
          &"assets/puyo-small/{path.string}",
        fullPath.string,
      )
      {.pop.}

    let img = newImage()
    img.loadFromFile fullPath.string
    result.cellImages[cell] = img

  result.cellImageSize.width = result.cellImages[None].width
  result.cellImageSize.height = result.cellImages[None].height
