multer=require('multer')
module.exports=(config)->
  return multer({dest:'/tmp'})