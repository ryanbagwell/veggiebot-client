(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var $, Backbone, DataCollection, moment, _, _ref;
    $ = require('jquery');
    _ = require('underscore');
    _.str = require('underscore.string');
    _.mixin(_.str.exports());
    Backbone = require('backbone');
    moment = require('moment');
    require('moment-timezone');
    require('tzdata');
    return DataCollection = (function(_super) {
      __extends(DataCollection, _super);

      function DataCollection() {
        _ref = DataCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      DataCollection.prototype.initialize = function(options) {
        var defaults;
        defaults = {
          datastreams: 'SoilMoisture,SoilTemperature',
          start: moment.utc().subtract('days', 3).format(),
          end: moment.utc().format(),
          interval: 1800
        };
        return this.options = _.extend(defaults, options);
      };

      DataCollection.prototype.url = function() {
        return _.sprintf('https://api.xively.com/v2/feeds/342218851?datastreams=%(datastreams)s&start=%(start)s&end=%(end)s&%(interval)s', this.options);
      };

      DataCollection.prototype.parse = function(data, xhr) {
        var combined;
        console.log(data.datastreams);
        combined = {};
        _.each(data.datastreams, function(stream) {
          var name;
          name = _.camelize(stream.id);
          console.log(name);
          return _.each(stream.datapoints, function(point) {
            if (!_.has(combined, point.at)) {
              combined[point.at] = {};
            }
            combined[point.at][name] = point.value;
            return combined[point.at]['time'] = point.at;
          });
        });
        return _.values(combined);
      };

      return DataCollection;

    })(Backbone.Collection);
  });

}).call(this);

/*
//@ sourceMappingURL=gardendata.js.map
*/