class Menu extends Fz2D.Group
  constructor: (w, h, sprites) ->
    super(0, 0, w, h)

    @add(new Fz2D.Entity(sprites.getTexture('title')))
  
    font = new Fz2D.Font(sprites.getTexture('16x16_font'), null, ' ', 'Z')

    icons = sprites.getTexture('icons_left')

    cx = (w - icons.h) >> 1
    cy = (h - icons.h) >> 1

    button = new Fz2D.Gui.Button(cx, cy, "PLAY", font, null,
                                 icons.getSubTexture(0),
                                 icons.getSubTexture(2)
                                 icons.getSubTexture(1)
                                )
    button.onclick = () =>
      @onplay(@)

    @add(button)

    @add(new Fz2D.Gui.Mouse(sprites.getTexture('pointer')))

  onplay: (menu) ->
    # empty
