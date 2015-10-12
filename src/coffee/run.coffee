package_json = require '../package.json'
path = require 'path'
Promise = require 'bluebird'
fs = Promise.promisifyAll require('fs')
{ExtendedLogger, ProjectCredentialsConfig} = require 'sphere-node-utils'
CreateDir = require './createdir'
FetchStocks = require './fetchstocks'
CsvMapping = require './csv'

argv = require('optimist')
  .usage('Usage: $0 --projectKey [key] --clientId [id] --clientSecret [secret] --logDir [dir] --logLevel [level]')
  .describe('projectKey', 'your SPHERE.IO project-key')
  .describe('clientId', 'your OAuth client id for the SPHERE.IO API')
  .describe('clientSecret', 'your OAuth client secret for the SPHERE.IO API')
  .describe('accessToken', 'an OAuth access token for the SPHERE.IO API')
  .describe('sphereHost', 'SPHERE.IO API host to connect to')
  .option('excludeEmptyStocks', 'whether to skip empty stocks or not')
  .describe('channelKey', 'when you want to filter stock entries for a special channel key')
  .describe('targetDir', 'the folder where exported files are saved')
  .describe('targetFile', 'the file where exported stocks are saved')
  .describe('useExportTmpDir', 'whether to use a system tmp folder to store exported files')
  .describe('logLevel', 'log level for file logging')
  .describe('logDir', 'directory to store logs')
  .describe('logSilent', 'use console to print messages')
  .default('targetDir', path.join(__dirname,'../exports'))
  .default('excludeEmptyStocks', false)
  .default('useExportTmpDir', false)
  .default('logLevel', 'info')
  .default('logDir', '.')
  .default('logSilent', false)
  .demand(['projectKey'])
  .argv

logOptions =
  name: "#{package_json.name}-#{package_json.version}"
  streams: [
    { level: 'error', stream: process.stderr }
    { level: argv.logLevel, path: "#{argv.logDir}/#{package_json.name}.log" }
  ]
logOptions.silent = argv.logSilent if argv.logSilent
logger = new ExtendedLogger
  additionalFields:
    project_key: argv.projectKey
  logConfig: logOptions
if argv.logSilent
  logger.bunyanLogger.trace = -> # noop
  logger.bunyanLogger.debug = -> # noop

ProjectCredentialsConfig.create()
.then (credentials) ->
  options =
    config: credentials.enrichCredentials
      project_key: argv.projectKey
      client_id: argv.clientId
      client_secret: argv.clientSecret
    access_token: argv.accessToken
    user_agent: "#{package_json.name} - #{package_json.version}"
  options.host = argv.sphereHost if argv.sphereHost

  createDir = new CreateDir logger, argv.targetDir, argv.useExportTmpDir
  fetchStocks = new FetchStocks logger, options, argv.channelKey
  csvMapper = new CsvMapping argv.excludeEmptyStocks

  createDir.run()
  .then (outputDir) =>
    logger.debug "Created output dir at #{outputDir}"
    @outputDir = outputDir
    fetchStocks.run()
    .then (result) ->
      console.log "Found " + result.body.results.length + " stock entries."
      csvMapper.mapStocks(result)
      .then (data) ->
        ts = (new Date()).getTime()
        csvFile = argv.targetFile or "#{@outputDir}/stocks_#{ts}.csv"
        logger.info "Storing CSV export to '#{csvFile}'."
        fs.writeFileAsync csvFile, data
.catch (err) ->
  logger.error err, "Problem while creating stock export."
  process.exit(1)
.done()