_ = require('lodash')
assert = require('assert')
extend = require('../src/extend')


describe 'Command Extend', ->
    it 'should be function', ->
        assert _.isFunction extend

    it 'should throw if no path', ->
        config = first: 123

        assert.throws ->
            extend config

        , message: 'No file for extending'

    it 'should throw if extend file not found', ->
        config = first: 123

        assert.throws ->
            extend config, 'foo'

        , message: 'File for extending not found'

    it 'should throw if parse error', ->
        config = first: 123

        assert.throws ->
            extend config, './index.js'

        , message: 'Can\'t load or parse extending file'

    it 'should extend', ->
        config =
            test: { foo: 'bar' },
            test_2:
                zxc: 123
                asd: [4, 5, 6]
                margin: foo: true

        result = extend config, './test/fixtures/extend.json'

        assert.deepEqual
            test: 123
            test_2:
                asd: [1, 2, 3]
                margin: 'beta'
                zxc: 123
            test_3: [
                foo: "bar"
            ]
        , result

    it 'should not mutate config', ->
        config = test: 345
        map  = ONE: 'first'
        data = ONE: true

        result = extend config, './test/fixtures/extend.json'

        assert.equal 345, config.test
        assert.equal 123, result.test
