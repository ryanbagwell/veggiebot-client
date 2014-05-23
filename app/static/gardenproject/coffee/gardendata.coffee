define (require) ->
    $ = require 'jquery'
    _ = require 'underscore'
    Backbone = require 'backbone'


    class DataCollection extends Backbone.Collection

        url: 'http://garden.ryanbagwell.com/static/gardenproject/data/garden-data.json'





