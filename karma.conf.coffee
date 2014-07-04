
module.exports = (config) ->
  config.set
    basePath: ''
    frameworks: [
      'mocha'
      'browserify'
    ]

    files: [
      {pattern: 'bower_components/jquery/dist/jquery.js', included: true, watch: false, served: true}
      'jquery.countdown.coffee'
      'test/test.coffee'
      {pattern:'*.coffee', watched: true, included: false, served: false}
    ]

    exclude: [
      'node_modules'
      'bower_components'
    ]

    preprocessors:
      '**/*.coffee': ['coffee']
      'test/*.coffee': ['browserify']

    browserify:
      extensions: ['.coffee']
      transform: ['coffeeify']
      watch: true
      debug: true
      noParse: ['jquery']

    reporters: ['progress']
    port: 9876
    colors: true
    logLevel: config.LOG_INFO
    autoWatch: true
    usePolling: true
    browsers: ['PhantomJS']
    singleRun: false
  return
