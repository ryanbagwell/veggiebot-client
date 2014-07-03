define (require) ->
    $ = require 'jquery'
    _ = require 'underscore'
    Backbone = require 'backbone'
    UserSettings = require 'UserSettings'

    SoilTextureView = require 'SoilTextureView'
    SoilTextureCollection = require 'SoilTextureCollection'

    class SettingsView extends Backbone.View

        events:
            'change [name="pumpStatus"]': 'save'
            'change [name="autoThreshold"]': 'save'
            'change [name="soilTexture"]': 'save'

        initialize: ->
            super()

            @settings = new UserSettings()

            @settings.on 'reset', =>

                if not @settings.first()
                    @settings.create
                        user: Parse.User.current()

                    @settings.first().save()

                @settings.fetched = true

                @render()

            @settings.fetch
                reset: true


            @soilTexture = new SoilTextureCollection()

            @soilTexture.on 'reset', =>
                @soilTexture.fetched = true
                @render()

            @soilTexture.fetch
                reset: true

        render: ->

            return unless @settings.fetched and @soilTexture.fetched

            @settings = @settings.first()

            @$el.find('[name="pumpStatus"]').val @settings.get 'pumpStatus'

            @$el.find('[name="autoThreshold"]').val @settings.get 'autoThreshold'

            @soilTextureView = new SoilTextureView
                el: @$el.find('.list-block.soil-textures')
                initial: @settings.get 'soilTexture'
                collection: @soilTexture

            @soilTextureView.on 'changed', (selectedTexture) =>

                @$el.find('[name="autoThreshold"]').val selectedTexture.get('wateringPoint')

            @$el.find('[name="autoThreshold"]').on 'change', (e) =>
                @updateSliderValue(e)

        save: (e) ->

            @settings.save
                pumpStatus: @$el.find('[name="pumpStatus"]').val()
                autoThreshold: parseInt @$el.find('[name="autoThreshold"]').val()
                soilTexture: @soilTexture.get @$el.find('[name="soilTexture"]').val()

        updateSliderValue: (e) ->

            $slider = @$el.find('[name="autoThreshold"]')
            $slider.parents('.item-input').siblings().find('span').text $slider.val()+'%'









