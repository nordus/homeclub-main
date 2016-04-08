fs              = require('fs')
https           = require('https')
express         = require('express')
csv             = require('express-csv')
engines         = require('consolidate')
bodyParser      = require('body-parser')
methodOverride  = require('method-override')
compress        = require('compression')
errorHandler    = require('errorhandler')

sslOptions =
  key   : fs.readFileSync(__dirname + '/www_homeclub_us.key')
  cert  : fs.readFileSync(__dirname + '/www_homeclub_us.crt')


exports.startServer = ( config, callback ) ->

  port    = process.env.PORT or config.server.port
  server  = https.createServer( sslOptions, app ).listen ( port ) ->
    console.log("Express (HTTPS) server listening on port %d in %s mode", server.address().port, app.settings.env)

  app.set 'port', port
  app.set 'views', config.server.views.path
  app.engine config.server.views.extension, engines[config.server.views.compileWith]
  app.set 'view engine', config.server.views.extension

  app.use bodyParser()

  app.use methodOverride()
  app.use compress()

  if app.get('env') is 'development'
    app.use errorHandler()

  require('./server/config/routes')(app, config)

  app.use express.static(config.watch.compiledDir)

  callback(server)