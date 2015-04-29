Promise = require 'bluebird'
{SphereClient} = require 'sphere-node-sdk'

class FetchStocks

  constructor: (@logger, options = {}, @channelKey) ->
    @client = new SphereClient options


  run: ->
    query = @client.inventoryEntries.all().sort('sku').expand('supplyChannel')
    if @channelKey
      @_getChannelId()
      .then (id) ->
        queryString = 'supplyChannel(id="' + id + '")'
        query.where(queryString).fetch()
    else
      query.fetch()

  _getChannelId: ->
    queryString = 'key="' + @channelKey + '"'
    @client.channels.where(queryString).fetch()
    .then (result) ->
      Promise.resolve(result.body.results[0].id)


module.exports = FetchStocks