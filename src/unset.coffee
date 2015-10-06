Unset = (config, vars)->
    if vars.length is 0
        console.log 'No parameters found'
        return false

    i = 0
    while i < vars.length
        paramName = vars[i].split '.'
        configItem = config

        j = 0
        while j < paramName.length
            if j < paramName.length - 1
                break if typeof configItem[paramName[j]] isnt 'object'

                configItem = configItem[paramName[j]]

            else
                delete configItem[paramName[j]]

            j++

        i++

    return config


module.exports = Unset
