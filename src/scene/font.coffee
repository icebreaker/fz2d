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

      @chars[String.fromCharCode(c)] = new Fz2D.Rect(x, y, @size, @size)

    @invalid_char = @chars[String.fromCharCode(end)]

  
  # Public: Centers text inside the given rect.
  #
  # ro - {Fz2D.Rect}, {Fz2D.Object} or {Fz2D.Group}
  # text - text to measure
  # size - text size (default: font size)
  # line_spacing - desired line spacing (default: 2 * size)
  # word_spacing - desired word spacing (default: size)
  #
  # Returns a {Fz2D.Rect}.
  centerText: (ro, text, size=@size, line_spacing=size+size, word_spacing=size) ->
    m = @measureText(text, size, line_spacing, word_spacing)
    
    new Fz2D.Rect(ro.x + ((ro.w - m.w) >> 1),
                  ro.y + ((ro.h - m.h) >> 1)
                  ro.w,
                  ro.h)

  # Public: Measures text.
  #
  # text - text to measure
  # size - text size (default: font size)
  # line_spacing - desired line spacing (default: 2 * size)
  # word_spacing - desired word spacing (default: size)
  #
  # Returns a {Fz2D.Rect}.
  measureText: (text, size=@size, line_spacing=size+size, word_spacing=size) ->
    w = 0
    h = 0
    maxWidth = 0

    for c in text
      switch c
        when ' '
          w += word_spacing
          continue
        when '\n'
          maxWidth = w if w > maxWidth
          w = 0
          h += line_spacing
          continue
        when '\t'
          w += 3 * word_spacing
          continue

      w += size

    if w > 0 and maxWidth == 0
      maxWidth = w

    if maxWidth > 0 and h == 0
      h = size

    new Fz2D.Rect(0, 0, maxWidth, h)

  # Public: Draws Text.
  #
  # ctx - {Fz2D.Canvas}
  # text - text to measure
  # x - position on the X axis
  # y - position on the Y axis
  # size - text size (default: font size)
  # line_spacing - desired line spacing (default: 2 * size)
  # word_spacing - desired word spacing (default: size)
  #
  # Returns a last position.
  drawText: (ctx, text, x, y, size=@size, line_spacing=size+size, word_spacing=size) ->
    xx = x
    yy = y

    for c in text
      switch c
        when ' '
          xx += word_spacing
          continue
        when '\n'
          xx = x
          yy += line_spacing
          continue
        when '\t'
          xx += 3 * word_spacing
          continue
 
      char = @chars[c] || @invalid_char

      ctx.draw(@texture, char.x, char.y, char.w, char.h, xx, yy, size, size)

      xx += size

    xx
