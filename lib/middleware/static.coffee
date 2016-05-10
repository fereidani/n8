module.exports=(config)->
  express=require('express')
  path=null
  if /^\/.*/.test config.static.path
    path=config.static.path
  else
    path=config.appDir+"/"+config.static.path

  return express.static(config.appDir+"/"+config.static.path)
