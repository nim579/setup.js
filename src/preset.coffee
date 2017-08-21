_     = require 'underscore'
utils = require './utils'

Preset = (config, presets, name)->
    if not _.isEmpty(presets) and name and presets[name]
        config = utils.deepObjectExtend config, presets[name]

    else
        console.log 'No presets found'
        return config


module.exports = Preset
