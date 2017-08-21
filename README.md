# Setup.js

Command line tools for config your project.

## Overview

**Setup.js** uses help files:
* *defaults.json* — default config file
* *presets.json* — file with presets for different environments
* *env-map.json* — map for environment variables into config

**Setup.js** generates *config.json* file with current config from help files by commands `set`, `unset`, `preset`, `reset`, `env`. *config.json* may bee ignored in CVS for project.

Each developer can use his own config, changing *config.json* manually or by cli tool.

## Install

``` bash
npm install setupjs
```

or global (not recommended)

``` bash
npm install -g setupjs
```

Initialize tools for your project:

``` bash
$(npm bin)/setupjs init
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

## Команды
* `init` — init **Setup.js** in project;
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


### `set`
Set (with deep extending) config key/value pairs:
``` bash
setupjs set server.url https://example.com/api server.producton true server timeout 5000 server.local.list `[1,3,4]`
```

Sets config.
``` js
{
    "server": {
        "url": "https://example.com/api",
        "producton": true,
        "timeout": 5000,
        "local": {
            "list": [1, 3, 4]
        }
    }
}
```

Tool set value type automaticly.

Next call:
``` js
setupjs server.url https://staging.example.com/api server.flags.one true server.local null debug true
```

Config:
``` js
{
    "server": {
        "url": "https://staging.example.com/api",
        "producton": true,
        "timeout": 5000,
        "flags": {
            "one": true
        },
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
        "timeout": 5000,
        "local": null
    }
}
```
