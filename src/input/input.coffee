# Public: Input
class Fz2D.Input
  # Public: Constructor.
  #
  # element - HTML DOM element
  # x - initial mouse position on the X axis (default: 0)
  # y - initial mouse position on the Y axis (default: 0)
  constructor: (element, x=0, y=0) ->
    @keys  = new Fz2D.Input.Keyboard()
    @mouse = new Fz2D.Input.Mouse(element, x, y)

  # Public: Updates keyboard and mouse states on every frame.
  update: () ->
    @keys.update()
    @mouse.update()
