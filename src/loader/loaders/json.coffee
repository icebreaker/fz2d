# Public: JSON Loader
class Fz2D.Loader.Loaders.JSON extends Fz2D.Loader.Base
  # Public: Respond to '.json'.
  extension: 'json'
  # Public: Relative 'json' root path.
  path: 'json'

  # Public: Loads a 'json' asset.
  #
  # path - relative partial path
  #
  # Returns a JSON hash.
  load: (path) ->
    expanded_path = @expand(path)

    json = {}
    
    Fz2D.getJSON(expanded_path, (resp, code) =>
      if code == 200
        console.log("Loaded json: #{Fz2D.url}#{expanded_path}")
        for k, v of resp
          json[k] = v
      else
        console.log("Failed to load json: #{Fz2D.url}#{expanded_path}")
  
      @onload(json)
    )

    json
