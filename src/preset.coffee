_ = require 'lodash'
utils = require './utils'


Preset = (config, presets = {}, name)->
    if presets?[name]
        config = _.cloneDeep config
        config = utils.merge config, presets[name], utils.mergeCustomizerArray

    else
        throw new Error 'No presets found'


module.exports = Preset
