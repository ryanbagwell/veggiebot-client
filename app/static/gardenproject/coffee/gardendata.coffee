define (require) ->
    $ = require 'jquery'
    _ = require 'underscore'
    Backbone = require 'backbone'


    class DataCollection extends Backbone.Collection

        url: ->

            return 'static/gardenproject/test/garden-data.json' if window.location.host is 'localhost'

            'http://192.168.10.16/garden-data.json'


