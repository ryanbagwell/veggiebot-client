define (require) ->
    $ = require 'jquery'
    _ = require 'underscore'
    Backbone = require 'backbone'
    Parse = require 'Parse'


    class SettingsModel extends Parse.Object
        
        defaults:
            pumpStatus: 'auto'
            autoThreshold: 50

        className: "Settings"


    class SettingsCollection extends Parse.Collection

        model: SettingsModel

        initialize: (options) ->

            defaults = 
                limit: 1

            @options = _.extend defaults, options

        fetch: (options) ->

            defaults = 
                data:
                    limit: 1
                    order: '-updatedAt'
                reset: true

            super(defaults)


