_ = require('lodash')
assert = require('assert')
unset = require('../src/unset')


describe 'Command Unset', ->
    it 'should be function', ->
        assert _.isFunction unset

    it 'should throw if empty', ->
        config = first: 123

        assert.throws ->
            unset config

        , message: 'No parameters found'

    it 'should unset', ->
        config =
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

            sixth:
                one: [
                    two: foo: 'bar'
                ]

        result = unset config, [
            'second'
            'third[0]'
            'fourth.two'
            'fourth.three.aaa'
            'fourth.three.bbb'
        ]

        arr = [7, 8, 9]
        delete arr[0]

        assert.deepEqual
            first: 456
            third: arr

            fourth:
                one: 'zxc'
                three:
                    ooo: 123

                four: 123

            fifth: true

            sixth:
                one: [
                    two: foo: 'bar'
                ]

        , result


    it 'should not mutate config', ->
        config = first:
            one: [1, 2, 3]
            two: 123

        result = unset config, ['first.one[2]']

        assert.equal '[1,2,3]',    JSON.stringify config.first.one
        assert.equal '[1,2,null]', JSON.stringify result.first.one
