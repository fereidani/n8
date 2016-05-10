
fs=require('fs')
_=require('lodash')

module_exist=(path)->
  try
    require path
  catch err
    if(err.code is 'MODULE_NOT_FOUND')
      return false
  return true

module.exports=(app,config)->

  middleware=config.middleware

  getMiddleware=(key)->
    if _.isFunction middleware[key]
      return middleware[key](config,app)
    else if module_exist './middleware/'+key
      return require('./middleware/'+key)(config,app)
    else
      return require(key)

  for key in middleware.order
    mw=getMiddleware(key)
    if mw isnt false
      app.use mw


