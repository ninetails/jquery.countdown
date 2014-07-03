
module.exports = (config) ->
  config.set
    basePath: ''
    frameworks: [
      'mocha'
      'browserify'
    ]

    files: [
      {pattern: 'bower_components/jquery/dist/jquery.js', include: true, watch: false}
      'test/test.coffee'
    ]

    preprocessors:
      '**/*.coffee': ['coffee']
      'test/*.coffee': ['browserify']

    browserify:
      extensions: ['.coffee']
      transform: ['coffeeify']
      watch: true
      debug: true
      # noParse: ['jquery']

    exclude: []
    reporters: ['progress']
    port: 9876
    colors: true
    logLevel: config.LOG_INFO
    autoWatch: true
    browsers: ['PhantomJS']
    singleRun: false
  return
