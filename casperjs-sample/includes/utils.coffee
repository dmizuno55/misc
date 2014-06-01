do ->
  fs = require "fs"
  dataDir = "tmp/data/"
  
  casper.loadDataFile = (fileName) ->
    if fs.exists "#{dataDir}#{fileName}.txt"
      return fs.read "#{dataDir}#{fileName}.txt"
    else
      return ''
  
  casper.saveDataFile = (fileName, content) ->
    fs.write "#{dataDir}#{fileName}.txt", content, "w"
    
  casper.loadCookie = ->
    @page.cookies = JSON.parse casper.loadDataFile "cookie"
  
  casper.saveCookie = ->
    casper.saveDataFile "cookie", JSON.stringify @page.cookies
  return
