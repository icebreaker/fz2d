# Public: Mouse
class Fz2D.Input.Mouse
  # Public: Constructor
  #
  # element - HTML DOM element
  # x - initial mouse position on the X axis (default: 0)
  # y - initial mouse position on the Y axis (default: 0)
  constructor: (element, @x=0, @y=0) ->
    @position = new Fz2D.Point(@x, @y)
    @update()

    element.onmousedown = (e) =>
      @[e.button] = @pressed[e.button] = true
      @released[e.button] = false
      false

    element.onmouseup = (e) =>
      @[e.button] = @pressed[e.button] = false
      @released[e.button] = true
      false

    # <3 FF <3
    if /firefox/i.test(navigator.userAgent)
      element.onmousemove = (e) =>
        if e.layerX || e.layerX == 0
          @dx = e.layerX - @x
          @dy = e.layerY - @y
          @position.x = @x = e.layerX
          @position.y = @y = e.layerY
    else
      element.onmousemove = (e) =>
        if e.offsetX || e.offsetX == 0
          @dx = e.offsetX - @x
          @dy = e.offsetY - @y
          @position.x = @x = e.offsetX
          @position.y = @y = e.offsetY

    element.oncontextmenu = (e) ->
      false

    @_element = element

  # Public: Shows the mouse cursor.
  show: () ->
    @_element.style.cursor = 'hand'

  # Public: Hides the mouse cursor.
  hide: () ->
    @_element.style.cursor = 'none'

  # Public: Updates mouse state on every frame.
  update: () ->
    @dx = @dy = 0
    @pressed = {}
    @released = {}
