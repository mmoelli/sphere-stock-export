_ = require 'underscore'
path = require 'path'
Promise = require 'bluebird'
CreateDir = require '../lib/createdir'
{ExtendedLogger} = require 'sphere-node-utils'
Config = require '../config'

describe 'CreateDir', ->

  beforeEach ->
    @testPath = path.join(__dirname,'../exports')
    @logger = new ExtendedLogger
    @createDir = new CreateDir @logger, @testPath, false

  it 'should pass the correct path', (done) ->
    @createDir.run()
    .then (result) =>
      expect(@testPath)
      done()
    .catch done