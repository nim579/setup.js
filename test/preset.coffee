_ = require('lodash')
assert = require('assert')
preset = require('../src/preset')


describe 'Command Preset', ->
    it 'should be function', ->
        assert _.isFunction preset

    it 'should throw if no preset', ->
        config = first: 123

        presets =
            preset: first: 321

        assert.throws ->
            preset config, presets, 'preset2'

        , message: 'No presets found'

    it 'should preset', ->
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
                {asd: 123}
                {zxc: '42'}
            ]

        presets =
            dev:
                second: 'zxc'
                third: [3, 4]

                fourth:
                    four: [4, 5, 6]

                sixth: [
                    asd: 321
                ]

        result = preset config, presets, 'dev'

        assert.deepEqual
            first: 123
            second: 'zxc'
            third: [3, 4]

            fourth:
                one: 'asd'
                two: 'ddd'
                three:
                    ooo: [1, 2, 3]

                four: [4, 5, 6]

            fifth: [0, 9, 8]

            sixth: [
                {asd: 321}
            ]

        , result

    it 'should not mutate config', ->
        config =
            first: 123
            third: 'ddd'

        presets =
            preset: first: 321

        defaults = first: 0, second: 'ddd'

        result = preset config, presets, 'preset'

        assert.deepEqual
            first: 123
            third: 'ddd'
        , config
