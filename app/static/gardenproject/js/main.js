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

      Garden.prototype.growToSize = '25px';

      Garden.prototype.dotSize = '5px';

      Garden.prototype.sensor1Color = 'blue';

      Garden.prototype.sensor2Color = '#407740';

      Garden.prototype.initialize = function(options) {
        var _this = this;
        this.options = options;
        _.bindAll(this, 'drawChart', 'timeTickFormatter');
        this.gardenData = new GardenData();
        this.gardenData.on('reset', this.drawChart);
        this.gardenData.fetch({
          reset: true
        });
        return $(window).on('resize', function() {
          _this.destroy();
          return _this.drawChart();
        });
      };

      Garden.prototype.drawChart = function() {
        var cautionZone, dangerZone, data, maxPoints, moistureAxis, moistureAxisGroup, okZone, sensor1Data, sensor2Data, timeAxis, timeAxisGroup, times, zones;
        times = this.gardenData.map(function(model) {
          var time;
          time = model.get('time');
          return moment.utc(time).unix();
        });
        maxPoints = _.min([Math.ceil($(window).width() * 100 / 1500), 100]);
        if (maxPoints < 100) {
          data = this.gardenData.filter(function(model, i) {
            return i % Math.ceil(100 / maxPoints);
          });
        } else {
          data = this.gardenData;
        }
        sensor1Data = data.filter(function(model) {
          var _ref1;
          return (500 < (_ref1 = model.get('sensor1')) && _ref1 < 1000);
        }).map(function(model) {
          return {
            moisture: model.get('sensor1'),
            time: moment.utc(model.get('time')).unix()
          };
        });
        sensor2Data = data.filter(function(model) {
          var _ref1;
          return (500 < (_ref1 = model.get('sensor2')) && _ref1 < 1000);
        }).map(function(model) {
          return {
            moisture: model.get('sensor2'),
            time: moment.utc(model.get('time')).unix()
          };
        });
        this.timeScale = d3.scale.linear().domain([d3.min(times), d3.max(times)]).range([0, $(window).width() - 110]);
        this.sensorScale = d3.scale.linear().domain([1000, 500]).range([0, 500]);
        this.chart = d3.select("#chart").append('svg');
        this.chart.attr('width', ($(window).width() - 100) + 'px').attr('height', '500');
        this.chart.text("Garden Soil Moisture").select('#chart');
        zones = this.chart.append('g').attr({
          "class": 'zones',
          width: '100%'
        });
        dangerZone = zones.append('rect').attr({
          "class": 'death-valley',
          x: 0,
          y: 400,
          width: this.chart.attr('width'),
          height: 100,
          fill: 'red',
          opacity: .5
        });
        cautionZone = zones.append('rect').attr({
          "class": 'caution',
          x: 0,
          y: 200,
          width: '100%',
          height: 200,
          fill: '#e3b102',
          opacity: .5
        });
        okZone = zones.append('rect').attr({
          "class": 'ok',
          x: 0,
          y: 0,
          width: '100%',
          height: 200,
          fill: 'green',
          opacity: .5
        });
        this.plotData(sensor1Data, this.sensor1Color, 'sensor-1');
        this.plotData(sensor2Data, this.sensor2Color, 'sensor-2');
        timeAxis = d3.svg.axis().scale(this.timeScale).orient('bottom').ticks(Math.floor($(window).width() / 100)).tickFormat(this.timeTickFormatter);
        timeAxisGroup = this.chart.append('g').attr({
          'class': 'axis x',
          'transform': 'translate(0, 500)'
        }).call(timeAxis);
        moistureAxis = d3.svg.axis().scale(this.sensorScale).orient('left').ticks(10).tickFormat(function(num, i) {
          return num;
        });
        moistureAxisGroup = this.chart.append('g').attr({
          "transform": "translate(0,0)",
          'class': 'axis y'
        }).call(moistureAxis);
        return moistureAxisGroup.append('text').attr('class', 'label y').attr('text-anchor', 'end').attr("y", 6).attr('dy', '.75em').attr('transform', 'rotate(-90)').text('Saturated');
      };

      Garden.prototype.timeTickFormatter = function(timestamp) {
        return moment.unix(timestamp).tz('America/Chicago').format('ddd, hA');
      };

      Garden.prototype.growDot = function(data, i) {
        var node;
        node = d3.selectAll('g.node')[0][i];
        return d3.select(node).select('circle').transition().attr('r', '25px');
      };

      Garden.prototype.shrinkDot = function(data, i) {
        var node;
        node = d3.selectAll('g.node')[0][i];
        return d3.select(node).select('circle').transition().attr('r', this.dotSize);
      };

      Garden.prototype.destroy = function() {
        $('svg').remove();
        return this.chart = null;
      };

      Garden.prototype.plotData = function(data, color, cssClass) {
        var container, lines,
          _this = this;
        container = this.chart.selectAll('circle.node').data(data).enter().append('g').attr('class', cssClass);
        container.append('svg:circle').attr('cx', function(d) {
          return _this.timeScale(d.time);
        }).attr('cy', function(d) {
          return _this.sensorScale(d.moisture);
        }).attr('r', this.dotSize).attr('fill', color).on('mouseover', function(data, i) {
          d3.select(this.parentNode).attr('class', 'node text-visible');
          return d3.select(this).transition().attr({
            'r': '25px'
          });
        }).on('mouseout', function(data, i) {
          d3.select(this.parentNode).attr('class', 'node');
          return d3.select(this).transition().attr('r', '5px');
        });
        container.append('text').attr('x', function(d) {
          return _this.timeScale(d.time);
        }).attr('y', function(d) {
          return _this.sensorScale(d.moisture);
        }).text(function(data, i) {
          return data.moisture;
        }).attr("text-anchor", "middle").attr('dy', '35px').attr('class', 'value-label');
        lines = _.map(this.chart.selectAll('g.' + cssClass + ' circle')[0], function(circle, i, list) {
          try {
            return {
              source: [$(circle).attr('cx'), $(circle).attr('cy')],
              target: [$(list[i + 1]).attr('cx'), $(list[i + 1]).attr('cy')]
            };
          } catch (_error) {

          }
        });
        lines.pop();
        return this.chart.selectAll('.line').data(lines).enter().append('line').attr('x1', function(d) {
          return d.source[0];
        }).attr('y1', function(d) {
          return d.source[1];
        }).attr('x2', function(d) {
          return d.target[0];
        }).attr('y2', function(d) {
          return d.target[1];
        }).style('stroke', color);
      };

      return Garden;

    })(Backbone.View);
  });

}).call(this);

/*
//@ sourceMappingURL=main.js.map
*/