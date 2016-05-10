
_=require('lodash')
util=require('util')
normalizeErrors = (errOrErrs) ->
# If `errOrErrs` is not an array already, make it one
  errorsToDisplay = if _.isArray(errOrErrs) then errOrErrs else [ errOrErrs ]
  # Ensure that each error is formatted correctly
  _.map errorsToDisplay, (e, i) ->
    displayError = undefined
    # Make error easier to read, and normalize its type
    if e instanceof Error
      displayError = e.stack
    else
      displayError = new Error(util.inspect(e))
      displayError.original = e
    displayError


module.exports=(config)->

  return (err,req,res,next)->
    res.status 500
    console.error err.stack
    showError=config.environment is 'development'
    error=null
    if showError
      error=normalizeErrors(err)

    if e
      for e in error
        console.error e

    if req.xhr
      res.send {
        error : '500 Internal Error'
        details: error
      }
    else
      res.render 'errors/500',{errors:error}