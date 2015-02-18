_ = require 'underscore'

uniqueId = (prefix) ->
  _.uniqueId "#{prefix}#{new Date().getTime()}_"

module.exports =

  stocksMock: ->
    body:
      results: [{
          sku: '123',
          quantityOnStock: 0,
        },
        {
          sku: '456',
          quantityOnStock: 6,
          supplyChannel:
            obj:
              key: 'warehouse-1'
        }]

  singleStockMock: ->
    body:
      results: [{
        sku: '456',
        quantityOnStock: 6,
        supplyChannel:
          obj:
            key: 'warehouse-1'
      }]

  channelMock: ->
    body:
      results: [{
          id: '123',
          key: 'warehouse-1'
        }]