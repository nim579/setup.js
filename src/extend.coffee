_     = require 'underscore'
fs    = require 'fs'
path  = require 'path'
utils = require './utils'

Extend = (config, filePath)->
    extend = {}

    unless filePath
        console.log 'No file for extending'
        return config

    rootPath = path.resolve process.cwd(), filePath

    unless fs.existsSync rootPath
        console.log 'File for extending not found'
        return config

    try
        file = fs.readFileSync(rootPath).toString()
        extend = JSON.parse file

    catch
        console.log "Can't load or parse extending file"
        return config

    config = utils.deepObjectExtend config, extend
    return config


module.exports = Extend
