_ = require('lodash')
assert = require('assert')
set = require('../src/set')


describe 'Command Set', ->
    it 'should be function', ->
        assert _.isFunction set

    it 'should throw if empty', ->
        config = first: 123

        assert.throws ->
            set config

        , message: 'No parameters found'

    it 'should throw if no last value', ->
        config = first: 123
        throwMessage = message: 'Parameters count is not even'

        assert.throws ->
            set config, ['a']

        , throwMessage

        assert.throws ->
            set config, ['a', 'b', 'c', 'd', 'e']

        , throwMessage

    it 'should set', ->
        config =
            first: 123
            second: 'asd'
            third: [1, 2, 3]

            fourth:
                one: 'asd'
                two: 'ddd'
                three:
                    ooo: [1, 2, 3]

                four:
                    aaa: [1, 2, 3]


            fifth: [0, 9, 8]

            sixth: [
                { asd: 123 }
            ]

        result = set config, [
            'first', '456'
            'second', 'fgh'
            'third', '[7,8,9]'
            'fourth.one', 'zxc'
            'fourth.two', 'false'
            'fourth.three.ooo', '123'
            'fourth.three.aaa', '[1, 2, 3]'
            'fourth.three.bbb', '{"foo": "bar"}'
            'fourth.four', '123'
            'fifth', 'true'
            'sixth[0].asd', '321'
            'seventh.one[0].two', '{"foo": "bar"}'
        ]

        assert.deepEqual
            first: 456
            second: 'fgh'
            third: [7, 8, 9]

            fourth:
                one: 'zxc'
                two: false
                three:
                    ooo: 123
                    aaa: [1, 2, 3]
                    bbb: foo: 'bar'
                four: 123

            fifth: true

            sixth: [
                asd: 321
            ]

            seventh:
                one: [
                    two: foo: 'bar'
                ]

        , result

    it 'should not mutate config', ->
        config = first: one: 123
        result = set config, ['first.one', 456]

        assert.equal 123, config.first.one
        assert.equal 456, result.first.one
