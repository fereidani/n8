_=require('lodash')

module.exports=(app,config)->
  hooks=config.hooks

  getHooks=(key)->
    if hooks[key] is false
      return
    if _.isFunction hooks[key]
      return hooks[key]
    try
      return require('./hooks/'+key)
    catch
      return require(key)


  for key of hooks
    getHooks(key)(app,config)


