# Public: Mouse
class Fz2D.Gui.Mouse extends Fz2D.Entity
  # Public: Constructor.
  constructor: () ->
    super
    @position = new Fz2D.Vec2(@x, @y)
    @button = null

  # Public: On click(ed) callback.
  #
  # mouse - {Fz2D.Gui.Mouse}
  onclick: (mouse) ->
    # empty

  # Public: Updates mouse on every frame.
  #
  # timer - {Fz2D.Timer}
  # input - {Fz2D.Input}
  update: (timer, input) ->
    @x = input.mouse.x
    @y = input.mouse.y

    @position.set(@x, @y)
    @button = null

    for i in [0..Fz2D.Input.Mouse.Button.MAX]
      if input.mouse.released[i]
        @button = i
        @onclick(@)
        break
