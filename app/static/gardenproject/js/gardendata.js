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
          limit: 200,
          date: moment().subtract('days', 3).toISOString()
        };
        return this.options = _.extend(defaults, options);
      };

      DataCollection.prototype.url = function() {
        return _.sprintf('https://api.parse.com/1/classes/SoilData?limit=%(limit)s&order=createdAt&where={"updatedAt":{"$gt":{"__type":"Date", "iso":"%(date)s"}}}', this.options);
      };

      DataCollection.prototype.parse = function(data, xhr) {
        var results;
        results = [];
        return _.map(data.results, function(obj) {
          if (obj.moistureLevel > 100) {
            obj.moistureLevel = obj.moistureLevel / 1023 * 100;
          }
          return obj;
        });
      };

      DataCollection.prototype.fetch = function(options) {
        var defaults;
        defaults = {
          reset: true,
          beforeSend: function(xhr) {
            xhr.setRequestHeader('X-Parse-Application-Id', '9NGEXKBz0x7p5SVPPXMbvMqDymXN5qCf387GpOE2');
            return xhr.setRequestHeader('X-Parse-REST-API-Key', 'SDWvYNwDCPB6ImJ6eo1L28Nr5fzrA4fQysIdjz4Y');
          }
        };
        options = _.extend(defaults, options);
        return DataCollection.__super__.fetch.call(this, options);
      };

      return DataCollection;

    })(Backbone.Collection);
  });

}).call(this);

/*
//@ sourceMappingURL=gardendata.js.map
*/