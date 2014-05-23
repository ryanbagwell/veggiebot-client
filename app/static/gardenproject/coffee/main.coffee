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

        growToSize: '25px'
        dotSize: '5px'

        initialize: (options) ->
            @options = options

            _.bindAll @, 'drawChart', 'timeTickFormatter'

            @gardenData = new GardenData()

            @gardenData.on 'reset', @drawChart

            @gardenData.fetch
                reset: true

            $(window).on 'resize', =>
                @destroy()
                @drawChart()

        drawChart: ->


            times = @gardenData.map (model) ->
                    time = model.get('time')
                    moment.utc(time).unix()

            moistures = @gardenData.map (model) -> model.get 'moistureLevel'

            timeScale = d3.scale.linear()
                .domain([d3.min(times), d3.max(times)])
                .range([0, $(window).width()-100])

            moistureScale = d3.scale.linear().domain([500, 1000]).range([0, 500])


            @chart = d3.select("#chart")
                .append('svg')

            @chart.attr('width', ($(window).width() - 100) + 'px')
                .attr('height', '500')

            @chart.text("Garden Soil Moisture").select('#chart')

            # Filter out levels that are outside of our scope
            data = @gardenData.filter( (model) ->
                        (500 < model.get('moistureLevel') < 1000)
                ).map (model) ->
                    {moisture: model.get('moistureLevel'), time: moment.utc(model.get 'time').unix()}

            # Calculate how many data points to display
            # depending on our width
            maxPoints = _.min([Math.ceil($(window).width() * 100 / 1500), 100])

            if maxPoints < 100

                data = data.filter (model, i) ->
                    (i % Math.ceil(100/maxPoints))

            zones = @chart.append('g').attr(
                class: 'zones'
                width: '100%'
            )

            dangerZone = zones.append('rect')
                .attr
                    class: 'death-valley'
                    x: 0
                    y: 400
                    width: @chart.attr 'width'
                    height: 100
                    fill: 'red'
                    opacity: .5

            cautionZone = zones.append('rect')
                .attr
                    class: 'caution'
                    x: 0
                    y: 200
                    width: '100%'
                    height: 200
                    fill: '#e3b102'
                    opacity: .5

            okZone = zones.append('rect')
                .attr
                    class: 'ok'
                    x: 0
                    y: 0
                    width: '100%'
                    height: 200
                    fill: 'green'
                    opacity: .5


            circleContainer = @chart.selectAll('circle.node')
                .data(data)
                .enter().append('g')
                .attr('class', 'circle-container')

            circleContainer.append('svg:circle')
                .attr('cx', (d) ->
                    timeScale(d.time))
                .attr('cy', (d) -> moistureScale(d.moisture) )
                .attr('r', @dotSize)
                .attr('fill', 'black').on('mouseover', (data, i) ->
                    d3.select(@parentNode).attr('class', 'node text-visible')
                    d3.select(@).transition().attr 'r':'25px'
                ).on('mouseout', (data, i) ->
                    d3.select(@parentNode).attr('class', 'node')
                    d3.select(@).transition().attr 'r', '5px'
                )

            circleContainer.append('text')
                .attr('x', (d) -> timeScale(d.time))
                .attr('y', (d) -> moistureScale(d.moisture))
                .text((data, i) ->
                    data.moisture
                ).attr("text-anchor", "middle")
                .attr('dy', '35px')
                .attr('class', 'value-label')

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


            timeAxis = d3.svg.axis().scale(timeScale).orient('bottom').ticks(Math.floor($(window).width() / 100)).tickFormat(@timeTickFormatter)

            timeAxisGroup = @chart.append('g').attr(
                'class':'axis x'
                'transform': 'translate(0, 500)'
            ).call(timeAxis)

            moistureAxis = d3.svg.axis().scale(moistureScale).orient('left').ticks(10).tickFormat (num, i) -> num

            moistureAxisGroup = @chart.append('g').attr(
                "transform":"translate(0,0)"
                'class':'axis y'
            ).call(moistureAxis)

            moistureAxisGroup.append('text')
                .attr('class', 'label y')
                .attr('text-anchor', 'end')
                .attr("y", 6)
                .attr('dy', '.75em')
                .attr('transform', 'rotate(-90)')
                .text('Saturated')





        timeTickFormatter: (timestamp)->
            moment.unix(timestamp).tz('America/Chicago').format('ddd, hA')

        growDot: (data, i) ->
            node = d3.selectAll('g.node')[0][i]
            d3.select(node).select('circle').transition().attr 'r', '25px'

        shrinkDot: (data, i) ->
            node = d3.selectAll('g.node')[0][i]
            d3.select(node).select('circle').transition().attr 'r', @dotSize

        destroy: ->
            $('svg').remove()
            @chart = null






