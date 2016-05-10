bodyParser=require('body-parser')
module.exports=(config,app)->
  app.use bodyParser.json()
  app.use bodyParser.urlencoded({extended:false})
  return false