_ = require 'underscore'
Promise = require 'bluebird'
Csv = require 'csv'
access = require 'safe-access'

class CsvMapping

  constructor: (excludeEmptyStocks) ->
    @excludeEmptyStocks = excludeEmptyStocks

  mapStocks: (stocks) ->
    mappings =
      sku: "sku"
      quantity: "quantityOnStock"
      channel: "supplyChannel.obj.key"

    rows = _.chain(stocks.body.results)
    .map (stock) => @_mapStocks(stock)
    .filter (stock) => if @excludeEmptyStocks then stock[1] isnt 0 else true
    .value()

    console.log "Export #{_.size(rows)} stock entries."
    header = _.map mappings, (value, key) =>
      key

    @toCSV(header, rows)

  _mapStocks: (stock) ->
    mappings =
      sku: "sku"
      quantity: "quantityOnStock"
      channel: "supplyChannel.obj.key"

    _.map mappings, (mapping, name) ->
      access stock, mapping

  toCSV: (header, data) ->
    new Promise (resolve, reject) ->
      Csv().from([header].concat data)
      .on 'error', (error) -> reject error
      .to.string (asString) -> resolve asString

module.exports = CsvMapping