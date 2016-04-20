# Public: Texture Input
class Fz2D.TextureInput
  # Public: Constructor
  constructor: () ->
    @_filters = []

  # Public: Executes all the added filters in sequential order.
  #
  # ctx - 2d canvas context
  # w - width of canvas
  # h - height of canvas
  #
  # Returns an instance of a canvas.
  apply: (ctx, w, h) ->
    for cb in @_filters
      cb(ctx, w, h)

    ctx.canvas

  # Public: Adds a generic "input filter" to be executed.
  #
  # cb - filter callback function
  add:(cb) ->
    @_filters.push(cb)
    @

  # Public: Solid color fill filter.
  #
  # color - fill color
  addFill: (color) ->
    @add((ctx, w, h) ->
      ctx.fillStyle = color
      ctx.fillRect(0, 0, w, h)
    )

  # Public: Solid circle fill filter.
  #
  # color - fill color
  # radius - radius of the circle (default: w / 2)
  addCircle: (color, radius) ->
    @add((ctx, w, h) ->
      radius ?= (w >> 1)
      ctx.fillStyle = color
      ctx.beginPath()
      ctx.arc(radius, radius, radius, 0, 2 * Math.PI, false)
      ctx.fill()
    )
