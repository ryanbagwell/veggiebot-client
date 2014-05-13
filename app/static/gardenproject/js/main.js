(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var $, Backbone, Garden, GardenData, d3, moment, _, _ref;
    $ = require('jquery');
    _ = require('underscore');
    Backbone = require('backbone');
    d3 = require('d3');
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

      Garden.prototype.initialize = function(options) {
        this.options = options;
        _.bindAll(this, 'drawChart', 'timeTickFormatter');
        this.gardenData = new GardenData();
        this.gardenData.on('reset', this.drawChart);
        return this.gardenData.fetch({
          reset: true
        });
      };

      Garden.prototype.drawChart = function() {
        var data, lines, moistureAxis, moistureAxisGroup, moistureScale, moistures, node, timeAxis, timeAxisGroup, timeScale, times;
        times = this.gardenData.map(function(model) {
          var time;
          time = model.get('time');
          return moment.utc(time).unix();
        });
        moistures = this.gardenData.map(function(model) {
          return model.get('moistureLevel');
        });
        timeScale = d3.scale.linear().domain([d3.min(times), d3.max(times)]).range([0, 1000]);
        moistureScale = d3.scale.linear().domain([500, 1023]).range([0, 500]);
        this.chart = d3.select("#chart").append('svg');
        this.chart.attr('width', '100%').attr('height', '500');
        this.chart.text("Garden Soil Moisture").select('#chart');
        data = this.gardenData.filter(function(model) {
          var _ref1;
          return (0 < (_ref1 = model.get('moistureLevel')) && _ref1 < 1023);
        }).map(function(model) {
          return {
            moisture: model.get('moistureLevel'),
            time: moment.utc(model.get('time')).unix()
          };
        });
        node = this.chart.selectAll('circle.node').data(data).enter().append('g').attr('class', 'node');
        node.append('svg:circle').attr('cx', function(d) {
          return timeScale(d.time);
        }).attr('cy', function(d) {
          return moistureScale(d.moisture);
        }).attr('r', '2px').attr('fill', 'black');
        this.chart.selectAll('circle.nodes').data(data).enter().append('svg.circle').attr('cx', function(d) {
          return timeScale(d.time);
        }).attr('cy', function(d) {
          return moistureScale(d.moisture);
        });
        lines = _.map(this.chart.selectAll('circle')[0], function(circle, i, list) {
          try {
            return {
              source: [$(circle).attr('cx'), $(circle).attr('cy')],
              target: [$(list[i + 1]).attr('cx'), $(list[i + 1]).attr('cy')]
            };
          } catch (_error) {

          }
        });
        lines.pop();
        this.chart.selectAll('.line').data(lines).enter().append('line').attr('x1', function(d) {
          return d.source[0];
        }).attr('y1', function(d) {
          return d.source[1];
        }).attr('x2', function(d) {
          return d.target[0];
        }).attr('y2', function(d) {
          return d.target[1];
        }).style('stroke', 'black');
        timeAxis = d3.svg.axis().scale(timeScale).orient('bottom').tickFormat(this.timeTickFormatter);
        timeAxisGroup = this.chart.append('g').attr({
          'class': 'axis x',
          'transform': 'translate(0, 500)'
        }).call(timeAxis);
        moistureAxis = d3.svg.axis().scale(moistureScale).orient('left').ticks(10);
        return moistureAxisGroup = this.chart.append('g').attr({
          "transform": "translate(0,0)",
          'class': 'axis y'
        }).call(moistureAxis);
      };

      Garden.prototype.timeTickFormatter = function(timestamp) {
        return moment.unix(timestamp).tz('America/Chicago').format('ddd, hA');
      };

      return Garden;

    })(Backbone.View);
  });

}).call(this);

/*
//@ sourceMappingURL=main.js.map
*/