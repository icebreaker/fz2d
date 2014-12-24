# Public: Button
class Fz2D.Gui.Button extends Fz2D.Entity
  # Public: Constructor
  #
  # x - position on the X axis
  # y - position on the Y axis
  # text - label text
  # font - label font
  # size - label font size (default: font.size)
  # texture_up - {Fz2D.Texture}
  # texture_down - {Fz2D.Texture} (default: texture_up)
  constructor: (x, y, text, @font, @size=@font.size, texture_up, texture_down=texture_up, texture_over=texture_down) ->
    super(texture_up, x, y)

    @addAnimation("up", texture_up)
    @addAnimation("down", texture_down)
    @addAnimation("over", texture_over)

    @label = new Fz2D.Gui.Label('', x, y, @font, @size)
    @setText(text)

  # Public: Sets the text of the label.
  #
  # text - the actual label
  setText: (text) ->
    c = @font.centerText(@, text, @size)
    
    @label.setText(text)
    @label.x = c.x
    @label.y = c.y

    @text = text
    @
   
  # Public: On click(ed) callback.
  #
  # button - {Fz2D.Gui.Button}
  onclick: (button) ->
    # empty

  # Public: Draws button on every frame.
  #
  # ctx - {Fz2D.Canvas}
  draw: (ctx) ->
    super

    if @is("down")
      # FIXME: :D
      @label.y++
      @label.draw(ctx)
      @label.y--
    else
      @label.draw(ctx)

    null

  # Public: Updates button on every frame.
  #
  # timer - {Fz2D.Timer}
  # input - {Fz2D.Input}
  update: (timer, input) ->
    if Fz2D.contains(@, input.mouse.position)
      if input.mouse[Fz2D.Input.Mouse.Button.LEFT]
        @play("down")
      else
        @play("over")
      
      if input.mouse.released[Fz2D.Input.Mouse.Button.LEFT] # on click (once!)
        @onclick(@)
    else if not @is("up")
      @play("up")

    null
