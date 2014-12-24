# Public: Texture Loader
class Fz2D.Loader.Loaders.Texture extends Fz2D.Loader.Base
  # Public: Respond to '.png' images.
  extension: 'png'
  # Public: Relative 'image' root path.
  path: 'textures'

  # Public: Loads an 'image' asset.
  #
  # path - relative partial path
  #
  # Returns a {Fz2D.Texture}.
  load: (path) ->
    texture = new Fz2D.Texture()
    texture.onload = () =>
      @onload(texture)
    texture.load(@expand(path))
    texture
