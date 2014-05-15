define (require) ->
    $ = require 'jquery'
    _ = require 'underscore'
    Backbone = require 'backbone'


    class DataCollection extends Backbone.Collection

        url: ->

            return 'static/gardenproject/test/garden-data.json' if window.location.host is 'localhost'

            'http://garden.ryanbagwell.com/static/gardenproject/data/garden-data.json'


