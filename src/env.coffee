_     = require 'underscore'
utils = require './utils'

Env = (config, env, map)->
    if not _.isObject(map) or _.isEmpty(map)
        console.log 'Environment vars not defined'
        return config

    for envName, param of map
        if env[envName]?
            configItem = config
            paramName = param.split '.'

            for paramPart, index in paramName
                if index < paramName.length - 1
                    if typeof configItem[paramPart] isnt 'object'
                        configItem[paramPart] = {}

                    configItem = configItem[paramPart]

                else
                    configItem[paramPart] = utils.parseString env[envName]

    return config


module.exports = Env
