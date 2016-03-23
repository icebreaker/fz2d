# Public: Object
class Fz2D.Object
  # Public: Constructor.
  #
  # x - position on the X axis
  # y - position on the Y axis
  # w - width
  # h - height
  # tag - name of the object (default: '_default')
  # 
  constructor: (@x, @y, @w, @h, @tag='_default') ->
    @bounds = new Fz2D.BBox(0, 0, @w, @h)

    @solid    = true
    @visible  = true
    @alive    = true
    @exists   = true
    @angle    = 0.0
    @alpha    = 1.0
    @z        = 0
  
  # Public: Kills the object.
  kill: () ->
    @visible = false
    @alive = false
    @exists = false
    @

  # Public: Alias for kill.
  killAll: () ->
    @kill()

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
  
  # Public: Alias for reset.
  resetAll: () ->
    @reset()

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
