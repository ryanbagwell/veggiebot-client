(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var $, Backbone, Garden, GardenData, d3, moment, nv, _, _ref;
    $ = require('jquery');
    _ = require('underscore');
    Backbone = require('backbone');
    d3 = require('d3');
    nv = require('nvd3');
    GardenData = require('gardenData');
    moment = require('moment');
    require('moment-timezone');
    require('tzdata');
    return Garden = (function(_super) {
      __extends(Garden, _super);

      function Garden() {
        _ref = Garden.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Garden.prototype.growToSize = '25px';

      Garden.prototype.dotSize = '5px';

      Garden.prototype.sensor1Color = 'blue';

      Garden.prototype.sensor2Color = '#407740';

      Garden.prototype.initialize = function(options) {
        var _this = this;
        this.options = options;
        _.bindAll(this, 'drawChart', 'getData');
        this.gardenData = new GardenData();
        this.gardenData.on('reset', function() {
          return nv.addGraph(_this.drawChart);
        });
        return this.gardenData.fetch();
      };

      Garden.prototype.drawChart = function() {
        var chart, data, formatter, times, __;
        __ = this;
        data = this.getData();
        times = this.gardenData.map(function(model) {
          var t;
          t = model.get('time');
          return moment.utc(t).unix();
        });
        chart = nv.models.linePlusBarChart().margin({
          top: 30,
          right: 60,
          bottom: 50,
          left: 70
        }).x(function(d, i) {
          return i;
        }).color(d3.scale.category10().domain([d3.min(times), d3.max(times)]).range());
        formatter = _.bind(function(d, i) {
          var m, t;
          i = i ? i : d;
          m = this.gardenData.at(i);
          t = m.get('createdAt');
          return moment(t).tz('America/Chicago').format("ddd, hA");
        }, this);
        chart.xAxis.tickFormat(formatter).showMaxMin(false);
        chart.y1Axis.tickFormat(function(d, i) {
          return parseInt(d) + "°F";
        }).showMaxMin(false);
        chart.y2Axis.tickFormat(function(d, i) {
          return Math.round(d) + '%';
        }).showMaxMin(false);
        d3.select('#chart1 svg').datum(data).transition().duration(500).call(chart);
        nv.utils.windowResize(chart.update);
        chart.dispatch.on('stateChange', function(e) {
          return nv.log('New State:', JSON.stringify(e));
        });
        return chart;
      };

      Garden.prototype.getData = function() {
        var dataSets;
        dataSets = [
          {
            bar: false,
            key: 'Soil Moisture',
            originalKey: 'Soil Moisture',
            values: this.gardenData.map(function(model) {
              return {
                x: moment.utc(model.get('createdAt')).unix(),
                y: model.get('moistureLevel')
              };
            })
          }, {
            bar: true,
            key: 'Soil Temperature',
            originalKey: 'Soil Temperature',
            values: this.gardenData.map(function(model) {
              return {
                x: moment.utc(model.get('createdAt')).unix(),
                y: model.get('temperature')
              };
            })
          }
        ];
        return dataSets;
      };

      return Garden;

    })(Backbone.View);
  });

}).call(this);

/*
//@ sourceMappingURL=main.js.map
*/