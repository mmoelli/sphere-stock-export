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
      channel: "supplyChannel"

    rows = _.chain(stocks.body.results)
    .map (stock) => @_mapStocks(stock)
    .filter (stock) -> not _.isNull(stock)
    .value()

    console.log "Export #{_.size(rows)} stock entries."
    header = _.map mappings, (value, key) =>
      key

    test = @toCSV(header, rows)
    test

  _mapStocks: (stock) ->
    mappings =
      sku: "sku"
      quantity: "quantityOnStock"
      channel: "supplyChannel"

    values = _.map mappings, (mapping, name) =>
      @_getValue stock, mapping

    if @excludeEmptyStocks && values[1] == 0
      return null
    else
      return values

  _getValue: (stock, mapping) ->
    value = access stock, mapping

    value

  formatChannel = (channel) ->
    if channel?
      "#{channel.obj.key}"

  toCSV: (header, data) ->
    new Promise (resolve, reject) ->
      Csv().from([header].concat data)
      .on 'error', (error) -> reject error
      .to.string (asString) -> resolve asString

module.exports = CsvMapping