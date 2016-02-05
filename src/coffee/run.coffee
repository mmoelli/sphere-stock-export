package_json = require '../package.json'
path = require 'path'
Promise = require 'bluebird'
fs = Promise.promisifyAll require('fs')
{ExtendedLogger, ProjectCredentialsConfig} = require 'sphere-node-utils'
CreateDir = require './createdir'
FetchStocks = require './fetchstocks'
CsvMapping = require './csv'
_ = require 'underscore'

argv = require('optimist')
  .usage('Usage: $0 --projectKey [key] --clientId [id] --clientSecret [secret] --logDir [dir] --logLevel [level]')
  .describe('projectKey', 'your SPHERE.IO project-key')
  .describe('clientId', 'your OAuth client id for the SPHERE.IO API')
  .describe('clientSecret', 'your OAuth client secret for the SPHERE.IO API')
  .describe('accessToken', 'an OAuth access token for the SPHERE.IO API')
  .describe('sphereHost', 'SPHERE.IO API host to connect to')
  .describe('sphereProtocol', 'SPHERE.IO API protocol to connect to')
  .describe('sphereAuthHost', 'SPHERE.IO OAuth host to connect to')
  .describe('sphereAuthProtocol', 'SPHERE.IO OAuth protocol to connect to')
  .option('excludeEmptyStocks', 'whether to skip empty stocks or not')
  .describe('channelKey', 'when you want to filter stock entries for a special channel key')
  .describe('queryString', 'query for stock entries. Can be used instead of or in combination with channel key for more flexibility')
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

ensureCredentials = (argv) ->
  if argv.accessToken
    Promise.resolve
      config:
        project_key: argv.projectKey
      access_token: argv.accessToken
  else
    ProjectCredentialsConfig.create()
    .then (credentials) ->
      Promise.resolve
        config: credentials.enrichCredentials
          project_key: argv.projectKey
          client_id: argv.clientId
          client_secret: argv.clientSecret

ensureCredentials(argv)
.then (credentials) ->
  options = _.extend credentials,
    user_agent: "#{package_json.name} - #{package_json.version}"
  options.host = argv.sphereHost if argv.sphereHost
  options.protocol = argv.sphereProtocol if argv.sphereProtocol
  if argv.sphereAuthHost
    options.oauth_host = argv.sphereAuthHost
    options.rejectUnauthorized = false
  options.oauth_protocol = argv.sphereAuthProtocol if argv.sphereAuthProtocol

  createDir = new CreateDir logger, argv.targetDir, argv.useExportTmpDir
  fetchStocks = new FetchStocks logger, options, argv.channelKey, argv.queryString
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
