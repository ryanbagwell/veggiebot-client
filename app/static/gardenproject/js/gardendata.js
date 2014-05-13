(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var $, Backbone, DataCollection, _, _ref;
    $ = require('jquery');
    _ = require('underscore');
    Backbone = require('backbone');
    return DataCollection = (function(_super) {
      __extends(DataCollection, _super);

      function DataCollection() {
        _ref = DataCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      DataCollection.prototype.url = function() {
        if (window.location.host === 'localhost') {
          return 'static/gardenproject/test/garden-data.json';
        }
        return 'http://192.168.10.16/garden-data.json';
      };

      return DataCollection;

    })(Backbone.Collection);
  });

}).call(this);

/*
//@ sourceMappingURL=gardendata.js.map
*/