define (require) ->
    $ = require 'jquery'
    _ = require 'underscore'
    Backbone = require 'backbone'

    SoilTextureCollection = require 'SoilTextureCollection'


    class SoilTextureView extends Backbone.View

        selected: null

        events:
            'change select[name="soilTexture"]': 'change'

        initialize: (@options) ->

            @collection = new SoilTextureCollection()

            @collection.on 'reset', =>
                @render()

            @collection.fetch()

        render: ->

            optionTemplate = '<option value="<%= id %>"><%= name %></option>'

            @collection.each (model) =>

              option = _.template optionTemplate,
                  id: model.id
                  name: model.get 'name'

              @$el.find('select[name="soilTexture"]').append option

        change: (e) ->

            selectedId = $(e.currentTarget).val()

            selectedTexture = @collection.get selectedId

            @$el.find('[name="clayContent"]').val selectedTexture.get('avgClay')

            @$el.find('[name="siltContent"]').val selectedTexture.get('avgSilt')

            @$el.find('[name="sandContent"]').val selectedTexture.get('avgSand')

        updateSelected: () ->













