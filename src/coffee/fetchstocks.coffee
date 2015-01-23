Promise = require 'bluebird'
{SphereClient} = require 'sphere-node-sdk'

class FetchStocks

  constructor: (@logger, options = {}) ->
    @client = new SphereClient options

  run: ->
    @client.inventoryEntries.all().sort('lastModifiedAt').expand('supplyChannel').fetch()
    .then (result) ->
      Promise.resolve(result)

module.exports = FetchStocks