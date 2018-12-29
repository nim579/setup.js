# Setup.js

Command line tools for config your project.

## Overview

**Setup.js** uses help files:
* *defaults.json* — default config file
* *presets.json* — file with presets for different environments
* *env-map.json* — map for environment variables into config

**Setup.js** generates *config.json* file with current config from help files by commands `set`, `unset`, `preset`, `reset`, `env`, `extend`. *config.json* may bee ignored in CVS for project.

Each developer can use his own config, changing *config.json* manually or by cli tool.

## Install

``` bash
npm install setupjs
```

or global

``` bash
npm install -g setupjs
```

Initialize tools for your project:
``` bash
$(npm bin)/setupjs init
```

For global:
``` bash
setupjs init
```

Customize paths to help files if needed by params `-c, -e, -p, -s`.

Add *config.json* in *.gitignore*.

## Use

For local installation:
``` bash
npm run setup -- <params>
```

For global installation:
``` bash
setupjs <params>
```

## Params
* **-h, --help** — show help
* **-V, --version** — show version
* **-v, --verbose** — run commands in verbose mode and print *config.json*
* **-c, --config [file]** — redefine path to config file (*config.json*)
* **-p, --presets [file]** — redefine path to presets file (*presets.json*)
* **-e, --env-map [file]** — redefine path to environment variables map file (*env-map.json*)
* **-d, --defaults [file]** — redefine path to default config file (*defaults.json*)

## Commands
* `init` — init **Setup.js** in project;
* `env` — config from environment variables mapped by *env-map.json*;
* `extend [path]` — extend config from JSON file;
* `preset [name]` — set (extending) config from presets;
* `set [<key> <value>]...` — set config params by key/value pairs;
* `unset [key]...` — unset config params by keys;
* `reset` — reset config to default params.

### `reset`
Reset *config.json* to config from *defaults.json*


### `preset`
Set (with deep extending) from presets file (see `./examples/environments.json`).
First indent fields must be a names of presets. For example:
``` js
{
    "producton": { // name of preset
        "server": {
            "url": "https://example.com/api"
        }
    },
    "staging": {  // name of preset
        "server": {
            "url": "https://staging.example.com/api"
        }
    }
}
```

Available presets: `producton` and `staging`.


Use example:
``` bash
setupjs preset staging
```

Config:
``` js
{
    "server": {
        "url": "https://staging.example.com/api"
    }
}
```


### `env`
Update config from environment variables:
``` bash
setupjs env
```

*env-map.json* example:
``` js
{
    "HOST": "server.host",
    "PORT": "server.port",
    "FLAG_ONE": "server.flags.one"
}
```

Use example:
``` bash
export HOST=127.0.0.11
export PORT=8080
export FLAG_ONE=false
setupjs env
```

Config:
``` js
{
    "server": {
        "url": "https://staging.example.com/api",
        "host": "127.0.0.11",
        "port": 8080,
        "flags": {
            "one": false
        }
    }
}
```


### `extend`
Extend config from some JSON file.

Example file *extend_example.json*:
``` js
{
    "server": {
        "port": 8888,
        "flags": {
            "two": true
        },
        "remote": [1, 2, 3]
    }
}
```

Use exapmpe:
``` bash
setupjs extend ./extend_example.json
```

Config:
``` js
{
    "server": {
        "url": "https://staging.example.com/api",
        "host": "127.0.0.11",
        "port": 8888,
        "flags": {
            "one": false,
            "two": true
        },
        "remote": [1, 2, 3]
    }
}
```


### `set`
Set (with deep extending) config key/value pairs:
``` bash
setupjs set server.url https://example.com/api server.producton true server timeout 5000 server.local.list `[1,3,4]`
```

Config:
``` js
{
    "server": {
        "url": "https://example.com/api",
        "host": "127.0.0.11",
        "port": 8888,
        "producton": true,
        "timeout": 5000,
        "flags": {
            "one": false,
            "two": true
        },
        "remote": [1, 2, 3],
        "local": {
            "list": [1, 3, 4]
        }
    }
}
```

Tool set value type automaticly.

Next call:
``` bash
setupjs set server.url https://staging.example.com/api server.flags.one true server.local null debug true
```

Config:
``` js
{
    "server": {
        "url": "https://staging.example.com/api",
        "host": "127.0.0.11",
        "port": 8080,
        "producton": true,
        "timeout": 5000,
        "flags": {
            "one": true,
            "two": true
        },
        "remote": [1, 2, 3],
        "local": null
    },
    "debug": true
}
```


### `unset`
Remove (with deep extending) params by keys.

For example (config from `set` examples):

``` bash
setupjs unset debug server.flags server.producton
```

Config:
``` js
{
    "server": {
        "url": "https://staging.example.com/api",
        "host": "127.0.0.11",
        "port": 8080,
        "timeout": 5000,
        "remote": [1, 2, 3],
        "local": null
    }
}
```

# Releases
See releases on [Releases page](https://github.com/nim579/setup.js/releases).

# Upgrading from 1.x to 2.x
Rename *settings.json* to *defaults.json* and *environments.json* to *presets.json*. Run `setupjs init`.
