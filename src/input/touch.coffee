# Public: Touch
class Fz2D.Input.Touch
  # Public: Constructor
  #
  # element - HTML DOM element
  # x - initial touch position on the X axis (default: 0)
  # y - initial touch position on the Y axis (default: 0)
  constructor: (@element, @x=0, @y=0) ->
    @position = new Fz2D.Point(@x, @y)
    @collection = new Fz2D.Input.Touch.Collection(@element.getBoundingClientRect())
    @update()

    return unless Fz2D.touch?

    if window.PointerEvent?
      @_setup_pointer()
    else
      @_setup()

  # Public: Updates touch state on every frame.
  update: () ->
    @dx = @dy = 0
    @pressed = @released = null
    @collection.length = 0

  # Private: Registers all event touch listeners.
  _setup: () ->
    @element.addEventListener 'touchstart', (e) =>
      e.preventDefault()
      @element.onmousedown(@_updateTouches(e))
      @pressed = true
      @released = null
      false

    @element.addEventListener 'touchend', (e) =>
      @element.onmouseup(@_updateTouches(e))
      @pressed = null
      @released = true
      false

    @element.addEventListener 'touchcancel', (e) =>
      @element.onmouseup(@_updateTouches(e))
      @pressed = null
      @released = true
      false

    @element.addEventListener 'touchmove', (e) =>
      e.preventDefault()
      @_updateTouches(e)
      false

    @element.addEventListener 'selectstart', (e) ->
      e.preventDefault()
      false
    
    @element.addEventListener 'contextmenu', (e) ->
      e.preventDefault()
      false

    @element.addEventListener 'MSHoldVisual', (e) ->
      e.preventDefault()
      false

  # Private: Registers all pointer touch event listeners.
  _setup_pointer: () ->
    # FIXME: add support for IE 10 pointer events (prefixed with MS)
    @element.addEventListener 'pointerdown', (e) =>
      @element.onmousedown(@_updatePointerTouches(e))
      @pressed = true
      @released = null
      false

    @element.addEventListener 'pointerup', (e) =>
      @element.onmouseup(@_updatePointerTouches(e))
      @pressed = null
      @released = true
      false
    
    @element.addEventListener 'pointerout', (e) =>
      @element.onmouseup(@_updatePointerTouches(e))
      @pressed = null
      @released = true
      false

    @element.addEventListener 'pointercancel', (e) =>
      @element.onmouseup(@_updatePointerTouches(e))
      @pressed = null
      @released = true
      false

    @element.addEventListener 'pointermove', (e) =>
      @_updatePointerTouches(e)
      false

    @element.addEventListener 'selectstart', (e) ->
      e.preventDefault()
      false
    
    @element.addEventListener 'contextmenu', (e) ->
      e.preventDefault()
      false

    @element.addEventListener 'MSHoldVisual', (e) ->
      e.preventDefault()
      false

  # Private: Updates the touch collection.
  #
  # e - TouchEvent
  _updateTouches: (e) ->
    @collection.setFromTouchList(e.changedTouches)
    @_updateLastTouch(e)

  # Private: Updates the touch collection.
  #
  # e - PointerEvent
  _updatePointerTouches: (e) ->
    @collection.setFromPointer(e)
    @_updateLastTouch(e)

  # Private: Updates relative and absolute positions.
  #
  # touch - a touch
  _updateLastTouch: (e) ->
    touch = @collection.first()

    @dx = touch.offsetX - @x
    @dy = touch.offsetY - @y

    @position.x = @x = touch.offsetX
    @position.y = @y = touch.offsetY

    @element.onmousemove(touch)

    touch
