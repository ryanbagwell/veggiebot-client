define (require) ->
	$ = require 'jquery'
	require 'jquery.picplus'
	Framework7 = require 'Framework7'
	_ = require 'underscore'
	Backbone = require 'backbone'
	GardenChart = require 'gardenChart'
	GardenData = require 'gardenData'

	#Export selectors engine
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

			@gardenData = new GardenData()
                
			@gardenData.on 'reset', =>
				@render(@options.parentNode)
				
				
			@gardenData.fetch()


		render: ->

			template = @template.join ''

			params = [
					key: 'Moisture Level'
					value: @gardenData.last().get('moistureLevel').toFixed(2) + '%'
				,
					key: 'Soil Temperature'
					value: @gardenData.last().get('temperature').toFixed(0) + '&deg;F'
				,
					key: 'Moisture Reading'
					value: @gardenData.last().get('moistureReading').toFixed(0)
				,
					key: 'Moisture Volts'
					value: @gardenData.last().get('moistureVolts').toFixed(2)
				,
					key: 'Resistance (&#8486;)'
					value: @gardenData.last().get('moistureOhms').toFixed(2)
				,
					key: 'Resistance (k&#8486;)'
					value: @gardenData.last().get('moistureKOhms').toFixed(2)
			]

			console.log params

			_.each params, (status) =>

				@$el.append _.template template, status

			@$el.appendTo @options.parentNode



	class MobileApp extends Framework7

		constructor: (options) ->
			@options = options

			$('[data-picplus]').picplus()
			
			super(options)



			@statusView = @addView @options.views.statusView

			currentStatusList = new CurrentStatusList
				parentNode: @statusView.selector + ' .status-list'

			@chart = new MobileGardenChart
				el: $(@statusView.selector).find('.chart svg')
				
			@settingsView = @addView @options.views.settingsView

			



		

			



