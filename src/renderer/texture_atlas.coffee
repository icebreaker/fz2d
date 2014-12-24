# Public: Texture Atlas
class Fz2D.TextureAtlas
  # Public: Constructor.
  #
  # texture - {Fz2D.Texture} (default: null)
  constructor: (@texture=null) ->
    @textures = {}

  # Public: Sets the texture.
  #
  # texture - {Fz2D.Texture}
  #
  # Returns a {Fz2D.Texture}.
  setTexture: (texture) ->
    @texture = texture

  # Public: Defines a texture.
  #
  # tag - name of the texture
  # x - source position on the X axis
  # y - source position on the Y axis
  # w - source width
  # h - source height
  #
  # Returns a {Fz2D.Texture}.
  addTexture: (tag, x, y, w, h) ->
    @textures[tag] = new Fz2D.Texture(@texture, x, y, w, h)

  # Public: Gets a texture by tag name.
  #
  # tag - name of the texture
  #
  # Returns a {Fz2D.Texture}.
  getTexture: (tag) ->
    @textures[tag]
