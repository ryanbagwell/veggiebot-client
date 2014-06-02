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
                #console.log 'reset'
                nv.addGraph(@drawChart)

            @gardenData.fetch
                reset: true
                beforeSend: (xhr) ->
                    xhr.setRequestHeader 'X-ApiKey',
                        'F0MAdNgqeQWq47ukRCBMnQvL9M9n1bEIRGOodOw35ElnqPjd'



        drawChart: ->

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

            chart.xAxis.tickFormat( (d, i) ->
                if i
                    interval = (d3.max(times) - d3.min(times)) / 10
                    timeIntervals = _.range d3.min(times), d3.max(times), interval
                    t = timeIntervals[i]
                else
                    t = times[d]

                moment.unix(t).tz('America/Chicago').format('ddd, hA')
            ).showMaxMin(false);

            ## Temperature
            chart.y1Axis.tickFormat (d, i) ->
                d+"°F"

            ## Moisture
            chart.y2Axis.tickFormat (d, i) ->
                pct = Math.round((d / 1023) * 100)
                pct + '%'


            #chart.bars.forceY([0]).padData(false)

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
                    x: moment.utc(model.get 'time').unix()
                    y: model.get 'SoilMoisture'
            ,
                bar: true,
                key: 'Soil Temperature'
                originalKey: 'Soil Temperature'
                values: @gardenData.map (model) ->
                    x: moment.utc(model.get 'time').unix()
                    y: model.get 'SoilTemperature'
            ]

            dataSets










