# Public: Mouse
class Fz2D.Gui.Mouse extends Fz2D.Entity
  # Public: Updates mouse on every frame.
  #
  # timer - {Fz2D.Timer}
  # input - {Fz2D.Input}
  update: (timer, input) ->
    @x = input.mouse.x
    @y = input.mouse.y
