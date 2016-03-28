# Public: Font
class Fz2D.Font
  # Public: Constructor.
  #
  # texture - {Fz2D.Texture}
  # size - font size (default: texture.h)
  # s - start letter (default: ' ')
  # e - end letter (default: '~')
  constructor: (@texture, @size=@texture.h, s=' ', e='~') ->
    @chars = {}

    start = (s || ' ').charCodeAt(0)
    end = (e || '~').charCodeAt(0) + 1

    w = @texture.w / @size

    for c in [start..end]
      i = (c - start)

      xx = (i % w)
      yy = ((i - xx) / w)

      x = (@texture.x + (xx * @size))
      y = (@texture.y + (yy * @size))

      @chars[String.fromCharCode(c)] = new Fz2D.BBox(x, y, @size, @size)

    @invalid_char = @chars[String.fromCharCode(end)]

    @spaceSize  = @size
    @lineSize   = @spaceSize + (@spaceSize >> 2)
    @tabSize    = @spaceSize << 2

  # Public: Centers text inside the given rect.
  #
  # ro - {Fz2D.Rect}, {Fz2D.Object} or {Fz2D.Group}
  # text - text to measure
  #
  # Returns a {Fz2D.Rect}.
  centerText: (ro, text) ->
    m = @measureText(text)
    
    new Fz2D.Rect(ro.x + ((ro.w - m.w) >> 1),
                  ro.y + ((ro.h - m.h) >> 1)
                  ro.w,
                  ro.h)

  # Public: Measures text.
  #
  # text - text to measure
  #
  # Returns a {Fz2D.Rect}.
  measureText: (text) ->
    w = 0
    h = 0
    maxWidth = 0

    for c in text
      switch c
        when ' '
          w += @spaceSize
          continue
        when '\n'
          maxWidth = w if w > maxWidth
          w = 0
          h += @lineSize
          continue
        when '\t'
          w += @tabSize
          continue

      char = @chars[c] || @invalid_char

      w += char.w

    if w > 0 and maxWidth == 0
      maxWidth = w

    if maxWidth > 0 and h == 0
      h = @size

    new Fz2D.Rect(0, 0, maxWidth, h)

  # Public: Draws Text.
  #
  # ctx - {Fz2D.Canvas}
  # text - text to measure
  # x - position on the X axis
  # y - position on the Y axis
  #
  # Returns a last position.
  drawText: (ctx, text, x, y) ->
    xx = x
    yy = y

    for c in text
      switch c
        when ' '
          xx += @spaceSize
          continue
        when '\n'
          xx = x
          yy += @lineSize
          continue
        when '\t'
          xx += @tabSize
          continue
 
      char = @chars[c] || @invalid_char

      ctx.draw(@texture, char.x, char.y, char.w, char.h, xx, yy, char.w, char.h, char.hw, char.hh, 0.0, 1.0)

      xx += char.w

    xx
