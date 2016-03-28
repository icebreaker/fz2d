# Public: Button
class Fz2D.Gui.Button extends Fz2D.Entity
  # Public: Constructor
  #
  # x - position on the X axis
  # y - position on the Y axis
  # texture_up - {Fz2D.Texture}
  # texture_down - {Fz2D.Texture} (default: texture_up)
  # texture_over - {Fz2D.Texture} (default: texture_down)
  constructor: (x, y, texture_up, texture_down=texture_up, texture_over=texture_down) ->
    super(texture_up, x, y, 'up')

    @addAnimation('down', texture_down)
    @addAnimation('over', texture_over)

  # Public: On click(ed) callback.
  #
  # button - {Fz2D.Gui.Button}
  onclick: (button) ->
    # empty

  # Public: Updates button on every frame.
  #
  # timer - {Fz2D.Timer}
  # input - {Fz2D.Input}
  update: (timer, input) ->
    if Fz2D.contains(@, input.mouse.position)
      if input.mouse[Fz2D.Input.Mouse.Button.LEFT]
        @play('down')
      else
        @play('over')
      
      if input.mouse.released[Fz2D.Input.Mouse.Button.LEFT] # on click (once!)
        @onclick(@)
    else if not @is('up')
      @play('up')

    null
