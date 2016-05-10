module.exports=(config,n8)->
  globals=config.globals

  if globals.n8
    global.n8=n8
    delete globals.n8

  for key,value of globals
    if value is true
      global[key]=require(key)
    else
      global[key]=value

