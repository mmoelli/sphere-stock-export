Promise = require 'bluebird'
fs = Promise.promisifyAll require('fs')
tmp = Promise.promisifyAll require('tmp')

class CreateDir

  constructor: (@logger, @targetDir, @randomDir) ->

  run: ->
    tmp.setGracefulCleanup()
    if @randomDir is 'true'
      # unsafeCleanup: recursively removes the created temporary directory, even when it's not empty
      tmp.dirAsync {unsafeCleanup: true}
    else
      exportsPath = @targetDir
      @fsExistsAsync(exportsPath)
      .then (exists) ->
        if exists
          Promise.resolve(exportsPath)
        else
          fs.mkdirAsync(exportsPath)
          .then -> Promise.resolve(exportsPath)

  fsExistsAsync: (path) ->
    new Promise (resolve, reject) ->
      fs.exists path, (exists) ->
        if exists
          resolve(true)
        else
          resolve(false)

module.exports = CreateDir