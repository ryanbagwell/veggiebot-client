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
        var defaults;
        defaults = {
          limit: 200,
          date: moment().subtract('days', 3)
        };
        this.options = _.extend(defaults, options);
        this.query = new Parse.Query(SoilDataModel);
        this.query.limit(this.options.limit);
        this.query.ascending('createdAt');
        this.query.greaterThan('createdAt', new Date(this.options.date));
        return DataCollection.__super__.initialize.call(this, options);
      };

      return DataCollection;

    })(Parse.Collection);
  });

}).call(this);

/*
//@ sourceMappingURL=gardendata.js.map
*/