# Public: Touch Control
class Fz2D.Plugins.Touch.TouchControl
  # Public: Constructor.
  #
  # w - width of game
  # h - height of game
  # config - configuration hash
  constructor: (w, h, config) ->
    @_keys = config.keys || {}
    
    @_radius = config.radius || 50
    @_radius2= @_radius * @_radius

    @_outer_size = @_radius * 2
    @_outer_half_size = @_outer_size >> 1

    @_inner_size = @_outer_size - 20
    @_inner_half_size = @_inner_size >> 1

    # FIXME: make colors configurable
    input = new Fz2D.TextureInput().addCircle('rgba(224, 224, 224, 0.2)')
    @_outer = new Fz2D.Texture(input, @_outer_size, @_outer_size)

    input = new Fz2D.TextureInput().addCircle('rgba(224, 224, 224, 0.4)')
    @_inner = new Fz2D.Texture(input, @_inner_size, @_inner_size)

    # FIXME: make position configurable
    if config.left?
      @_outer_x = 20
      @_inner_x = 30
    else
      @_outer_x = w - @_outer_size - 20
      @_inner_x = w - @_outer_size - 10

    @_outer_y = h - @_outer_size - 20
    @_inner_y = h - @_outer_size - 10

    @cx = @_outer_x + @_radius
    @cy = @_outer_y + @_radius
 
    @dx = 0
    @dy = 0

    @id = null

  # Public: Fired on press.
  #
  # touch - Hash
  # input - {Fz2D.Input}
  pressed: (touch, input) ->
    # empty

  # Public: Fired on move.
  #
  # touch - Hash
  # input - {Fz2D.Input}
  moved: (touch, input) ->
    # empty

  # Public: Fired on release.
  #
  # input - {Fz2D.Input}
  released: (touch, input) ->
    for k, v of @_keys
      input.keys[v] = input.keys.pressed[v] = false

    null

  # Public: Updates touch control on every frame.
  #
  # timer - {Fz2D.Timer}
  # input - {Fz2D.Input}
  update: (timer, input) ->
    if @id?
      touch = input.touch.collection.find(@id)
      return unless touch?

      @dx = 0
      @dy = 0

      if input.touch.released?
        @id = null
        @released(touch, input)
      else
        @moved(touch, input)
    else if input.touch.pressed?
      touch = input.touch.collection.first()
      dx = touch.offsetX - @cx
      dy = touch.offsetY - @cy
      if dx * dx + dy * dy < @_radius2
        @id = touch.id
        @dx = 0
        @dy = 0
        @pressed(touch, input)

  # Public: Draws touch control on every frame.
  #
  # ctx - {Fz2D.Canvas}
  draw: (ctx) ->
    ctx.draw(@_outer, 0, 0, @_outer.w, @_outer.h,       @_outer_x,       @_outer_y, @_outer_size, @_outer_size, @_outer_half_size, @_outer_half_size, 0.0, 1.0)
    ctx.draw(@_inner, 0, 0, @_inner.w, @_inner.h, @dx + @_inner_x, @dy + @_inner_y, @_inner_size, @_inner_size, @_inner_half_size, @_inner_half_size, 0.0, 1.0)
