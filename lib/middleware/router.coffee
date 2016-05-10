

_=require('lodash')

methodRegex=/^(get|post|delete|put|use)\s+(\S.*)$/i

co = require('co')

expressGenerator = (gen) ->
  func = co.wrap(gen)
  if gen.length is 4
    return (err, req, res, next) ->
      func(err, req, res, next).catch next

  return (req, res, next) ->
    func(req, res, next).catch next

isGenerator = (obj) ->
  'function' == typeof obj.next and 'function' == typeof obj.throw

isGeneratorFunction = (obj) ->
  constructor = obj.constructor
  if !constructor
    return false
  if 'GeneratorFunction' == constructor.name or 'GeneratorFunction' == constructor.displayName
    return true
  isGenerator constructor.prototype


module.exports=(config)->

  routes=config.routes
  router=require('express').Router()

  requireController=(path)->
    path=config.appDir+'/api/controllers/'+path
    try
      return require(path)
    catch err
      console.error err.stack
      return undefined

  addRoutes=(method,path,func)->
    if isGeneratorFunction(func)
      func=expressGenerator(func)

    if _.isFunction func or /use/i.test(method)
      router[method](path,func)
    else
      slash="/"
      if /^.*\/$/.test path
        # don't need slash
        slash=""
      for key,value of func
        if isGeneratorFunction(value)
          value=expressGenerator(value)
        if key is 'index'
          key=''
        router[method](path+slash+key,value)

  translateTarget=(key)->
    if _.isFunction(key)
      return key
    # controller import
    if key.indexOf('.') isnt -1
      controller=key.split('.')
      if controller.length is 2
        ctl=requireController(controller[0])
        if ctl isnt undefined
          return ctl[controller[1]]
        else
          return undefined
      else
        console.error("Invalid Controller => "+key)
    else
      return requireController(key)



  for path,target of routes
    # if it has method
    func=translateTarget(target)
    if func is undefined
      console.error "Invalid Controller => "+target
      continue
    if methodRegex.test path
      # it has method
      conf=path.match methodRegex
      httpMethod=conf[1].toLowerCase()
      httpPath=conf[2]
      if /^regex:.*$/.test httpPath
        matches=httpPath.match /^regex:(.*)$/
        httpPath=RegExp(matches[1])
        addRoutes(httpMethod,httpPath,func)
      else
        addRoutes(httpMethod,httpPath,func)
    else
      # it is simple with out method
      if /^regex:.*$/.test path
        matches=path.match /^regex:(.*)$/
        httpPath=RegExp(matches[1])
        addRoutes('all',httpPath,func)
      else
        addRoutes('all',path,func)

  return router
