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
                datastreams: 'SoilMoisture,SoilTemperature'
                start: moment.utc().subtract('days', 2).format()
                end: moment.utc().format()
                interval: 1800

            @options = _.extend defaults, options

        url: ->
            _.sprintf 'https://api.xively.com/v2/feeds/342218851?datastreams=%(datastreams)s&start=%(start)s&interval=%(interval)s&interval_type=discrete', @options

        parse: (data, xhr) ->

            combined = {}

            _.each data.datastreams, (stream) ->
                name = _.camelize(stream.id)

                _.each stream.datapoints, (point) ->
                    combined[point.at] = {} unless _.has(combined, point.at)
                    combined[point.at][name] = point.value
                    combined[point.at]['time'] = point.at

            _.values combined


