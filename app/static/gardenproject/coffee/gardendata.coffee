define (require) ->
    $ = require 'jquery'
    _ = require 'underscore'
    _.str = require 'underscore.string'
    _.mixin _.str.exports()
    Backbone = require 'backbone'
    moment = require 'moment'
    require 'moment-timezone'
    require 'tzdata'

    Parse = require 'Parse'


    class SoilDataModel extends Parse.Object

        className: "SoilData"


    class DataCollection extends Parse.Collection

        model: SoilDataModel

        initialize: (options) ->

            defaults = 
                limit: 200
                date: moment().subtract('days', 3)

            @options = _.extend defaults, options

            @query = new Parse.Query SoilDataModel
            @query.limit @options.limit
            @query.ascending 'createdAt'
            @query.greaterThan 'createdAt', new Date(@options.date)

            super(options)

