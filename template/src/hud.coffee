class Hud extends Fz2D.Group
  constructor: (w, h, sprites) ->
    super(0, 0, w, h)
     
    font8 = new Fz2D.Font(sprites.getTexture('8x8_font'), null, '0', '9')
    
    @score = new Fz2D.Gui.Label('', w - 40, 15, font8)
    @add(@score)

    @add(new Fz2D.Entity(sprites.getTexture('spinning_coin_gold'), w - 60, 10))

    @exists = false

  reset: () ->
    super
    @score.setText('0')
