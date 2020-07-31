import htmlparser
import xmltree  # To use '$' for XmlNode
import strtabs  # To access XmlAttributes
import os       # To use splitFile
import strutils # To use cmpIgnoreCase
import sequtils

type metadata = tuple[title: string, image: string]

proc get_title(htmlHead: XmlNode): string =
  return $(htmlHead.child("title").innerText)

proc get_image(htmlHead: XmlNode): string =

  return ""

proc get_metadata(htmlStr: string): metadata =
  let htmlXml = parseHtml(htmlStr)

  # # I don't know why this doesn't work, it is messed up
  # let htmlNode = htmlXml.child("html")
  # echo "htmlNode: ", $htmlNode
  # # echo "htmlXml's children: ", $(toSeq(htmlXml.items).join("\n"))
  # for kid in htmlXml.items:
  #   echo kid.htmlTag
  # echo "Trying to get <head> ..."
  # let htmlHead = htmlNode.child("head")
  # #

  let htmlHead = htmlXml.findAll("head")[0]


  let title = htmlHead.get_title
  var image = ""

  for meta in htmlHead.findAll("meta"):
    echo $meta
    let prop = meta.attr("property")
    if prop == "og:image":
      image = meta.attr("content")
  
  return (title: title, image: image)
  
  

when isMainModule:
  let html = readAll(stdin)
  echo html.get_metadata

