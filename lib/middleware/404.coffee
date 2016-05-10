module.exports=(config)->
  return (req,res)->
    res.status 404

    if req.xhr
      res.send {
        error : '404 Not Found'
      }
    else
      res.render 'errors/404'