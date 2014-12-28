# Public: Input
class Fz2D.Input
  # Public: Constructor.
  #
  # element - HTML DOM element
  # x - initial position on the X axis (default: 0)
  # y - initial position on the Y axis (default: 0)
  constructor: (@element, x=0, y=0) ->
    @keys     = new Fz2D.Input.Keyboard()
    @mouse    = new Fz2D.Input.Mouse(@element, x, y)
    @touch    = new Fz2D.Input.Touch(@element, x, y)

  # Public: Updates keyboard, mouse and touch states on every frame.
  update: () ->
    @keys.update()
    @mouse.update()
    @touch.update()
