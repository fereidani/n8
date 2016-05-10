
express=require('express')


n8=(@config)->

  @app=express()
  @app.disable('x-powered-by');

  # activate console
  require('./console')(@app,config)

  # activate globals
  require('./globals')(config,@)

  # activate hooks
  require('./hooks')(@app,config)

  # activate middleware
  require('./middleware')(@app,config)

  @app.listen(config.port)

module.exports=n8