# Public: Vertical Scroller
class Fz2D.VerticalScroller extends Fz2D.Entity
  # Public: Constructor.
  #
  # texture - {Fz2D.Texture}
  # x - position on the X axis (default: 0)
  # y - position on the Y axis (default: 0)
  # w - width of entity (default: texture width)
  # h - height of entity (default: texture height)
  constructor: () ->
    super

    @dy = 0.3
    @sy = 0.0
    @hf = @h * 1.0

  # Public: Draws scroller on every frame.
  #
  # ctx - {Fz2D.Canvas}
  draw: (ctx) ->
    ctx.draw(@texture,
             @x,
             @h - @sy,
             @w,
             @sy,
             @x,
             @y,
             @w,
             @sy)
    ctx.draw(@texture,
             @x,
             @y,
             @w,
             @h - @sy,
             @x,
             @sy,
             @w,
             @h - @sy)

  # Public: Updates scroller on every frame.
  #
  # timer - {Fz2D.Timer}
  # input - {Fz2D.Input}
  update: (timer, input) ->
    if @sy >= @h
      @sy = 0.0
    else
      @sy = Fz2D.clamp(@sy + timer.dt * @dy, 0.0, @hf)
