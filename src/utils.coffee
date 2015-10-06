fs   = require 'fs'
path = require 'path'
_    = require 'underscore'


Utils =
    getOptions: (program, targetSettings)->
        # Загружаем настройки и конфиги
        configPath = 'config.json'
        configPath = targetSettings.setup.config if targetSettings.setup and targetSettings.setup.config
        configPath = program.config if program.config

        presetsPath = 'environments.json'
        presetsPath = targetSettings.setup.presets if targetSettings.setup and targetSettings.setup.presets
        presetsPath = program.presets if program.presets

        settingsPath = 'settings.json'
        settingsPath = targetSettings.setup.settings if targetSettings.setup and targetSettings.setup.settings
        settingsPath = program.settings if program.settings

        configPath = path.resolve process.cwd(), configPath
        config = Utils.load configPath

        presetsPath = path.resolve process.cwd(), presetsPath
        presets = Utils.load presetsPath

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
        for prop of source
            if _.has target, prop
                Utils.deepObjectExtend target[prop], source[prop]

            else
                target[prop] = source[prop]

        return target

    parseString: (string)->
        return string unless _.isString string

        try
            result = JSON.parse string

        catch e
            result = string
        
        return result


module.exports = Utils
