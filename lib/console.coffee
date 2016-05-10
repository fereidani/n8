c = require('colors/safe');
logBold=(input)->
  console.log c.bold input
module.exports=(@app,config)->
  logBold c.red """

███╗   ██╗ █████╗
████╗  ██║██╔══██╗
██╔██╗ ██║╚█████╔╝
██║╚██╗██║██╔══██╗
██║ ╚████║╚█████╔╝
╚═╝  ╚═══╝ ╚════╝ Advanced WebFramework

"""
  logBold c.blue "########################################"
  logBold c.blue("# Start ")+c.red("N8 Server")+c.blue(" :")
  logBold c.blue ("# ")+c.yellow("http://localhost:"+config.port)
  logBold c.blue "########################################"
  logBold c.blue("# Environment: ")+c.yellow(config.environment)
  logBold c.blue "########################################\n"