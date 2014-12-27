# Public: Canvas (2D)
class Fz2D.Canvas
  # Public: Supported Canvas Type?
  @supported: (() ->
    try
      if window.CanvasRenderingContext2D and Fz2D.createEl('canvas').getContext('2d')
        '2d'
      else
        null
    catch
      null
  )()
  # Public: Context Options.
  @opts: {}

  # Public: Requests and configures a context.
  #
  # w - width
  # h - height
  # color - background color (optional)
  # selector - selector to find or create the canvas for the context (optional)
  # type - type of the context (default: supported)
  # opts - options to pass to when requesting the context (optional)
  #
  # Returns the requested context or null.
  @getContext: (w, h, color=null, selector=null, type=@supported, opts=@opts) ->
    if selector?
      canvas = Fz2D.getEl(selector) || Fz2D.createEl('canvas')
    else
      canvas = Fz2D.createEl('canvas')

    canvas.width  = w
    canvas.height = h

    canvas.style.backgroundColor = color if color?

    if selector?
      canvas.id = selector.slice(1)
      canvas.style.position = 'relative' # required for FF to have correct relative mouse coords
      canvas.style.touchAction = 'none' # disable pan/zoom in all browsers supporting touch
      Fz2D.appendEl(canvas)
    
    ctx = canvas.getContext(type, opts)

    if ctx?
      ctx.mozImageSmoothingEnabled = false
      ctx.webkitImageSmoothingEnabled = false
      ctx.imageSmoothingEnabled = false

    ctx

  # Public: Creates an image filled with a solid color.
  #
  # w - width of the image
  # h - height of the image
  # color - color of the image
  #
  # Returns the image.
  @createImage: (w, h, color) ->
    ctx = Fz2D.Canvas.getContext(w, h)

    [color, type, radius] = color.split(':')

    ctx.fillStyle = color

    if type == 'circle'
      radius ?= w / 2.0

      ctx.beginPath()
      ctx.arc(radius, h / 2.0, radius, 0, 2 * Math.PI, false)
      ctx.fill()
    else
      ctx.fillRect(0, 0, w, h)

    ctx.canvas
 
  # Public: Constructor.
  #
  # w - width
  # h - height
  # color - background HTML color code (default: Fz2D.BG)
  # selector - query selector or id (default: Fz2D.SELECTOR)
  constructor: (@w, @h, @color=null, @selector=null) ->
    @_ctx = Fz2D.Renderer.getContext(@w, @h, @color, @selector)
    @bounds = new Fz2D.Rect(0, 0, @w, @h)
    @draw_call_count = 0

  # Public: Fills the canvas with a solid color.
  #
  # color - HTML color code
  fill: (color) ->
    @_ctx.fillStyle = color
    @_ctx.fillRect(0, 0, @w, @h)
    @_ctx

  # Public: Clears the canvas.
  clear: () ->
    @draw_call_count = 0
    @_ctx.clearRect(0, 0, @w, @h)
    @_ctx

  # Public: Flushes the canvas.
  flush: () ->
    # do nothing

  # Public: Draws a {Fz2D.Texture}.
  #
  # texture - {Fz2D.Texture}
  # sx - source position on the X axis
  # sy - source position on the Y axis
  # sw - source width
  # sh - source height
  # x - desired position on the X axis
  # y - desired position on the Y axis
  # w - desired width
  # h - desired height
  draw: (texture, sx, sy, sw, sh, x, y, w, h) ->
    @draw_call_count++
    @_ctx.drawImage(texture._native, sx, sy, sw, sh, x, y, w, h)
    @_ctx

  # Public: Returns the canvas as an image.
  toImage: () ->
    @_ctx.canvas

  # Public: Returns the canvas as an HTML DOM element.
  toElement: () ->
    @_ctx.canvas
