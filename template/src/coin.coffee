class Coin extends Fz2D.Entity
  constructor: (texture, texture_picked_up, sound) ->
    super(texture)
    @texture_picked_up = texture_picked_up
    @sound = sound

    picked_up_anim = @addAnimation('picked_up', texture_picked_up)
    picked_up_anim.onend = @kill

  oncollect: () ->
    # empty

  reset: (x, y) ->
    x += @bounds.hw if x?
    y += @bounds.hh if y?
    super

  kill: () =>
    if @is('picked_up') and not @solid
      super
      @play('_default', true)
      @solid = true
      @oncollect(@)
    else
      @play('picked_up')
      @sound.play()
      @solid = false

  clone: () ->
    c = new Coin(@texture, @texture_picked_up, @sound.clone())
    c.oncollect = @oncollect
    c
