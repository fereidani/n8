

require('coffee-script/register');


module.exports=function(config){
    return new require('./lib/n8')(config)
};

