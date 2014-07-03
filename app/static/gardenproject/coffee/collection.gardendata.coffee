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
                query:
                    limit: [200]
                    #greaterThan: ['createdAt', new Date(moment().subtract('days', 3))]
                    descending: ['createdAt']
                    greaterThan: ['temperature', 0]

            @options = _.extend defaults, options

            @query = new Parse.Query SoilDataModel

            for k, v of @options.query

                try
                    @query[k].apply(@query, v)
                catch e

            super(options)

        comparator: (m1, m2) ->

            t1 = moment(m1.createdAt).unix()

            t2 = moment(m2.createdAt).unix()

            return if t1 > t2 then 1 else -1





