# Public: Horizontal Scroller
class Fz2D.HorizontalScroller extends Fz2D.Entity
  # Public: Constructor.
  #
  # texture - {Fz2D.Texture}
  # x - position on the X axis (default: 0)
  # y - position on the Y axis (default: 0)
  # w - width of entity (default: texture width)
  # h - height of entity (default: texture height)
  constructor: () ->
    super

    @dx = -0.3
    @sx = @w
    @wf = @w * 1.0

  # Public: Draws scroller on every frame.
  #
  # ctx - {Fz2D.Canvas}
  draw: (ctx) ->
    ctx.draw(@texture,
             @w - @sx,
             @y,
             @sx,
             @h,
             @x,
             @y,
             @sx,
             @h)
    ctx.draw(@texture,
             @x,
             @y,
             @w - @sx,
             @h,
             @sx,
             @y,
             @w - @sx,
             @h)

  # Public: Updates scroller on every frame.
  #
  # timer - {Fz2D.Timer}
  # input - {Fz2D.Input}
  update: (timer, input) ->
    if @sx <= 0
      @sx = @w
    else
      @sx = Fz2D.clamp(@sx + timer.dt * @dx, 0.0, @wf)
