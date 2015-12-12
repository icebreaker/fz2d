# Public: Mouse
class Fz2D.Input.Mouse
  # Public: Constructor
  #
  # element - HTML DOM element
  # x - initial mouse position on the X axis (default: 0)
  # y - initial mouse position on the Y axis (default: 0)
  constructor: (@element, @x=0, @y=0) ->
    @position = new Fz2D.Vec2(@x, @y)

    @pressed = {}
    @released = {}

    for i in [0..Fz2D.Input.Mouse.Button.MAX_BUTTONS]
      @[i] = @pressed[i] = @released[i] = false

    @element.onmousedown = (e) =>
      @[e.button] = @pressed[e.button] = true
      @released[e.button] = false
      false

    @element.onmouseup = (e) =>
      @[e.button] = @pressed[e.button] = false
      @released[e.button] = true
      false

    if Fz2D.firefox? and not Fz2D.touch? # <3 FF <3
      @element.onmousemove = (e) =>
        if e.layerX || e.layerX == 0
          @dx = e.layerX - @x
          @dy = e.layerY - @y
          @position.x = @x = e.layerX
          @position.y = @y = e.layerY
    else
      @element.onmousemove = (e) =>
        if e.offsetX || e.offsetX == 0
          @dx = e.offsetX - @x
          @dy = e.offsetY - @y
          @position.x = @x = e.offsetX
          @position.y = @y = e.offsetY

    @element.oncontextmenu = (e) ->
      e.preventDefault()
      false

  # Public: Shows the mouse cursor.
  show: () ->
    @element.style.cursor = 'hand'

  # Public: Hides the mouse cursor.
  hide: () ->
    @element.style.cursor = 'none'

  # Public: Updates mouse state on every frame.
  update: () ->
    @dx = @dy = 0

    for i in [0..Fz2D.Input.Mouse.Button.MAX_BUTTONS]
      @pressed[i] = @released[i] = false

    null
