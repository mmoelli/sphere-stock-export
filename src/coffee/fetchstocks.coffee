Promise = require 'bluebird'
{SphereClient} = require 'sphere-node-sdk'

class FetchStocks

  constructor: (@logger, options = {}, @channelKey, @queryString) ->
    @client = new SphereClient options


  run: ->
    query = @client.inventoryEntries.all().expand('supplyChannel')
    queryString = []
    if @queryString
      queryString = @queryString.split(' and ')
    if @channelKey
      @_getChannelId()
      .then (id) ->
        queryString.push('supplyChannel(id="' + id + '")')
        query.where(queryString.join(' and ')).fetch()
    else
      query.where(queryString.join(' and ')).fetch()

  _getChannelId: ->
    queryString = 'key="' + @channelKey + '"'
    @client.channels.where(queryString).fetch()
    .then (result) ->
      Promise.resolve(result.body.results[0].id)


module.exports = FetchStocks
