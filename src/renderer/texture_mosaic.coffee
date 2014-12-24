# Public: Texture Mosaic
class Fz2D.TextureMosaic extends Fz2D.Texture
  # Public: Constructor.
  #
  # w - width of texture
  # h - height of texture
  # tw - mosaic tile width
  # alpha - mosaic tile alpha
  constructor: (w, h, tw, alpha) ->
    ctx = Fz2D.Renderer.getContext(w, h, null, null, '2d')
    
    image_data = ctx.getImageData(0, 0, tw, tw)
    buffer = image_data.data

    twl = tw - 1

    buffer._set = (x, y, r, g, b, a) ->
      i = (x << 2) + ((y << 2) * tw)
      buffer[i + 0] = r
      buffer[i + 1] = g
      buffer[i + 2] = b
      buffer[i + 3] = a

    for i in [0..twl] by 4
      buffer[i + 0] = 128
      buffer[i + 1] = 128
      buffer[i + 2] = 128
      buffer[i + 3] = alpha

    buffer._set(0, 0, 255, 255, 255, alpha)
#    buffer._set(twl, twl, 0, 0, 0, alpha)

    for i in [1..twl]
      buffer._set(i, 0, 224, 224, 224, alpha)
      buffer._set(i, 1, 255, 255, 255, alpha)
      buffer._set(i, twl, 0, 0, 0, alpha)
      buffer._set(0, i, 255, 255, 255, alpha)
      buffer._set(twl, i, 0, 0, 0, alpha)

    xx = ((w / tw) | 0) - 1
    yy = ((h / tw) | 0) - 1
    for x in [0..xx]
      for y in [0..yy]
        ctx.putImageData(image_data, x * tw, y * tw)

    super(ctx.canvas)
