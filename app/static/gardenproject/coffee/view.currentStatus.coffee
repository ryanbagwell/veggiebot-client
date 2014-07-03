define (require) ->
    $ = require 'jquery'
    _ = require 'underscore'
    Backbone = require 'backbone'

    class CurrentStatusList extends Backbone.View

        tagName: 'ul'

        template: [
            '<li class="item-content">',
            '<div class="item-inner">',
            '<div class="item-title"><%= key %></div>',
            '<div class="item-after"><%= value %></div>'
            '</div>',
            '</li>'
        ]

        initialize: (options) ->
            @options = options

            @render()

        render: ->

            template = @template.join ''

            params = [
                    key: 'Moisture Level'
                    value: @options.collection.last().get('moistureLevel').toFixed(2) + '%'
                ,
                    key: 'Soil Temperature'
                    value: @options.collection.last().get('temperature').toFixed(0) + '&deg;F'
                ,
                    key: 'Moisture Reading'
                    value: @options.collection.last().get('moistureReading').toFixed(0)
                ,
                    key: 'Moisture Volts'
                    value: @options.collection.last().get('moistureVolts').toFixed(2)
                ,
                    key: 'Resistance (&#8486;)'
                    value: @options.collection.last().get('moistureOhms').toFixed(2)
                ,
                    key: 'Resistance (k&#8486;)'
                    value: @options.collection.last().get('moistureKOhms').toFixed(2)
                ,
                    key: 'Last Updated'
                    value: (=>
                        t = @options.collection.last().createdAt
                        moment(t).tz('America/Chicago').format('ddd (M/D), h:mm a')
                    )()
            ]

            _.each params, (status) =>

                @$el.append _.template template, status

            @$el.appendTo @options.parentNode

        remove: ->
            @$el.remove()

