_       = require 'lodash'
fs      = require 'fs'
path    = require 'path'
cmd     = require 'commander'
utils   = require './utils'

actionFound  = false
actionSet    = require './set'
actionUnset  = require './unset'
actionReset  = require './reset'
actionPreset = require './preset'
actionEnv    = require './env'
actionExtend = require './extend'

program = new cmd.Command()


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

    targetSettings.scripts = _.assign targetSettings.scripts, setup: 'setupjs'

    try
        options.config.data = actionReset options.config.data, options.defaults.data

    catch e
        console.error e.message
        return

    Promise.resolve()
    .then ->
        utils.saveObject targetSettings, targetPkgPath

    .then ->
        utils.showConfig(targetSettings) if program.verbose

    .then ->
        saveConfig options.config.data, options.config.path, program.verbose


program
.command 'preset [name]'
.description 'Set config from preset'
.action (name)->
    actionFound = true
    options = utils.getOptions program, targetSettings

    try
        options.config.data = actionPreset options.config.data, options.presets.data, name

    catch e
        console.error e.message
        return

    saveConfig options.config.data, options.config.path, program.verbose


program
.command 'set [varValuePairs...]'
.description 'Set custom settings'
.action (varValuePairs)->
    actionFound = true
    options = utils.getOptions program, targetSettings

    try
        options.config.data = actionSet options.config.data, varValuePairs

    catch e
        console.error e.message
        return

    saveConfig options.config.data, options.config.path, program.verbose


program
.command 'unset [vars...]'
.description 'Remove custom settings'
.action (vars)->
    actionFound = true
    options = utils.getOptions program, targetSettings

    try
        options.config.data = actionUnset options.config.data, vars

    catch e
        console.error e.message
        return

    saveConfig options.config.data, options.config.path, program.verbose


program
.command 'env'
.description 'Set values from environment variables'
.action ->
    actionFound = true
    options = utils.getOptions program, targetSettings

    try
        options.config.data = actionEnv options.config.data, process.env, options.envMap.data

    catch e
        console.error e.message
        return

    saveConfig options.config.data, options.config.path, program.verbose


program
.command 'extend [path]'
.description 'Extend config from json file'
.action (filePath)->
    actionFound = true
    options = utils.getOptions program, targetSettings

    try
        options.config.data = actionExtend options.config.data, filePath

    catch e
        console.error e.message
        return

    saveConfig options.config.data, options.config.path, program.verbose


program
.command 'reset'
.description 'Reset all values to defaults'
.action ->
    actionFound = true
    options = utils.getOptions program, targetSettings

    try
        options.config.data = actionReset options.config.data, options.defaults.data

    catch e
        console.error e.message
        return

    saveConfig options.config.data, options.config.path, program.verbose


saveConfig = (data, filePath, verbose)->
    utils.saveConfig data, filePath
    .then ->
        utils.showConfig(data) if verbose

    .then ->
        console.log 'Setup done'


defaultCommand = ->
    return true unless targetSettings.setup

    changed = false

    if program.config
        targetSettings.setup.config   = program.config
        changed = true

    if program.presets
        targetSettings.setup.presets  = program.presets
        changed = true

    if program.envMap
        targetSettings.setup.envMap   = program.envMap
        changed = true

    if program.defaults
        targetSettings.setup.defaults = program.defaults
        changed = true

    if changed
        utils.saveObject targetSettings, targetPkgPath
        .then ->
            utils.showConfig(targetSettings) if program.verbose

    else if program.verbose
        options = utils.getOptions program, targetSettings
        utils.showConfig(options.config.data)


CLI = ->
    program.parse process.argv

    defaultCommand() unless actionFound


module.exports = CLI
