define (require) ->
	Parse = require 'parse.com'

	applicationId = '9NGEXKBz0x7p5SVPPXMbvMqDymXN5qCf387GpOE2'
	javascriptKey = 'bTK4ofh7ncGgPOy5uJTUJhIqbHEq2k0akGfkmgh0'

	Parse.initialize applicationId, javascriptKey

	Parse