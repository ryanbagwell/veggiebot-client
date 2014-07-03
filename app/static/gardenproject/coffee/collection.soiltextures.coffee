define (require) ->
    $ = require 'jquery'
    _ = require 'underscore'
    Backbone = require 'backbone'
    Parse = require 'Parse'


    class SoilTextureModel extends Parse.Object

        className: "SoilTexture"


    class SoilTextureCollection extends Parse.Collection

        model: SoilTextureModel

        fetch: (options) ->

            defaults = 
                data:
                    order: 'displayOrder'
                reset: true

            super(defaults)




