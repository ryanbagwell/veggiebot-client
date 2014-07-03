define (require) ->
    $ = require 'jquery'
    _ = require 'underscore'
    Backbone = require 'backbone'


    class SoilTextureView extends Backbone.View

        selected: null

        events:
            'change select[name="soilTexture"]': 'updateSoilComposition'

        initialize: (@options) ->
            @render()

        render: ->

            optionTemplate = '<option value="<%= id %>"><%= name %></option>'

            @options.collection.each (model) =>

                option = _.template optionTemplate,
                    id: model.id
                    name: model.get 'name'

                $option = $(option)

                if model.id is @options.initial.id
                    $option.attr 'selected', ''

                $option.appendTo('select[name="soilTexture"]')


            @updateSoilComposition()


        updateSoilComposition: (e) ->

            selectedId = $('select[name="soilTexture"]').val()

            @selectedTexture = @options.collection.get selectedId

            @$el.find('[name="clayContent"]').val @selectedTexture.get('avgClay')

            @$el.find('[name="siltContent"]').val @selectedTexture.get('avgSilt')

            @$el.find('[name="sandContent"]').val @selectedTexture.get('avgSand')

            @trigger 'changed', @selectedTexture















