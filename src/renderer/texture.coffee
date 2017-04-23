# Public: Texture
class Fz2D.Texture
  # Public: Relative Path.
  src: null

  # Public: Constructor.
  #
  # image - color, instance of an image HTML DOM element or another {Fz2D.Texture}
  # x - source position on the X axis (default: 0)
  # y - source position on the Y axis (default: 0)
  # w - source width (default: image width)
  # h - source height (default: image height)
  constructor: (image=null, x=0, y=0, w=null, h=null) ->
    if image?
      if image instanceof Fz2D.Texture
        @_native = image._native
        @texture_id = image.texture_id if image.texture_id?
        @x = image.x + x
        @y = image.y + y
        @w = w || image.w
        @h = h || image.h
        @iw = image.iw
        @ih = image.ih
        return
      else if image instanceof Fz2D.TextureInput
        w = x
        x = 0

        h = y
        y = 0

        image = image.apply(Fz2D.Renderer.getContext(w, h, null, null, '2d'), w, h)

      @_native = image
      @x = x
      @y = y
      @w = w || image.width
      @h = h || image.height
      @iw = 1.0 / @w
      @ih = 1.0 / @h

      return

    @x = x
    @y = y
    @w = w || 0
    @h = h || 0

    if @w > 0
      @iw = 1.0 / @w
    else
      @iw = 0.0

    if @h > 0
      @ih = 1.0 / @h
    else
      @ih = 0.0

    @_native = new window.Image()
    @_native.onload = () =>
      console.log("Loaded image: #{@_native.src}")

      if @w == 0
        @w = @_native.width
        @iw = 1.0 / @_native.width

      if @h == 0
        @h = @_native.height
        @ih = 1.0 / @_native.height

      @onload(@)
    @_native.onerror = () =>
      console.log("Failed to load image: #{@_native.src}")
      @onload(@)

  # Public: On load(ed) callback.
  #
  # texture - {Fz2D.Texture}
  onload: (texture) ->
    # empty

  # Public: Loads and image.
  #
  # path - relative path
  load: (path) ->
    @src = path
    @_native.src = path
    @

  # Public: Creates a Sub Texture from a Texture.
  #
  # x - source position on the X axis (default: 0)
  # y - source position on the Y axis (default: 0)
  # w - source width (default: texture height)
  # h - source height (default: texture height)
  #
  # Returns a {Fz2D.Texture} pointng to the same image.
  getSubTexture: (x, y, w, h) ->
    switch arguments.length
      when 1
        if @w % @h == 0
          x = x * @h
          y = 0
          h = @h
          w = @h
        else
          x = 0
          y = 0
          w = @w
          h = @h
      when 2
        w = y
        h = y
        i = x
        ww = @w / y
        x = ((i % ww) | 0) * h
        y = ((i / ww) | 0) * h
      else
        x ?= 0
        y ?= 0
        h ?= @h
        unless w?
          if @w % h == 0
            w = h
          else
            w = @w

    new Fz2D.Texture(@, x, y, w, h)

  # Public: Returns "native" image instance.
  toImage: () ->
    @_native
