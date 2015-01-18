_ = require 'underscore'
Promise = require 'bluebird'
Csv = require 'csv'
access = require 'safe-access'

class CsvMapping

  mapStocks: (stocks) ->
    mappings =
      sku: "sku"
      quantity: "quantityOnStock"

    rows = _.map stocks.body.results, (stock) =>
      @_mapStocks(stock)

    header = _.map mappings, (value, key) =>
      key

    test = @toCSV(header, rows)
    test

  _mapStocks: (stock) ->
    mappings =
      sku: "sku"
      quantity: "quantityOnStock"

    values = _.map mappings, (mapping, name) =>
      @_getValue stock, mapping

    values

  _getValue: (stock, mapping) ->
    value = access stock, mapping
    return '' unless value

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
