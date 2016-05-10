module.exports=(app,config)->

  app.set('views',config.views.directory)

  for key,engine of config.views.engines
    app.engine(engine.ext or key,engine.render)

  app.set('view engine',config.views.defaultEngine)

  app.set('view cache',config.environment is 'production')

