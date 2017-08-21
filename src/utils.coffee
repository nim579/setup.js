fs   = require 'fs'
path = require 'path'
_    = require 'underscore'
_d   = require 'underscore-deep-extend'

_.mixin deepExtend: _d _


Utils =
    getOptions: (program, targetSettings)->
        # Загружаем настройки и конфиги
        configPath = 'config.json'
        configPath = targetSettings.setup.config if targetSettings.setup?.config
        configPath = program.config if program.config

        presetsPath = 'presets.json'
        presetsPath = targetSettings.setup.presets if targetSettings.setup?.presets
        presetsPath = program.presets if program.presets

        envMapPath = 'env-map.json'
        envMapPath = targetSettings.setup.envMap if targetSettings.setup?.envMap
        envMapPath = program.envMap if program.envMap

        settingsPath = 'settings.json'
        settingsPath = targetSettings.setup.settings if targetSettings.setup?.settings
        settingsPath = program.settings if program.settings

        configPath = path.resolve process.cwd(), configPath
        config = Utils.load configPath

        presetsPath = path.resolve process.cwd(), presetsPath
        presets = Utils.load presetsPath

        envMapPath = path.resolve process.cwd(), envMapPath
        envMap = Utils.load envMapPath

        settingsPath = path.resolve process.cwd(), settingsPath
        settings = Utils.load settingsPath

        options =
            config:
                path: configPath
                data: config

            settings:
                path: settingsPath
                data: settings

            presets:
                path: presetsPath
                data: presets

            envMap:
                path: envMapPath
                data: envMap

        return options

    load: (pathName)->
        config = {}
        return config unless pathName

        try
            config = require pathName

        catch e
            console.error 'No existing config in ' + path.basename pathName

        return config

    saveConfig: (config, pathName)->
        fs.writeFile pathName, JSON.stringify(config, null, 4), (err)->
            throw err if err
            console.log 'Setup done'

    saveObject: (object, pathName)->
        fs.writeFile pathName, JSON.stringify(object, null, 4), (err)->
            throw err if err
            console.log 'Saved ' + path.basename(pathName)

    showConfig: (config)->
        console.log JSON.stringify config, null, 4

    deepObjectExtend: (target, source)->
        return _.deepExtend {}, target, source

    parseString: (string)->
        return string unless _.isString string

        try
            result = JSON.parse string

        catch e
            result = string

        return result


module.exports = Utils
