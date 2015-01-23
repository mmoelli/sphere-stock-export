Promise = require 'bluebird'
{SphereClient} = require 'sphere-node-sdk'

class FetchStocks

  constructor: (@logger, options = {}, @channelKey) ->
    @client = new SphereClient options


  run: ->
    if @channelKey
      @_getChannelId()
      .then (id) =>
        queryString = 'supplyChannel(id="' + id + '")'
        @client.inventoryEntries.where(queryString).all().sort('lastModifiedAt').expand('supplyChannel').fetch()
        .then (result) ->
          Promise.resolve(result)
    else
      @client.inventoryEntries.all().sort('lastModifiedAt').expand('supplyChannel').fetch()
      .then (result) ->
        Promise.resolve(result)

  _getChannelId: ->
    queryString = 'key="' + @channelKey + '"'
    @client.channels.where(queryString).fetch()
    .then (result) ->
      Promise.resolve(result.body.results[0].id)


module.exports = FetchStocks