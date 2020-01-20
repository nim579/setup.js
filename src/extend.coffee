_     = require 'lodash'
fs    = require 'fs'
path  = require 'path'
utils = require './utils'


Extend = (config, filePath)->
    extend = {}

    unless filePath
        throw new Error 'No file for extending'

    rootPath = path.resolve process.cwd(), filePath

    unless fs.existsSync rootPath
        throw new Error 'File for extending not found'

    try
        file = fs.readFileSync(rootPath).toString()
        extend = JSON.parse file

    catch
        throw new Error 'Can\'t load or parse extending file'

    config = _.cloneDeep config
    return utils.merge config, extend


module.exports = Extend
