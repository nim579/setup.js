utils = require './utils'

Set = (config, varValuePairs)->
    if varValuePairs.length is 0
        console.log 'No parameters found'
        return config

    if varValuePairs.length % 2 isnt 0
        console.log 'Parameters count is not even'
        return config

    i = 0
    while i < varValuePairs.length
        paramName = varValuePairs[i].split '.'
        configItem = config

        j = 0
        while j < paramName.length
            if j < paramName.length - 1
                if typeof configItem[paramName[j]] isnt 'object'
                    configItem[paramName[j]] = {}

                configItem = configItem[paramName[j]]

            else
                configItem[paramName[j]] = utils.parseString varValuePairs[i+1]

            j++

        i += 2

    return config


module.exports = Set
