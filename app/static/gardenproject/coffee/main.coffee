define (require) ->
    $ = require 'jquery'
    _ = require 'underscore'
    Backbone = require 'backbone'
    d3 = require 'd3'
    GardenData = require 'gardenData'
    moment = require 'moment'
    require 'moment-timezone'
    require 'tzdata'


    class Garden extends Backbone.View

        initialize: (options) ->
            @options = options

            _.bindAll @, 'drawChart', 'timeTickFormatter'

            @gardenData = new GardenData()

            @gardenData.on 'reset', @drawChart

            @gardenData.fetch
                reset: true

        drawChart: ->

            times = @gardenData.map (model) ->
                    time = model.get('time')
                    moment.utc(time).unix()

            moistures = @gardenData.map (model) -> model.get 'moistureLevel'

            timeScale = d3.scale.linear()
                .domain([d3.min(times), d3.max(times)])
                .range([0, 1000])

            moistureScale = d3.scale.linear()
                .domain([500, 1023])
                .range([0, 500])

            @chart = d3.select("#chart")
                .append('svg')

            @chart.attr('width', '100%')
                .attr('height', '500')

            @chart.text("Garden Soil Moisture").select('#chart')

            # Filter out levels that are outside of our scope
            data = @gardenData.filter( (model) ->
                        (0 < model.get('moistureLevel') < 1023)
                ).map (model) ->
                    {moisture: model.get('moistureLevel'), time: moment.utc(model.get 'time').unix()}

            node = @chart.selectAll('circle.node')
                .data(data)
                .enter().append('g')
                .attr('class', 'node')

            node.append('svg:circle')
                .attr('cx', (d) ->
                    timeScale(d.time))
                .attr('cy', (d) -> moistureScale(d.moisture) )
                .attr('r', '2px')
                .attr('fill', 'black')

            @chart.selectAll('circle.nodes')
                .data(data)
                .enter()
                .append('svg.circle')
                .attr('cx', (d) -> timeScale(d.time))
                .attr('cy', (d) -> moistureScale(d.moisture) )

            lines = _.map @chart.selectAll('circle')[0], (circle, i, list) ->
                try
                    return {
                        source: [$(circle).attr('cx'), $(circle).attr('cy')]
                        target: [$(list[i+1]).attr('cx'), $(list[i+1]).attr('cy')]
                    }
                catch

            lines.pop()

            @chart.selectAll('.line')
                .data(lines)
                .enter()
                .append('line')
                .attr('x1', (d) -> d.source[0])
                .attr('y1', (d) -> d.source[1])
                .attr('x2', (d) -> d.target[0])
                .attr('y2', (d) -> d.target[1])
                .style('stroke', 'black')


            timeAxis = d3.svg.axis().scale(timeScale).orient('bottom').tickFormat(@timeTickFormatter)

            timeAxisGroup = @chart.append('g').attr(
                'class':'axis x'
                'transform': 'translate(0, 500)'
            ).call(timeAxis)

            moistureAxis = d3.svg.axis().scale(moistureScale).orient('left').ticks(10)

            moistureAxisGroup = @chart.append('g').attr(
                "transform":"translate(0,0)"
                'class':'axis y'
            ).call(moistureAxis)


        timeTickFormatter: (timestamp)->
            moment.unix(timestamp).tz('America/Chicago').format('ddd, hA')






