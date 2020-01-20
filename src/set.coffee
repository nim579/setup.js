_ = require 'lodash'
utils = require './utils'


Set = (config, varValuePairs = [])->
    if varValuePairs.length is 0
        throw new Error 'No parameters found'

    if varValuePairs.length % 2 isnt 0
        throw new Error 'Parameters count is not even'

    config = _.cloneDeep config
    pairs  = _.chunk(varValuePairs, 2)

    _.forEach pairs, (pair)->
        _.set config, pair[0],  utils.parseString pair[1]

    return config


module.exports = Set
