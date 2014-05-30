(function() {
  require.config({
    baseUrl: 'static/gardenproject/js/',
    paths: {
      'jquery': ['https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min', '../third-party/jquery/jquery'],
      'backbone': '../../third-party/backbone/backbone',
      'underscore': '../../third-party/underscore/underscore-min',
      'd3': '../../third-party/d3/d3.min',
      'nvd3': '../../third-party/nvd3/nvd3.min',
      'moment': '../../third-party/moment/moment',
      'moment-timezone': '../../third-party/moment-timezone/moment-timezone',
      main: 'main',
      gardenData: 'gardendata',
      tzdata: 'data.timezone'
    },
    shim: {
      'jquery': {
        exports: '$'
      },
      'backbone': {
        deps: ['jquery', 'underscore']
      },
      'underscore': {
        exports: '_'
      },
      'd3': {
        exports: 'd3'
      },
      'moment': {
        exports: 'moment'
      },
      'moment-timezone': {
        deps: ['moment']
      },
      'tzdata': {
        deps: ['moment-timezone']
      },
      'nvd3': {
        deps: ['d3'],
        exports: 'nv'
      }
    }
  });

}).call(this);

/*
//@ sourceMappingURL=require.config.js.map
*/