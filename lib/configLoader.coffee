_=require('lodash')
fs=require('fs')

configLoader=(path,config={})->

  traverse=(path,config)->
    for key,value of path
      if (_.isArray(value) or _.isObject(value)) and _.isFunction(value) is false
        if config[key] is undefined
          config[key]=if _.isArray(value) then [] else {}
        traverse(path[key],config[key])
      else
        config[key]=value
    return config
  loadFile=(path,config)->

    imp=require(path)

    if /^.*\.json$/i.test path
      # it's json
      filename=path.split('.')[0]
      if filename.indexOf('/') isnt -1
        filename=filename.split('/').pop()
      config[filename]=imp
    else
      return traverse(imp,config)

  loadFolder=(path,config)->
    if /.*\/env[\/]*$/i.test path or path is 'env'
      return config
    list=fs.readdirSync(path)
    for secondPath in list
      loadPath(path+"/"+secondPath,config)
    return config

  loadPath=(path,config)->
    stat=fs.statSync(path)
    if stat.isFile()
      return loadFile(path,config)
    else
      return loadFolder(path,config)

  if fs.existsSync(path)
    config=loadPath(path,config)
  else
    throw new Error("configLoader Error : Path does not exists : "+path)
  if config.environment isnt undefined
    envFile=path+"/env/"+config.environment
    try
      env=require(envFile)
      config=traverse(env,config)
    catch err
      console.error err

  return config

module.exports=configLoader