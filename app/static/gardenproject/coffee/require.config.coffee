require.config
    baseUrl: 'static/gardenproject/js/'

    paths:
        'jquery': [
            'https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min'
            '../../third-party/jquery/jquery'
        ]
        'backbone': '../../third-party/backbone/backbone'
        'underscore': '../../third-party/underscore/underscore-min'
        'd3': '../../third-party/d3/d3.min'
        'nvd3': '../../third-party/nvd3/nv.d3.min'
        'moment':'../../third-party/moment/moment'
        'moment-timezone': '../../third-party/moment-timezone/moment-timezone'
        'underscore.string': '../../third-party/underscore.string/dist/underscore.string.min'
        'Framework7': '../../third-party/framework7/dist/js/framework7.min'
        'jquery.picplus': '../../third-party/jquery.picplus/jquery.picplus'
        'parse.com': '../../third-party/parse.com/index'

        Parse: 'lib.parse'
        gardenChart: 'gardenchart'
        main: 'main'
        GardenData: 'collection.gardendata'
        CurrentStatusView: 'view.currentStatus'

        settingsData: 'settings.collection'

        SoilTextureCollection: 'collection.soiltexture'
        SoilTextureView: 'view.soiltexture'

        tzdata: 'data.timezone'
        mobile: 'mobile'

    shim:
        'jquery':
            exports: '$'
        'backbone':
            deps: ['jquery', 'underscore']
        'underscore':
            exports: '_'
        'd3':
            exports: 'd3'
        'moment':
            exports: 'moment'
        'moment-timezone':
            deps: ['moment']
        'tzdata':
            deps: ['moment-timezone']
        'nvd3':
            deps: ['d3']
            exports: 'nv'
        'underscore.string':
            deps: ['underscore']
            exports: '_.str'
        'Framework7':
            exports: 'Framework7'
        'jquery.picplus':
            deps: ['jquery']
        'parse.com':
            exports: 'Parse'











