(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var $, Backbone, DataCollection, Parse, SoilDataModel, moment, _, _ref, _ref1;
    $ = require('jquery');
    _ = require('underscore');
    _.str = require('underscore.string');
    _.mixin(_.str.exports());
    Backbone = require('backbone');
    moment = require('moment');
    require('moment-timezone');
    require('tzdata');
    Parse = require('Parse');
    SoilDataModel = (function(_super) {
      __extends(SoilDataModel, _super);

      function SoilDataModel() {
        _ref = SoilDataModel.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      SoilDataModel.prototype.className = "SoilData";

      return SoilDataModel;

    })(Parse.Object);
    return DataCollection = (function(_super) {
      __extends(DataCollection, _super);

      function DataCollection() {
        _ref1 = DataCollection.__super__.constructor.apply(this, arguments);
        return _ref1;
      }

      DataCollection.prototype.model = SoilDataModel;

      DataCollection.prototype.initialize = function(options) {
        var defaults, e, k, v, _ref2;
        defaults = {
          query: {
            limit: [200],
            descending: ['createdAt'],
            greaterThan: ['temperature', 0]
          }
        };
        this.options = _.extend(defaults, options);
        this.query = new Parse.Query(SoilDataModel);
        _ref2 = this.options.query;
        for (k in _ref2) {
          v = _ref2[k];
          try {
            this.query[k].apply(this.query, v);
          } catch (_error) {
            e = _error;
          }
        }
        return DataCollection.__super__.initialize.call(this, options);
      };

      DataCollection.prototype.comparator = function(m1, m2) {
        var t1, t2;
        t1 = moment(m1.createdAt).unix();
        t2 = moment(m2.createdAt).unix();
        if (t1 > t2) {
          return 1;
        } else {
          return -1;
        }
      };

      return DataCollection;

    })(Parse.Collection);
  });

}).call(this);

/*
//@ sourceMappingURL=gardendata.js.map
*/