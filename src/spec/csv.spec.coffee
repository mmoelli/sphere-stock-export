_ = require 'underscore'
Promise = require 'bluebird'
CsvMapping = require '../lib/csv'
SpecHelper = require './helper.spec'

describe 'CsvMapping', ->

  beforeEach ->
    @csvMapper = new CsvMapping false

  it 'should create the correct csv from the stock information', (done) ->
    expectedCsv =
      """
      sku,quantity,channel
      123,0,
      456,6,warehouse-1
      """

    @csvMapper.mapStocks(SpecHelper.stocksMock())
    .then (result) ->
      expect(result).toEqual expectedCsv
      done()
    .catch done

  it 'should create the correct csv from the stock information and exclude empty stocks', (done) ->
    expectedCsv =
      """
      sku,quantity,channel
      456,6,warehouse-1
      """

    @csvMapper.excludeEmptyStocks = true

    @csvMapper.mapStocks(SpecHelper.stocksMock())
    .then (result) ->
      expect(result).toEqual expectedCsv
      done()
    .catch done