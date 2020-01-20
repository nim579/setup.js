_     = require 'lodash'
utils = require './utils'


Env = (config, env, map)->
    if not _.isObject(map) or _.isEmpty(map)
        throw new Error 'Invalid or empty env maps'

    config = _.cloneDeep config

    _.forEach map, (pathStr, key)->
        paths = pathStr.split(/,\s{0,}/)

        _.forEach paths, (path)->
            _.set config, path, utils.parseString env[key] if env[key]?

    return config


module.exports = Env
