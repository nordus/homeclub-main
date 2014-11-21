express   = require('express')
envConfig = require('./env-config')


module.exports = (app, config) ->

  app.get '/login', (req, res) -> res.render 'login'
  
  app.get '/', require "#{envConfig.rootPath}/../homeclub-frontend"
  app.get '/cms', require "#{envConfig.rootPath}/../homeclub-frontend"
  app.use '/cms', require "#{envConfig.rootPath}/../homeclub-frontend"
  app.get '/partials/*', require "#{envConfig.rootPath}/../homeclub-frontend"
  app.get '/cms-pages/*', require "#{envConfig.rootPath}/../homeclub-frontend"
  app.use express.static "#{envConfig.rootPath}/../homeclub-frontend/public"
  
  app.use '/api', require "#{envConfig.rootPath}/../homeclub-api"
  
  app.use '/consumer', require("#{envConfig.rootPath}/../homeclub-consumer")(config)
  app.use express.static "#{envConfig.rootPath}/../homeclub-consumer/public"

  app.use '/admin', require("#{envConfig.rootPath}/../homeclub-admin")(config)
  app.use express.static "#{envConfig.rootPath}/../homeclub-admin/public"