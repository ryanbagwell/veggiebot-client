define (require) ->
	$ = require 'jquery'
	require 'jquery.picplus'
	Framework7 = require 'Framework7'
	_ = require 'underscore'
	_.str = require 'underscore.string'
	_.mixin _.str.exports()

	Backbone = require 'backbone'
	GardenChart = require 'gardenChart'
	SettingsView = require 'SettingsView'


	moment = require 'moment'
	require 'moment-timezone'
	require 'tzdata'

	CurrentStatusView = require 'CurrentStatusView'

	GardenData = require 'GardenData'

	$$ = Framework7.$

	Parse = require 'Parse'

	class MobileGardenChart extends GardenChart

		margins:
            top: 30
            right: 30
            bottom: 50
            left: 30


	class MobileApp extends Framework7

		constructor: (@options) ->
			super(options)

			@user = Parse.User.current()

			@initialize() if @user


			$$('#guest-login').on 'click', (e) =>
				e.preventDefault()
				@logIn true

			$$('#login button').on 'click', (e) =>
				e.preventDefault()
				@logIn false

			$$('#log-out').on 'click', (e) =>
				e.preventDefault()
				@logOut()

			$$(window).on 'ready', (e) ->
				$('.login').fadeOut 500

		initialize: ->

			$$('.login').removeClass 'loading'

			$('[data-picplus]').picplus()

			@gardenData = new GardenData()

			@gardenData.on 'reset', =>
				@setStatusView()
				@ready()

			@gardenData.fetch
				reset: true

			@settingsView = new SettingsView
				el: $$(@options.views.settingsView)

			@addView @options.views.statusView

			@addView @options.views.settingsView


			$$('.pull-to-refresh-content').on 'refresh', =>
				@gardenData.fetch
					reset: true

			$$('#login-form').on 'submit', (e) =>
				e.preventDefault()
				@logIn()


		ready: ->

			$$(window).trigger 'ready'


		setStatusView: ->

			if @currentStatusList
				@currentStatusList.remove()

			@currentStatusList = new CurrentStatusView
				parentNode: @options.views.statusView + ' .status-list'
				collection: @gardenData

			@chart.remove() if @chart

			@chart = new MobileGardenChart
				el: '.chart svg'
				collection: @gardenData

			@refreshDone()

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


		logIn: (guest) ->

			$$('.login').addClass 'loading'

			if guest
				creds =
					email: 'guest@guest.com'
					password: 'guest'
			else
				creds = @getCredentials()

			Parse.User.logIn creds.email, creds.password,
				success: (user) =>
					@loginSuccess(user)
				error: (user, error) =>
					@loginError(user, error)

		loginSuccess: (user) ->

			@initialize()


		loginError: (user, error) ->

			@alert _.titleize(error.message), 'Error'

			$$('.login').removeClass 'loading'

		logOut: ->

			Parse.User.logOut()
			$('.login').fadeIn 500
































