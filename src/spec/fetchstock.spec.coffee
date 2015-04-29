_ = require 'underscore'
Promise = require 'bluebird'
FetchStocks = require '../lib/fetchstocks'
{ExtendedLogger} = require 'sphere-node-utils'
Config = require '../config'
SpecHelper = require './helper.spec'

describe 'FetchStocks', ->

  beforeEach ->
    @logger = new ExtendedLogger
    @fetchStocks = new FetchStocks @logger, Config

  it 'should get the channel Information', (done) ->
    spyOn(@fetchStocks.client.channels, 'fetch').and.callFake -> Promise.resolve SpecHelper.channelMock()

    @fetchStocks._getChannelId()
    .then (result) ->
      expect(result).toEqual '123'
      done()
    .catch (e) -> done e

  it 'should get the stock Information', (done) ->
    spyOn(@fetchStocks.client.inventoryEntries, 'fetch').and.callFake -> Promise.resolve SpecHelper.stocksMock()

    @fetchStocks.run()
    .then (result) ->
      expect(result.body.results.length).toEqual 2
      expect(result.body.results[0].sku).toEqual '123'
      expect(result.body.results[0].quantityOnStock).toEqual 0
      expect(result.body.results[1].sku).toEqual '456'
      expect(result.body.results[1].quantityOnStock).toEqual 6
      done()
    .catch (e) -> done e

  it 'should get the stock Information for a specific channel only', (done) ->
    spyOn(@fetchStocks, '_getChannelId').and.callFake -> Promise.resolve '123'
    spyOn(@fetchStocks.client.inventoryEntries, 'fetch').and.callFake -> Promise.resolve SpecHelper.singleStockMock()

    @fetchStocks.channelKey = "warehouse-1"
    @fetchStocks.run()
    .then (result) ->
      expect(result.body.results.length).toEqual 1
      expect(result.body.results[0].sku).toEqual '456'
      expect(result.body.results[0].quantityOnStock).toEqual 6
      done()
    .catch (e) -> done e