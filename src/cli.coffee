_       = require 'underscore'
fs      = require 'fs'
path    = require 'path'
program = require 'commander'
utils   = require './utils'

actionFound  = false
actionSet    = require './set'
actionUnset  = require './unset'
actionReset  = require './reset'
actionPreset = require './preset'
actionEnv    = require './env'


CLI = ->
    # Устанавливаем основные пути
    modulePath = path.dirname process.mainModule.filename
    pkg = require path.join modulePath, '../package.json'

    targetPkgPath = path.resolve process.cwd(), './package.json'
    targetSettings = require targetPkgPath

    options = {}

    program
    .version pkg.version
    .option '-v, --verbose', 'Verbose mode'
    .option '-c, --config [file]', 'Set path to config file', null
    .option '-e, --env-map [file]', 'Set path to env map file', null
    .option '-p, --presets [file]', 'Set path to preset file', null
    .option '-d, --defaults [file]', 'Set path to default defaults file', null


    # Дописываем в help доступные пресеты
    program.on '--help', ->
        options = utils.getOptions program, targetSettings
        console.log '  Available presets:'
        console.log ''
        for preset of options.presets.data
            console.log '    ' + preset


    program
    .command 'init'
    .description 'Init setup module'
    .action (varValuePairs)->
        actionFound = true
        options = utils.getOptions program, targetSettings

        targetSettings.setup =
            config: if program.config then program.config else 'config.json'
            presets: if program.presets then program.presets else 'presets.json'
            envMap: if program.envMap then program.envMap else 'env-map.json'
            defaults: if program.defaults then program.defaults else 'defaults.json'

        targetSettings.scripts = _.extend targetSettings.scripts,
            setup: 'setupjs'

        options.config.data = actionReset options.config.data, options.defaults.data

        utils.saveObject targetSettings, targetPkgPath
        utils.showConfig(targetSettings) if program.verbose

        utils.saveConfig options.config.data, options.config.path
        utils.showConfig(options.config.data) if program.verbose


    program
    .command 'preset [name]'
    .description 'Set config from preset'
    .action (name)->
        actionFound = true
        options = utils.getOptions program, targetSettings

        options.config.data = actionPreset options.config.data, options.presets.data, name

        utils.saveConfig options.config.data, options.config.path
        utils.showConfig(options.config.data) if program.verbose


    program
    .command 'set [varValuePairs...]'
    .description 'Set custom settings'
    .action (varValuePairs)->
        actionFound = true
        options = utils.getOptions program, targetSettings

        options.config.data = actionSet options.config.data, varValuePairs

        utils.saveConfig options.config.data, options.config.path
        utils.showConfig(options.config.data) if program.verbose


    program
    .command 'unset [vars...]'
    .description 'Remove custom settings'
    .action (vars)->
        actionFound = true
        options = utils.getOptions program, targetSettings

        options.config.data = actionUnset options.config.data, vars

        utils.saveConfig options.config.data, options.config.path
        utils.showConfig(options.config.data) if program.verbose


    program
    .command 'env'
    .description 'Set values from environment variables'
    .action ->
        actionFound = true
        options = utils.getOptions program, targetSettings

        options.config.data = actionEnv options.config.data, process.env, options.envMap.data

        utils.saveConfig options.config.data, options.config.path
        utils.showConfig(options.config.data) if program.verbose


    program
    .command 'reset'
    .description 'Reset all values to defaults'
    .action ->
        actionFound = true
        options = utils.getOptions program, targetSettings

        options.config.data = actionReset options.config.data, options.defaults.data

        utils.saveConfig options.config.data, options.config.path
        utils.showConfig(options.config.data) if program.verbose


    program.parse process.argv


    unless actionFound
        if targetSettings.setup
            if program.config or program.presets or program.defaults
                targetSettings.setup.config = program.config if program.config
                targetSettings.setup.presets = program.presets if program.presets
                targetSettings.setup.envMap = program.envMap if program.envMap
                targetSettings.setup.defaults = program.defaults if program.defaults

                utils.saveObject targetSettings, targetPkgPath
                utils.showConfig(targetSettings) if program.verbose

            else
                if program.verbose
                    options = utils.getOptions program, targetSettings
                    utils.showConfig(options.config.data)

module.exports = CLI
