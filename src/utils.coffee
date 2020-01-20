_    = require 'lodash'
fs   = require 'fs'
path = require 'path'


Utils =
    getOptions: (program = {}, targetSettings = {})->
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

        defaultsPath = 'defaults.json'
        defaultsPath = targetSettings.setup.defaults if targetSettings.setup?.defaults
        defaultsPath = program.defaults if program.defaults

        configPath = path.resolve process.cwd(), configPath
        config = Utils.load configPath

        presetsPath = path.resolve process.cwd(), presetsPath
        presets = Utils.load presetsPath

        envMapPath = path.resolve process.cwd(), envMapPath
        envMap = Utils.load envMapPath

        defaultsPath = path.resolve process.cwd(), defaultsPath
        defaults = Utils.load defaultsPath

        options =
            config:
                path: configPath
                data: config

            defaults:
                path: defaultsPath
                data: defaults

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
            throw new Error 'No existing config in ' + path.basename pathName

        return config

    saveConfig: (config, pathName)->
        new Promise (resolve, reject)->
            fs.writeFile pathName, JSON.stringify(config, null, 4), (err)->
                return reject err if err
                return resolve()

    saveObject: (object, pathName)->
        new Promise (resolve, reject)->
            fs.writeFile pathName, JSON.stringify(object, null, 4), (err)->
                return reject err if err
                return resolve()

    showConfig: (config)->
        console.log JSON.stringify config, null, 4

    parseString: (string)->
        return string unless _.isString string

        try
            result = JSON.parse string

        catch e
            result = string

        return result

    merge: (object, source)->
        return _.mergeWith object, source, (objValue, srcValue)->
            if _.isArray(objValue) and _.isArray(srcValue)
                return srcValue


module.exports = Utils
