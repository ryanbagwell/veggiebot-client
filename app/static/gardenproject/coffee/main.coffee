define (require) ->
    $ = require 'jquery'
    _ = require 'underscore'
    Backbone = require 'backbone'
    d3 = require 'd3'
    nv = require 'nvd3'
    GardenData = require 'gardenData'
    moment = require 'moment'
    require 'moment-timezone'
    require 'tzdata'


    class Garden extends Backbone.View

        growToSize: '25px'
        dotSize: '5px'

        sensor1Color: 'blue'
        sensor2Color: '#407740'

        initialize: (options) ->
            @options = options

            _.bindAll @, 'drawChart', 'getData'

            @gardenData = new GardenData()
                
            @gardenData.on 'reset', =>
                nv.addGraph(@drawChart)

            @gardenData.fetch()


        drawChart: ->

            __ = @

            data = @getData()

            times = @gardenData.map (model) ->
                t = model.get 'time'
                moment.utc(t).unix()

            chart = nv.models.linePlusBarChart()
                .margin(
                    top: 30
                    right: 60
                    bottom: 50
                    left: 70
                )
                .x( (d, i) -> i)
                .color(
                    d3.scale.category10()
                        .domain([d3.min(times), d3.max(times)])
                        .range()
                )

            formatter = _.bind (d, i) ->
                i = if i then i else d
                m = @gardenData.at(i)
                t = m.get('createdAt')
                moment(t).tz('America/Chicago').format("ddd, hA")
            , @ 

            chart.xAxis.tickFormat(formatter).showMaxMin(false);

            ## Temperature
            chart.y1Axis.tickFormat( (d, i) ->
                parseInt(d)+"°F"
            ).showMaxMin(false)

            ## Moisture
            chart.y2Axis.tickFormat( (d, i) ->
                pct = Math.round((d / 1023) * 100)
                pct + '%'
            ).showMaxMin(false)



            d3.select('#chart1 svg')
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
            ,

                bar: false,
                key: 'Moisture Normalized'
                originalKey: 'Moisture Normalized'
                values: @gardenData.map (model) ->
                    n = model.get 'normalizedMoisture' 
                    x: moment.utc(model.get 'createdAt').unix()
                    y: if n then n else 0
            ]

            dataSets










