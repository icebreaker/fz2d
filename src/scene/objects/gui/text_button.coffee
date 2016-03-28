# Public: Text Button
class Fz2D.Gui.TextButton extends Fz2D.Gui.Button
  # Public: Constructor
  #
  # x - position on the X axis
  # y - position on the Y axis
  # text - label text
  # font - label font
  # texture_up - {Fz2D.Texture}
  # texture_down - {Fz2D.Texture} (default: texture_up)
  # texture_over - {Fz2D.Texture} (default: texture_down)
  constructor: (x, y, text, @font, texture_up, texture_down=texture_up, texture_over=texture_down) ->
    super(x, y, texture_up, texture_down, texture_over)

    @label = new Fz2D.Gui.Label('', x, y, @font)
    @setText(text)

  # Public: Sets the text of the label.
  #
  # text - the actual label
  setText: (text) ->
    c = @font.centerText(@, text)
    
    @label.setText(text)
    @label.x = c.x
    @label.y = c.y

    @text = text
    @

  # Public: Draws button on every frame.
  #
  # ctx - {Fz2D.Canvas}
  draw: (ctx) ->
    super

    if @is('down')
      # FIXME: :D
      @label.y++
      @label.draw(ctx)
      @label.y--
    else
      @label.draw(ctx)

    null
