_ = require 'underscore'
Promise = require 'bluebird'
FetchStocks = require '../lib/fetchstocks'
{ExtendedLogger} = require 'sphere-node-utils'
Config = require '../config'

describe 'FetchStocks', ->

  beforeEach ->
    @logger = new ExtendedLogger
    @fetchStocks = new FetchStocks @logger, Config, 'anyKey'

  it 'should get the channel Information', (done) ->
    spyOn(@fetchStocks.client.channels, 'fetch').andCallFake -> Promise.resolve
      body:
        results: [
          {
            id: '123'
          }]
    @fetchStocks._getChannelId()
    .then (result) =>
      expect(result).toEqual '123'
      done()
    .catch (e) -> done e