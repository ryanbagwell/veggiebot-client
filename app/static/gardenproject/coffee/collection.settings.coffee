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

        initialize: (@options) ->

            defaults =
                query:
                    equalTo: ['user', Parse.User.current()]

            @options = _.extend defaults, options

            @query = new Parse.Query SettingsModel

            for k, v of @options.query

                try
                    @query[k].apply(@query, v)
                catch e

            super(@options)







