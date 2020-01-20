_ = require('lodash')
fs = require('fs')
path = require('path')
assert = require('assert')
utils = require('../src/utils')


describe 'Utils', ->
    describe 'getOptions()', ->
        defUtilsLoad = null

        beforeEach ->
            defUtilsLoad = utils.load

        afterEach ->
            utils.load = defUtilsLoad

        it 'should be function', ->
            assert _.isFunction utils.getOptions

        it 'should return options by default', ->
            loadCalls = []

            utils.load = (filePath)->
                loadCalls.push filePath

            result = utils.getOptions()

            assert.deepEqual [
                path.resolve process.cwd(), 'config.json'
                path.resolve process.cwd(), 'presets.json'
                path.resolve process.cwd(), 'env-map.json'
                path.resolve process.cwd(), 'defaults.json'
            ], loadCalls

            assert.deepEqual
                config:
                    path: path.resolve process.cwd(), 'config.json'
                    data: 1
                defaults:
                    path: path.resolve process.cwd(), 'defaults.json'
                    data: 4
                presets:
                    path: path.resolve process.cwd(), 'presets.json'
                    data: 2
                envMap:
                    path: path.resolve process.cwd(), 'env-map.json'
                    data: 3
            , result

        it 'should return options by settings', ->
            loadCalls = []

            utils.load = (filePath)->
                loadCalls.push filePath

            result = utils.getOptions {}, setup:
                config: 'settings/config.json'
                presets: 'settings/presets.json'
                envMap: 'settings/env-map.json'
                defaults: 'settings/defaults.json'

            assert.deepEqual [
                path.resolve process.cwd(), 'settings/config.json'
                path.resolve process.cwd(), 'settings/presets.json'
                path.resolve process.cwd(), 'settings/env-map.json'
                path.resolve process.cwd(), 'settings/defaults.json'
            ], loadCalls

            assert.deepEqual
                config:
                    path: path.resolve process.cwd(), 'settings/config.json'
                    data: 1
                defaults:
                    path: path.resolve process.cwd(), 'settings/defaults.json'
                    data: 4
                presets:
                    path: path.resolve process.cwd(), 'settings/presets.json'
                    data: 2
                envMap:
                    path: path.resolve process.cwd(), 'settings/env-map.json'
                    data: 3
            , result

        it 'should return options by program', ->
            loadCalls = []

            utils.load = (filePath)->
                loadCalls.push filePath

            result = utils.getOptions
                config: 'program/config.json'
                presets: 'program/presets.json'
                envMap: 'program/env-map.json'
                defaults: 'program/defaults.json'

            assert.deepEqual [
                path.resolve process.cwd(), 'program/config.json'
                path.resolve process.cwd(), 'program/presets.json'
                path.resolve process.cwd(), 'program/env-map.json'
                path.resolve process.cwd(), 'program/defaults.json'
            ], loadCalls

            assert.deepEqual
                config:
                    path: path.resolve process.cwd(), 'program/config.json'
                    data: 1
                defaults:
                    path: path.resolve process.cwd(), 'program/defaults.json'
                    data: 4
                presets:
                    path: path.resolve process.cwd(), 'program/presets.json'
                    data: 2
                envMap:
                    path: path.resolve process.cwd(), 'program/env-map.json'
                    data: 3
            , result

        it 'should owerwrite settings by program', ->
            utils.load = (filePath)-> true

            p = (filePath)-> path.resolve process.cwd(), filePath

            assert.equal p('settings/config.json'), utils.getOptions({}, setup: config: 'settings/config.json').config.path
            assert.equal p('program/config.json'), utils.getOptions({config: 'program/config.json'}, setup: config: 'settings/config.json').config.path

            assert.equal p('settings/defaults.json'), utils.getOptions({}, setup: defaults: 'settings/defaults.json').defaults.path
            assert.equal p('program/defaults.json'), utils.getOptions({defaults: 'program/defaults.json'}, setup: defaults: 'settings/defaults.json').defaults.path

            assert.equal p('settings/presets.json'), utils.getOptions({}, setup: presets: 'settings/presets.json').presets.path
            assert.equal p('program/presets.json'), utils.getOptions({presets: 'program/presets.json'}, setup: presets: 'settings/presets.json').presets.path

            assert.equal p('settings/env-map.json'), utils.getOptions({}, setup: envMap: 'settings/env-map.json').envMap.path
            assert.equal p('program/env-map.json'), utils.getOptions({envMap: 'program/env-map.json'}, setup: envMap: 'settings/env-map.json').envMap.path

    describe 'load()', ->
        it 'should be function', ->
            assert _.isFunction utils.load

        it 'should return empty', ->
            assert.equal '{}', JSON.stringify utils.load()

        it 'should throw if not found', ->
            assert.throws ->
                utils.load('./foo.json')

            , message: 'No existing config in foo.json'

        it 'should throw if broken json', ->
            assert.throws ->
                utils.load path.resolve process.cwd(), './test/fixtures/broken.json'

            , message: 'No existing config in broken.json'

        it 'should load', ->
            result = utils.load path.resolve process.cwd(), './test/fixtures/load.json'

            assert.equal true, result.test

    describe 'saveConfig()', ->
        it 'should be function', ->
            assert _.isFunction utils.saveConfig

        it 'should throw if cant save', ->
            filePath = path.resolve process.cwd(), './tast/test.json'
            assert.rejects ->
                utils.saveConfig {foo: 'bar'}, filePath

        it 'should save', ->
            filePath = path.resolve process.cwd(), './test/test.json'

            assert.doesNotReject ->
                utils.saveConfig {foo: 'bar'}, filePath
                .then ->
                    fs.unlinkSync filePath

    describe 'saveObject()', ->
        it 'should be function', ->
            assert _.isFunction utils.saveConfig

        it 'should throw if cant save', ->
            filePath = path.resolve process.cwd(), './tast/test.json'
            assert.rejects ->
                utils.saveConfig {foo: 'bar'}, filePath

        it 'should save', ->
            filePath = path.resolve process.cwd(), './test/test.json'

            assert.doesNotReject ->
                utils.saveConfig {foo: 'bar'}, filePath
                .then ->
                    fs.unlinkSync filePath

    describe 'showConfig()', ->
        defConsole = null

        beforeEach ->
            defConsole = console.log

        afterEach ->
            console.log = defConsole

        it 'should be function', ->
            assert _.isFunction utils.showConfig

        it 'should console object', ->
            object = foo: 'bar'

            console.log = (string)->
                assert.equal JSON.stringify(object, null, 4), string

            utils.showConfig object

        it 'should console empty', ->
            object = foo: 'bar'

            console.log = (string)->
                assert.equal JSON.stringify(undefined), string

            utils.showConfig()

    describe 'parseString()', ->
        it 'should be function', ->
            assert _.isFunction utils.parseString

        it 'should parse string', ->
            assert.equal 123, utils.parseString  123
            assert.equal 123, utils.parseString '123'

            assert.equal true,  utils.parseString 'true'
            assert.equal false, utils.parseString 'false'

            assert.equal 'asd', utils.parseString 'asd'

            assert.deepEqual '{ foo: 123 }', utils.parseString '{ foo: 123 }'
            assert.deepEqual {foo: 'bar'}, utils.parseString '{ "foo": "bar" }'
            assert.deepEqual [1, 2, {a: 'b'}], utils.parseString '[1, 2, { "a": "b"}]'

    describe 'merge()', ->
        it 'should be function', ->
            assert _.isFunction utils.merge

        it 'should merge', ->
            o1 =
                a: 1
                b: '2'
                c: [1, 2, 3]
                d: { da: 1, dc: 432 }

            o2 =
                a: '11'
                c: [5]
                d: {da: 2, db: 123}

            result = utils.merge o1, o2

            assert.deepEqual
                a: '11'
                b: '2'
                c: [5]
                d: { da: 2, db: 123, dc: 432 }

            , result
