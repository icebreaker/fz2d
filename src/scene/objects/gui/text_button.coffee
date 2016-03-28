# Public: Text Button
class Fz2D.Gui.TextButton extends Fz2D.Gui.Button
  # Public: Constructor
  #
  # x - position on the X axis
  # y - position on the Y axis
  # text - label text
  # font - label font
  # up - {Fz2D.Texture}
  # down - {Fz2D.Texture} (default: up)
  # over - {Fz2D.Texture} (default: down)
  constructor: (x, y, text, @font, up, down=up, over=down) ->
    super(x, y, up, down, over)

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
