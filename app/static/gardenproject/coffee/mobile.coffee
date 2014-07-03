define (require) ->
	$ = require 'jquery'
	require 'jquery.picplus'
	Framework7 = require 'Framework7'
	_ = require 'underscore'
	Backbone = require 'backbone'
	GardenChart = require 'gardenChart'

	SoilTextures = require 'SoilTextures'

	moment = require 'moment'
	require 'moment-timezone'
	require 'tzdata'

	CurrentStatusView = require 'CurrentStatusView'

	GardenData = require 'GardenData'
	SettingsData = require 'settingsData'

	$$ = Framework7.$

	Parse = require 'Parse'

	class MobileGardenChart extends GardenChart

		margins:
            top: 30
            right: 30
            bottom: 50
            left: 30


	class MobileApp extends Framework7

		constructor: (options) ->
			@options = options

			$('[data-picplus]').picplus()

			@soilTextures = new SoilTextures()

			@soilTextures.on 'reset', =>
				@setSoilTexturesList()

			@settings = new SettingsData()

			@settings.on 'reset', =>
				@setSettingsView()

			@gardenData = new GardenData()

			@gardenData.on 'reset', =>
				@setStatusView()

			super(options)

			@settings.fetch
				reset: true

			@gardenData.fetch
				reset: true

			@soilTextures.fetch
				reset: true

			@statusView = @addView @options.views.statusView

			@settingsView = @addView @options.views.settingsView

			$$('.pull-to-refresh-content').on 'refresh', =>
				@gardenData.fetch
					reset: true

			$$('#login-form').on 'submit', (e) =>
				e.preventDefault()
				@logIn()


		setStatusView: ->

			if @currentStatusList
				@currentStatusList.remove()

			@currentStatusList = new CurrentStatusView
				parentNode: @statusView.selector + ' .status-list'
				collection: @gardenData

			@chart.remove() if @chart

			@chart = new MobileGardenChart
				el: '.chart svg'
				collection: @gardenData

			@refreshDone()

		setSettingsView: ->

			$$('[name="pumpStatus"]').val @settings.first().get 'pumpStatus'

			$$('[name="autoThreshold"]').val @settings.first().get 'autoThreshold'

			$$('[name="email"]').val @getCredentials().email

			$$('[name="password"]').val @getCredentials().password

			$$('[name="pumpStatus"]').on 'change', (e) =>
				@settings.first().save
					pumpStatus: $$(e.currentTarget).val()

			$$('[name="autoThreshold"]').on 'change', (e) =>
				@settings.first().save
					autoThreshold: parseInt $$(e.currentTarget).val()

			$$('[name="soilTexture"]').on 'change', (e) =>

				soilTextureClass = Parse.Object.extend('SoilTexture')

				newSoilTextureSetting = new Parse.Query(soilTextureClass).get $$(e.currentTarget).val()

				# console.log newSoilTextureSetting

				#console.log newSoilTextureSetting.settings

				@settings.first().save
					soilTexture: newSoilTextureSetting


			$$('[name="email"], [name="password"]').on 'change', (e) =>
				@saveCredentials()




		setSoilTexturesList: ->

			template = '<option value="<%= id %>"><%= name %></option>'

			@soilTextures.each (model) =>

				option = _.template template,
					id: model.id
					name: model.get 'name'

				console.log @settings.first().get('soilTexture')

				# if @settings.first().get('soilTexture').id == model.id
				# 	console.log 'ahhhhhhh'
				# 	$(option).attr 'selected', ''

				$$('select[name="soilTexture"]').append option


		refreshDone: ->

			_.delay (=> @pullToRefreshDone()), 2000


		saveCredentials: ->

			data =
				email: $$('.login [name="email"]').val()
				password: $$('.login [name="password"]').val()

			console.log data

			localStorage.setItem 'veggieBot', JSON.stringify(data)

			user = new Parse.User()
			user.set 'email', data.email
			user.set 'username', data.email
			user.set 'password', data.password





		getCredentials: ->

			@saveCredentials()

			defaults =
				email: ''
				password: ''

			creds = localStorage.getItem 'veggieBot'

			try
				creds = JSON.parse(creds)
			catch e
				creds = {}

			_.extend defaults, creds




		logIn: ->

			$$('.login').addClass 'loading'

			creds = @getCredentials()

			if creds.email and creds.password
				Parse.User.logIn creds.email, creds.password,

					success: (user) =>

						$('.login').fadeOut 'fast', ->
							$(@).remove()

					error: (user, error) =>
						console.log error

						@alert error.message, 'Error'

						$$('.login').removeClass 'loading'



		signUp: ->

			user.signUp null,
				success: (user) ->
					console.log 'success'

				error: (user, error) ->
					console.log user, error
































