# Public: Label
class Fz2D.Gui.Label extends Fz2D.Object
  # Public: Constructor
  #
  # text - text to display
  # x - position on the X axis
  # y - position on the Y axis
  # font - {Fz2D.Font}
  # size - text size (default: font.size)
  constructor: (text, x, y, @font, @size=@font.size) ->
    super(x, y)
    @setText(text)

    @blink = 0
    @_dt = 0
  
  # Public: Sets the text.
  #
  # text - text to display
  setText: (text) ->
    @text = text

    size = @font.measureText(text, @size)
    @bounds.w = @w = size.w
    @bounds.h = @h = size.h
    @

  # Public: Increments the value by a given amount.
  #
  # amount - amount to increment by (default: 1)
  inc: (amount=1) ->
    @setText((@toInt() + amount).toString())

  # Public: Decrements the value by a given amount.
  #
  # amount - amount to decrement by (default: 1)
  dec: (amount=1) ->
    @inc(-amount)

  # Public: Returns the value as an int.
  toInt: () ->
    parseInt(@text)

  # Public: Draw label on every frame.
  #
  # ctx - {Fz2D.Canvas}
  draw: (ctx) ->
    @font.drawText(ctx, @text, @x, @y, @size)

  # Public: Updates label on every frame.
  #
  # timer - {Fz2D.Timer}
  # input - {Fz2D.Input}
  update: (timer, input) ->
    return unless @blink > 0
    
    @_dt += timer.dt
    return unless @_dt > @blink
    
    @_dt = 0
    @visible = !@visible
