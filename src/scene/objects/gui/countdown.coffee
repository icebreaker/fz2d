# Public: Countdown
class Fz2D.Gui.Countdown extends Fz2D.Object
  # Public: Constructor
  #
  # count - initial number to count down from
  # x - position on the X axis
  # y - position on the Y axis
  # font - {Fz2D.Font}
  # size - text size (default: font.size)
  constructor: (@count, x, y, @font, @size=@font.size) ->
    super(x, y)

    @count ?= 0
    @delay ?= 1000

    @_count = 0
    @_dt    = 0

    @ended = true
    
  # Public: On end(ed) callback.
  #
  # countdown - {Fz2D.Gui.Countdown}
  onend: (countdown) ->
    # empty

  # Public: Resets the counter.
  reset: () ->
    super

    @ended = false

    @_dt    = 0
    @_count = @count

  # Public: Draw counter on every frame.
  #
  # ctx - {Fz2D.Canvas}
  draw: (ctx) ->
    @font.drawText(ctx, @_count.toString(), @x, @y, @size)

    null

  # Public: Updates counter on every frame.
  #
  # timer - {Fz2D.Timer}
  # input - {Fz2D.Input}
  update: (timer, input) ->
    return null if @ended

    @_dt += timer.dt

    if @_dt > @delay
      @_dt = 0
      if @_count == 0
        @ended = true
        @onend(@)
      else
        @_count--

    null
