module.exports=(config,app)->
  csurf=require('csurf')
  if config.csrf
    app.use csurf(config.csrf)
    app.use (req,res,next)->
      req._csrf=req.csrfToken()
      res.locals._csrf=req._csrf
      if req.method is 'POST' or req.cookies['XSRF-TOKEN'] is undefined
        res.cookie('XSRF-TOKEN', req._csrf);
      next()
    return false
  else
    return false