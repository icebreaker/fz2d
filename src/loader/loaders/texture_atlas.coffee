# Public: Texture Atlas Loader
class Fz2D.Loader.Loaders.TextureAtlas extends Fz2D.Loader.Base
  # Public: Respond to '.atl'.
  extension: 'atl'
  # Public: Relative 'texture atlas' root path.
  path: 'json'
  
  # Public: Constructor.
  #
  # path - relative data root path
  constructor: (path) ->
    super

    @_texture_atlases = {}

    @_texture_loader = new Fz2D.Loader.Loaders.Texture(path)
    @_texture_loader.onload = (texture) =>
      texture_atlas = @_texture_atlases[texture.src]

      if texture_atlas? and texture_atlas.__regions?
        texture_atlas.setTexture(texture)

        for k, v of texture_atlas.__regions
          texture_atlas.addTexture(k, v.x, v.y, v.w, v.h)

        delete texture_atlas['__regions']
        delete @_texture_atlases[texture.src]

      @onload()

  # Public: Loads a "texture atlas" asset.
  #
  # path - relative partial path 
  #
  # Returns a {Fz2D.TextureAtlas}.
  load: (path) ->
    expanded_path = @expand(path)

    texture_atlas = new Fz2D.TextureAtlas()
 
    Fz2D.getJSON(expanded_path, (resp, code) =>
      if code == 200
        if resp.src? and resp.regions?
          console.log("Loaded texture atlas: #{Fz2D.url}#{expanded_path}")
          texture_atlas.__regions = resp.regions
          @_texture_atlases[@_texture_loader.expand(resp.src)] = texture_atlas
          @_texture_loader.load(resp.src)
        else
          console.log("Invalid texture atlas: #{Fz2D.url}#{expanded_path}")
          @onload()
      else
        console.log("Failed to load texture atlas: #{Fz2D.url}#{expanded_path}")
        @onload()
    )

    texture_atlas
