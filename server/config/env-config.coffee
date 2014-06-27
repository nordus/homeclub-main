env       = process.env.NODE_ENV || 'development'
path      = require('path')
rootPath  = path.normalize __dirname + '/../../'


config =

  development:
    db        : 'mongodb://easierbycode:5tekapU3@ds047198.mongolab.com:47198/homeclub'
    rootPath  : rootPath
    
  production:
    db        : 'mongodb://easierbycode:5tekapU3@ds047198.mongolab.com:47198/homeclub'
    rootPath  : rootPath

module.exports = config[env]