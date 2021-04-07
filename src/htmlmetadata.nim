const help = """
Usage:
  You need to send the HTML input through stdin, by using, e.g., `curl http://example.com | htmlmetadata ...`.

  htmlmetadata
    Will print all the extracted metadata in a humanly readable format.
  htmlmetadata <name-of-metadata> ...
    Will print the requested metadata only, separated by the NUL character. (The separator can't be the newline because the description metadata often contains newlines.)

Available metadata:
  title: string
  description: string
  image: string
  author: string
  creator: string
  site_name: string
  keywords: string
"""
  
import htmlparser
import xmltree  
# import strtabs  # To access XmlAttributes
import os       
# import strutils 
import sequtils

let dbg = (getEnv("DEBUGME", "") != "")

type metadata = object
  title: string
  description: string
  image: string
  author: string
  creator: string
  site_name: string
  keywords: string

# proc get_title(htmlHead: XmlNode): string =
#   let titleNode = htmlHead.child("title")
#   if not isNil(titleNode):
#     return $(titleNode.innerText) 
#   return ""

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

  # let htmlHead = htmlXml.findAll("head")[0]

  var md: metadata

  try:
    # echo "in try"
    # md.title = htmlHead.get_title
    md.title = htmlXml.findAll("title")[0].innerText
  except: # doesn't catch nil exceptions
    # sometimes doesn't find any title tags, e.g., for https://elemental.medium.com/theres-good-news-about-your-immune-system-and-the-coronavirus-7d2c1fc976c1
    if dbg:
      let
        e = getCurrentException()
        msg = getCurrentExceptionMsg()
      stderr.writeLine("Got exception ", repr(e), " with message ", msg)

  for meta in htmlXml.findAll("meta"):
    if dbg:
      stderr.writeLine($meta)
    let prop = meta.attr("property")
    case prop
    of "og:image", "twitter:image:src":
      md.image = meta.attr("content") 
    of "og:site_name":
      md.site_name = meta.attr("content") 
    of "og:description", "twitter:description":
      md.description = meta.attr("content") 
    of "og:title", "twitter:title":
      md.title = meta.attr("content")
    of "twitter:creator":
      md.creator = meta.attr("content")
    of "article:author", "book:author":
      md.author = meta.attr("content")



    let name = meta.attr("name")
    case name
    of "title":
      md.title = meta.attr("content")
    of "author":
      md.author = meta.attr("content")
    of "description":
      md.description = meta.attr("content")
    of "keywords":
      md.keywords = meta.attr("content")
      
  if md.author == "":
    md.author = md.creator
  return md
  
  

when isMainModule:

  # import macros

  # macro `[]`*(obj: object, fieldName: string): untyped =
  #   ## Access object field value by name: ``obj["field"]`` translates to ``obj.field``.
  #   newDotExpr(obj, newIdentNode(fieldName.strVal))

  # macro `[]=`*(obj: var object, fieldName: string, value: untyped): untyped =
  #   ## Set object field value by name: ``obj["field"] = value`` translates to ``obj.field = value``.
  #   newAssignment(newDotExpr(obj, newIdentNode(fieldName.strVal)), value)

  proc `[]`(x: object, s: string, T: type): T =
    result = help
    for n, v in x.fieldPairs:
      if n == s:
          result = v
          break

  
  let args = commandLineParams()
  if args.len >= 1 and (args[0] == "-h" or args[0] == "--help"):
      stderr.write(help)
      quit(0)

  let html = readAll(stdin)
  let md = html.get_metadata
  # if dbg:
  #   stderr.writeLine($(md))

  if args.len == 0:
    stdout.writeLine($(md))
    # for rec in md.fields:
      # stdout.write(rec & $'\x00')
  else:
    var sep = "\0"
    for i, arg in args:
      if i == (args.len - 1):
        # stdout.write("last arg")
        sep = ""
      # if dbg:
      #   stderr.writeLine(arg & ":" & $i)
      stdout.write(md[$arg, string] & sep)




