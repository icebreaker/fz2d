# Public: Label
class Fz2D.Gui.Label extends Fz2D.Object
  # Public: Constructor
  #
  # text - text to display
  # x - position on the X axis
  # y - position on the Y axis
  # font - {Fz2D.Font}
  constructor: (text, x, y, @font) ->
    super(x, y)
    @setText(text)

    @blink = 0
    @_dt = 0

  # Public: Sets the format.
  #
  # format - text format
  setFormat: (format) ->
    if format? and format.length == 2
      @format = (format[0] for i in [1..parseInt(format[1])]).join('')
    else
      @format = null

    @_setText()

  # Public: Sets the text.
  #
  # text - text to display
  setText: (text) ->
    @text = text.toString()
    @_setText()

  # Public: Determines if the text is equal to a user provided text.
  #
  # text - user provided text
  #
  # Returns true or false depending on the result of the comparison.
  is: (text) ->
    @text == text.toString()

  # Public: Increments the value by a given amount.
  #
  # amount - amount to increment by (default: 1)
  inc: (amount=1) ->
    @setText(@toInt() + amount)

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
    @font.drawText(ctx, @_text, @x, @y)

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

  _setText: () ->
    @_text = @text

    if @format?
      length = @format.length - @text.length
      @_text = @format.substring(0, length) + @_text if length > 0

    size = @font.measureText(@_text)
    @bounds.w = @w = size.w
    @bounds.h = @h = size.h
    @
