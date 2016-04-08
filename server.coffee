http = require('http')
http.globalAgent.maxSockets = Number.MAX_VALUE

express   = require 'express'
csv       = require 'express-csv'
engines   = require 'consolidate'
#routes    = require './routes'  # routes are in /server/config/routes

bodyParser      = require 'body-parser'
methodOverride  = require 'method-override'
compress        = require 'compression'
errorHandler    = require 'errorhandler'

fs    = require 'fs'
https = require 'https'

sslOptions =
  key   : fs.readFileSync(__dirname + '/www_homeclub_us.key')
  cert  : fs.readFileSync(__dirname + '/www_homeclub_us.crt')


exports.startServer = (config, callback) ->

  port = process.env.PORT or config.server.port
  httpsPort = 3001

  app = module.exports = express()
#  server = config.httpServer = app.listen port, ->
  server = config.httpServer = https.createServer(sslOptions, app).listen httpsPort, ->
    console.log "Express server listening on port %d in %s mode", server.address().port, app.settings.env

  #app.configure ->
  app.set 'port', port
  app.set 'views', config.server.views.path
  app.engine config.server.views.extension, engines[config.server.views.compileWith]
  app.set 'view engine', config.server.views.extension

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