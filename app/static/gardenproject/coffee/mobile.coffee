define (require) ->
	$ = require 'jquery'
	require 'jquery.picplus'
	Framework7 = require 'Framework7'
	_ = require 'underscore'
	Backbone = require 'backbone'
	GardenChart = require 'gardenChart'

	GardenData = require 'gardenData'
	SettingsData = require 'settingsData'

	$$ = Framework7.$


	class MobileGardenChart extends GardenChart
		
		margins:
            top: 30
            right: 30
            bottom: 50
            left: 30


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
			]

			_.each params, (status) =>

				@$el.append _.template template, status

			@$el.appendTo @options.parentNode



	class MobileApp extends Framework7

		constructor: (options) ->
			@options = options

			$('[data-picplus]').picplus()

			@settings = new SettingsData()

			@settings.on 'reset', =>
				@setSettingsView()

			@settings.fetch()


			@gardenData = new GardenData()
                
			@gardenData.on 'reset', =>
				@setStatusView()
					
			@gardenData.fetch()

			super(options)
			
		setStatusView: ->

			@statusView = @addView @options.views.statusView

			currentStatusList = new CurrentStatusList
				parentNode: @statusView.selector + ' .status-list'
				collection: @gardenData

			@chart = new MobileGardenChart
				el: $(@statusView.selector).find('.chart svg')

			
		setSettingsView: ->

			@settings.first()

			$$('[name="pumpStatus"]').val @settings.first().get 'pumpStatus'
			$$('[name="autoThreshold"]').val @settings.first().get 'autoThreshold'

			@settingsView = @addView @options.views.settingsView


			$$('[name="pumpStatus"]').on 'change', (e) =>
				@settings.first().save
					pumpStatus: $$(e.currentTarget).val()

			$$('[name="autoThreshold"]').on 'change', (e) =>
				@settings.first().save
					autoThreshold: parseInt $$(e.currentTarget).val()
				









			



		

			



