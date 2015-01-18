![SPHERE.IO icon](https://admin.sphere.io/assets/images/sphere_logo_rgb_long.png)

# Stock export

[![NPM](https://nodei.co/npm/sphere-order-export.png?downloads=true)](https://www.npmjs.org/package/sphere-order-export)

[![Build Status](https://secure.travis-ci.org/mmoelli/sphere-stock-export.png?branch=master)](http://travis-ci.org/sphereio/sphere-order-export) [![NPM version](https://badge.fury.io/js/sphere-stock-export.png)](http://badge.fury.io/js/sphere-order-export)
This module allows to export stocks to CSV.

## Getting started

```bash
$ npm install -g sphere-stock-export

# output help screen
$ order-export
```

## Usage

General command line options can be seen by simply executing the command `node lib/run`.
```
node lib/run

  Usage:     --projectKey <project-key> --clientId <client-id> --clientSecret <client-secret>

  Options:

    --projectKey       your SPHERE.IO project-key                                  [required]
    --clientId         your OAuth client id for the SPHERE.IO API                  [required]
    --clientSecret     your OAuth client secret for the SPHERE.IO API              [required]
    --sphereHost       SPHERE.IO API host to connect to
    --targetDir        the folder where exported files are saved                   [default: "/Users/martinmollmann/dev/sphere-stock-export/exports"]
    --useExportTmpDir  whether to use a system tmp folder to store exported files  [default: false]
    --logLevel         log level for file logging                                  [default: "info"]
    --logDir           directory to store logs                                     [default: "."]
    --logSilent        use console to print messages                               [default: false]
```

### CSV Format
Stocks exported in CSV are stored in a single file

```csv
sku,quantity
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
Copyright (c) 2014 SPHERE.IO
Licensed under the [MIT license](LICENSE-MIT).
