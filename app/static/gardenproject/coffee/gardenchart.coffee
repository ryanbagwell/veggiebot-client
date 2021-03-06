define (require) ->
    $ = require 'jquery'
    _ = require 'underscore'
    Backbone = require 'backbone'
    d3 = require 'd3'
    nv = require 'nvd3'
    GardenData = require 'GardenData'
    moment = require 'moment'
    require 'moment-timezone'
    require 'tzdata'


    class Garden extends Backbone.View

        growToSize: '25px'
        dotSize: '5px'

        sensor1Color: 'blue'
        sensor2Color: '#407740'

        tagName: 'svg'

        margins:
            top: 30
            right: 60
            bottom: 50
            left: 70

        initialize: (options) ->
            @options = options

            _.bindAll @, 'drawChart', 'getData'

            super(options)

            @$el.appendTo('.chart')

            @gardenData = new GardenData()

            @gardenData.on 'reset', =>
                @drawChart()

            @gardenData.fetch()


        drawChart: ->

            __ = @

            data = @getData()

            times = @gardenData.map (model) ->
                t = model.get 'time'
                moment.utc(t).unix()

            chart = nv.models.linePlusBarChart()
                .margin(@margins)
                .x( (d, i) -> i)
                .color(
                    d3.scale.category10()
                        .domain([d3.min(times), d3.max(times)])
                        .range()
                )

            formatter = (d, i) =>
                i = if d then d else i
                m = @gardenData.at(i)

                if moment(m.createdAt).format("mm") is '00'
                    formatStr = "ddd (M/D), h a"
                else
                    formatStr = "ddd (M/D), h:mm a"

                moment(m.createdAt).tz('America/Chicago').format(formatStr)

            chart.xAxis.tickFormat(formatter).showMaxMin(false);

            ## Temperature
            chart.y1Axis.tickFormat( (d, i) ->
                parseInt(d)+"°F"
            ).showMaxMin(false)

            ## Moisture
            chart.y2Axis.tickFormat( (d, i) ->
                Math.round(d) + '%'
            ).showMaxMin(false)

            d3.select(@el)
                .datum(data)
                .transition().duration(500).call(chart)

            nv.utils.windowResize(chart.update)

            chart.dispatch.on 'stateChange', (e) ->
                nv.log('New State:', JSON.stringify(e))

            chart

        getData: ->

            dataSets = [
                bar: false,
                key: 'Soil Moisture'
                originalKey: 'Soil Moisture'
                values: @gardenData.map (model) ->
                    x: moment.utc(model.get 'createdAt').unix()
                    y: model.get 'moistureLevel'
            ,
                bar: true,
                key: 'Soil Temperature'
                originalKey: 'Soil Temperature'
                values: @gardenData.map (model) ->
                    x: moment.utc(model.get 'createdAt').unix()
                    y: model.get 'temperature'
            ]

            dataSets

        remove: ->
            @$el.children().remove()
