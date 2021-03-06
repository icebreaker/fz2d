# Public: Object
class Fz2D.Object
  # Public: Constructor.
  #
  # x - position on the X axis
  # y - position on the Y axis
  # w - width
  # h - height
  constructor: (@x, @y, @w, @h) ->
    @x ?= 0
    @y ?= 0
    @w ?= 0
    @h ?= 0

    @bounds = new Fz2D.BBox(0, 0, @w, @h)
    @hw = @bounds.hw
    @hh = @bounds.hh

    @solid    = true
    @visible  = true
    @alive    = true
    @exists   = true
    @angle    = 0.0
    @alpha    = 1.0
    @z        = 0
    @tag      = "_default"
  
  # Public: Kills the object.
  kill: () ->
    @visible = false
    @alive = false
    @exists = false
    @

  # Public: Resets the object.
  #
  # x - position on the X axis
  # y - position on the Y axis
  # angle - rotation angle
  reset: (x=null, y=null, angle=null) ->
    @x = x if x?
    @y = y if y?
    @angle = angle if angle?

    @visible = true
    @alive = true
    @exists = true

    @

  # Public: Shows the object.
  show: () ->
    @visible = true
    @

  # Public: Hides the object.
  hide: () ->
    @visible = false
    @

  # Public: Draws the object on every frame.
  #
  # ctx - {Fz2D.Canvas}
  draw: (ctx) ->
    # empty

  # Public: Updates the object on every frame.
  #
  # timer - {Fz2D.Timer}
  # input - {Fz2D.Input}
  update: (timer, input) ->
    # empty
