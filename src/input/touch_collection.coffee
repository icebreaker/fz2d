# Public: Touch Collection
class Fz2D.Input.Touch.Collection
  # Public: Constructor.
  #
  # bounds - bounding rectangle of the element
  # n - number of touches to pre-allocate (default: 16)
  constructor: (bounds, n=16) ->
    @x = bounds.left
    @y = bounds.top
    @_reserve(n)
 
  # Public: Sets the internal touches.
  setFromPointer: (pointer) ->
    item = @_items[0]
    item.id = pointer.pointerId
    item.offsetX = pointer.clientX - @x
    item.offsetY = pointer.clientY - @y

    @length = 1

  # Public: Sets the internal touches.
  #
  # touches - a native TouchList
  setFromTouchList: (touches) ->
    # FIXME: implement 'resize' on demand
    for i in [0..touches.length-1]
      touch = touches[i]

      item = @_items[i]

      item.id = touch.identifier
      item.offsetX = touch.clientX - @x
      item.offsetY = touch.clientY - @y

    @length = touches.length

  # Public: Finds a touch by its id.
  #
  # id - touch identifier
  #
  # Returns a touch.
  find: (id) ->
    return null if @length == 0

    for i in [0..@length-1]
      item = @_items[i]
      return item if item.id == id

    null

  # Public: Returns first touch.
  first: () ->
    @_items[0]

  # Public: Returns last touch.
  last: () ->
    @_items[@length - 1]

  # Returns touch at the specified index.
  #
  # i - index of a touch
  at: (i) ->
    @_items[i]

  # Private: Allocates the internal touches.
  #
  # n - number of touches to allocate
  _reserve: (n) ->
    @_items = []

    for i in [0..n-1]
      @_items[i] = { id: null,  offsetX: 0, offsetY: 0, button: 0 }
  
    @length = 0
