(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var $, Backbone, GardenChart, Main, _, _ref;
    $ = require('jquery');
    _ = require('underscore');
    Backbone = require('backbone');
    GardenChart = require('gardenChart');
    return Main = (function(_super) {
      __extends(Main, _super);

      function Main() {
        _ref = Main.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Main.prototype.initialize = function(options) {};

      return Main;

    })(Backbone.View);
  });

}).call(this);

/*
//@ sourceMappingURL=main.js.map
*/