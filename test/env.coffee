_ = require('lodash')
assert = require('assert')
env = require('../src/env')


describe 'Command Env', ->
    it 'should be function', ->
        assert _.isFunction env

    it 'should throw if no some confs', ->
        config = first: 123

        envData =
            first: 321

        assert.throws ->
            env config, envData, ''

        , message: 'Invalid or empty env maps'

        assert.throws ->
            env config, null, {}

        , message: 'Invalid or empty env maps'

    it 'should set env', ->
        config =
            first: 123
            second: 'asd'
            third: [1, 2, 3]

            fourth:
                one: 'asd'
                two: 'ddd'
                three:
                    ooo: [1, 2, 3]

            fifth: [
                {asd: 123}
                {zxc: '42'}
            ]

        map =
            'ONE': 'first,fourth.one'
            'TWO': 'third[1]'
            'THREE': 'fifth[1].zxc, fifth[1].bbb,   fifth[2].vbn'
            'FOUR': 'second'
            'FIVE': 'fourth.three.ooo'
            'SIX': 'fourth'

        envVars =
            ONE: 'utl'
            TWO: '9323'
            THREE: '{ "foo": [1] }'
            FOUR: ''
            FIVE: '[1, 2]'
            SEVEN: 'true'

        result = env config, envVars, map

        assert.deepEqual
            first: 'utl'
            second: ''
            third: [1, 9323, 3]

            fourth:
                one: 'utl'
                two: 'ddd'
                three:
                    ooo: [1, 2]

            fifth: [
                {asd: 123}
                {zxc: { foo: [1] }, bbb: { foo: [1] }}
                {vbn: { foo: [1] }}
            ]
        , result

    it 'should not mutate config', ->
        config = first: one: 123
        map  = ONE: 'first'
        data = ONE: true

        result = env config, data, map

        assert.equal 123, config.first.one
        assert.equal true, result.first
