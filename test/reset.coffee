_ = require('lodash')
assert = require('assert')
reset = require('../src/reset')


describe 'Command Reset', ->
    it 'should be function', ->
        assert _.isFunction reset

    it 'should reset', ->
        config   = first: 123, third: 'ddd'
        defaults = first: 0, second: 'ddd'

        assert.deepEqual defaults, reset config, defaults

    it 'should reset empty', ->
        config   = first: 123, third: 'ddd'
        defaults = first: 0, second: 'ddd'

        assert.deepEqual {}, reset config

    it 'should not mutate config', ->
        config   = first: 123, third: 'ddd'
        expected = JSON.parse JSON.stringify config
        defaults = first: 0, second: 'ddd'

        result = reset config, defaults

        assert.deepEqual expected, config
