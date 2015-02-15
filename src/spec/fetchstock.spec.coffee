_ = require 'underscore'
Promise = require 'bluebird'
FetchStocks = require '../lib/fetchstocks'
{ExtendedLogger} = require 'sphere-node-utils'
Config = require '../config'

describe 'FetchStocks', ->

  beforeEach ->
    @logger = new ExtendedLogger
    @fetchStocks = new FetchStocks @logger, Config

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

  it 'should get the stock Information', (done) ->
    spyOn(@fetchStocks.client.inventoryEntries, 'fetch').andCallFake -> Promise.resolve
      body:
        results: [
          {
            sku: '123',
            quantityOnStock: 5
          }]
    @fetchStocks.run()
    .then (result) =>
      expect(result.body.results.length).toEqual 1
      expect(result.body.results[0].sku).toEqual '123'
      expect(result.body.results[0].quantityOnStock).toEqual 5
      done()
    .catch (e) -> done e