http = require('http')
http.globalAgent.maxSockets = Number.MAX_VALUE

process.env.PORT = 3000

express   = require 'express'
engines   = require 'consolidate'
#routes    = require './routes'  # routes are in /server/config/routes

favicon         = require 'serve-favicon'
bodyParser      = require 'body-parser'
methodOverride  = require 'method-override'
compress        = require 'compression'
errorHandler    = require 'errorhandler'

exports.startServer = (config, callback) ->

  port = process.env.PORT or config.server.port

  app = module.exports = express()
  server = config.httpServer = app.listen port, ->
    console.log "Express server listening on port %d in %s mode", server.address().port, app.settings.env

  #app.configure ->
  app.set 'port', port
  app.set 'views', config.server.views.path
  app.engine config.server.views.extension, engines[config.server.views.compileWith]
  app.set 'view engine', config.server.views.extension
  app.use favicon()

  #app.use express.urlencoded()
  #app.use express.json()
  app.use bodyParser()

  app.use methodOverride()
  app.use compress()

  # 'app.router' is deprecated!
  #app.use config.server.base, app.router

  if app.get('env') is 'development'
    app.use errorHandler()

  require('./server/config/routes')(app, config)
  
  app.use express.static(config.watch.compiledDir)

  callback(server)