define (require) ->
	$ = require 'jquery'
	require 'jquery.picplus'
	Framework7 = require 'Framework7'
	_ = require 'underscore'
	Backbone = require 'backbone'
	GardenChart = require 'gardenChart'

	moment = require 'moment'
	require 'moment-timezone'
	require 'tzdata'

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
				,
					key: 'Last Updated'
					value: (=>
						t = @options.collection.last().get('createdAt')
						moment(t).tz('America/Chicago').format('ddd, h:mm a')
					)()
			]

			_.each params, (status) =>

				@$el.append _.template template, status

			@$el.appendTo @options.parentNode

		remove: ->
			@$el.remove()



	class MobileApp extends Framework7

		constructor: (options) ->
			@options = options

			$('[data-picplus]').picplus()

			@settings = new SettingsData()

			@settings.on 'reset', =>
				@setSettingsView()

			@gardenData = new GardenData()
                
			@gardenData.on 'reset', =>
				@setStatusView()

			super(options)

			@settings.fetch()

			@gardenData.fetch()

			@statusView = @addView @options.views.statusView

			@settingsView = @addView @options.views.settingsView

			$$('.pull-to-refresh-content').on 'refresh', =>
				@gardenData.fetch()
			
		setStatusView: ->

			if @currentStatusList
				@currentStatusList.remove()

			@currentStatusList = new CurrentStatusList
				parentNode: @statusView.selector + ' .status-list'
				collection: @gardenData

			if @chart
				@chart.remove()

			@chart = new MobileGardenChart
				el: '.chart svg'
				collection: @gardenData

			@refreshDone()
			
		setSettingsView: ->

			@settings.first()

			$$('[name="pumpStatus"]').val @settings.first().get 'pumpStatus'
			$$('[name="autoThreshold"]').val @settings.first().get 'autoThreshold'

			$$('[name="pumpStatus"]').on 'change', (e) =>
				@settings.first().save
					pumpStatus: $$(e.currentTarget).val()

			$$('[name="autoThreshold"]').on 'change', (e) =>
				@settings.first().save
					autoThreshold: parseInt $$(e.currentTarget).val()

		refreshDone: ->

			_.delay (=> @pullToRefreshDone()), 2000
				









			



		

			



