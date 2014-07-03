# dependencies
expect = require 'expect.js'
countdown = require '../jquery.countdown.coffee'

describe 'test', () ->
  it 'Hello world test', () ->
    expect(countdown('world')).to.be('Hello world!')
    expect(countdown('test')).to.be('Hello test!')
    return
  return
