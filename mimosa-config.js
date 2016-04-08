exports.config = {
  "modules": [
    "copy",
    "server",
    "jshint",
    "csslint",
    "require",
    "minify-js",
    "minify-css",
    "live-reload",
    "bower",
    "coffeescript",
    "less",
    "jade",
    "web-package"
  ],
  server: {
    defaultServer: {
      enabled: false
    },
    path: 'https-server.coffee'
  }
}