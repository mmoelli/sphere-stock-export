![commercetools logo](https://cdn.rawgit.com/commercetools/press-kit/master/PNG/72DPI/CT%20logo%20horizontal%20RGB%2072dpi.png)

# Stock export

[![NPM](https://nodei.co/npm/sphere-stock-export.png?downloads=true)](https://www.npmjs.org/package/sphere-stock-export)

[![Build Status](https://secure.travis-ci.org/sphereio/sphere-stock-export.png?branch=master)](http://travis-ci.org/sphereio/sphere-stock-export) [![NPM version](https://badge.fury.io/js/sphere-stock-export.png)](http://badge.fury.io/js/sphere-stock-export) [![Coverage Status](https://coveralls.io/repos/sphereio/sphere-stock-export/badge.svg?branch=master)](https://coveralls.io/r/sphereio/sphere-stock-export?branch=master) [![Dependency Status](https://david-dm.org/sphereio/sphere-stock-export.svg)](https://david-dm.org/sphereio/sphere-stock-export) [![devDependency Status](https://david-dm.org/sphereio/sphere-stock-export/dev-status.svg)](https://david-dm.org/sphereio/sphere-stock-export#info=devDependencies)

This module allows to export stocks to CSV.

## Getting started

```bash
$ npm install -g sphere-stock-export

# output help screen
$ stock-export
```

## Usage

General command line options can be seen by simply executing the command `node lib/run`.
```
node lib/run

  Usage:     --projectKey <project-key> --clientId <client-id> --clientSecret <client-secret>

  Options:

    --projectKey          your SPHERE.IO project-key                                  [required]
    --clientId            your OAuth client id for the SPHERE.IO API                  [required]
    --clientSecret        your OAuth client secret for the SPHERE.IO API              [required]
    --accessToken         alternative to clientId and clientSecret, you can provide an OAuth access token
    --sphereHost          SPHERE.IO API host to connect to
    --excludeEmptyStocks  when given, stocks with quantity = 0                        [default: false]
    --channelKey          the specific channel you want to export stocks for
    --queryString         query for stock entries. Can be used instead of or in combination with channel key for more flexibility
    --targetDir           the folder where exported files are saved                   [default: "/exports"]
    --useExportTmpDir     whether to use a system tmp folder to store exported files  [default: false]
    --logLevel            log level for file logging                                  [default: "info"]
    --logDir              directory to store logs                                     [default: "."]
    --logSilent           use console to print messages                               [default: false]
```

### CSV Format
Stocks exported in CSV are stored in a single file

```csv
sku,quantity,channel
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).
More info [here](CONTRIBUTING.md)

## Releasing
Releasing a new version is completely automated using the Grunt task `grunt release`.

```javascript
grunt release // patch release
grunt release:minor // minor release
grunt release:major // major release
```

## License
Copyright (c) 2015 SPHERE.IO
Licensed under the [MIT license](LICENSE-MIT).
