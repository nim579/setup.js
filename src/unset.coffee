_ = require 'lodash'


Unset = (config, vars = [])->
    if vars.length is 0
        throw new Error 'No parameters found'

    config = _.cloneDeep config

    _.forEach vars, (key)->
        _.unset config, key

    return config


module.exports = Unset
