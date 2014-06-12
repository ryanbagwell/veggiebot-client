define (require) ->
    $ = require 'jquery'
    _ = require 'underscore'
    _.str = require 'underscore.string'
    _.mixin _.str.exports()
    Backbone = require 'backbone'
    moment = require 'moment'
    require 'moment-timezone'
    require 'tzdata'


    class DataCollection extends Backbone.Collection

        initialize: (options) ->

            defaults = 
                limit: 200
                date: moment().subtract('days', 3).toISOString()

            @options = _.extend defaults, options

        url: ->
            _.sprintf 'https://api.parse.com/1/classes/SoilData?limit=%(limit)s&order=createdAt&where={"updatedAt":{"$gt":{"__type":"Date", "iso":"%(date)s"}}}', @options
          

        parse: (data, xhr) ->
            
            results = []

            _.map data.results, (obj) ->
               

                if obj.moistureLevel > 100
                    obj.moistureLevel = obj.moistureLevel / 1023 * 100

                obj



        fetch: (options) ->
            defaults = 
                reset: true
                beforeSend: (xhr) ->
                    xhr.setRequestHeader 'X-Parse-Application-Id',
                        '9NGEXKBz0x7p5SVPPXMbvMqDymXN5qCf387GpOE2'
                    xhr.setRequestHeader 'X-Parse-REST-API-Key',
                        'SDWvYNwDCPB6ImJ6eo1L28Nr5fzrA4fQysIdjz4Y'
            super(defaults)


