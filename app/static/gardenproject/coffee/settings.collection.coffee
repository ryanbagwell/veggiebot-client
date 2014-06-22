define (require) ->
    $ = require 'jquery'
    _ = require 'underscore'
    Backbone = require 'backbone'

    beforeSend = (xhr) ->
        xhr.setRequestHeader 'X-Parse-Application-Id',
            '9NGEXKBz0x7p5SVPPXMbvMqDymXN5qCf387GpOE2'
        xhr.setRequestHeader 'X-Parse-REST-API-Key',
            'SDWvYNwDCPB6ImJ6eo1L28Nr5fzrA4fQysIdjz4Y'


    class SettingsModel extends Backbone.Model
        
        defaults:
            pumpStatus: 'auto'
            autoThreshold: 50

        idAttribute: 'objectId'

        url: ->
            'https://api.parse.com/1/classes/Settings/' + @get 'objectId'

        sync: (method, model, options) ->

            options.beforeSend = beforeSend

            super(method, model, options)



    class SettingsCollection extends Backbone.Collection

        model: SettingsModel

        initialize: (options) ->

            defaults = 
                limit: 1

            @options = _.extend defaults, options

        url: 'https://api.parse.com/1/classes/Settings'

        parse: (data, xhr) ->
            
            data.results

        sync: (method, collection, options) ->

            options.beforeSend = beforeSend
            
            super(method, collection, options)

        fetch: (options) ->

            defaults = 
                data:
                    limit: 1
                    order: '-updatedAt'
                reset: true

            super(defaults)


