module.exports=(config,app)->
  session = require('express-session')

  if config.session.adapter is 'redis'
    RedisStore=require('connect-redis')({session:session})
    conf={}
    for key in ['host','port','ttl','db','pass','prefix']
      if config.session[key] isnt undefined
        conf[key]=config.session[key]
    app.use session({
      store:new RedisStore(conf)
      secret:config.session.secret
      name:config.session.name||'session'
      resave: true
      saveUninitialized:false
    })
  else
    app.use session({
      secret:config.session.secret
      resave: true
      name:config.session.name||'session'
    })

  app.use (req,res,next)->
    if req.session is undefined
      throw new Error("Session is undefined")
    else
      next()

  return false