class Coin extends Fz2D.Entity
  constructor: (texture, texture_picked_up, sound) ->
    super(texture.getSubTexture(0))
    @texture_idle = texture
    @texture_picked_up = texture_picked_up
    @sound = sound

    picked_up_anim = @addAnimation('picked_up', texture_picked_up)
    picked_up_anim.onend = @kill

    @addAnimation('idle', texture)

  oncollect: () ->
    # empty

  reset: (x, y) ->
    x += @bounds.hw if x?
    y += @bounds.hh if y?
    super
    @solid = true
    @play('idle', true)

  kill: () =>
    if @is('picked_up') and not @solid
      super
      @play('idle', true)
      @solid = true
      @oncollect(@)
    else
      @play('picked_up')
      @sound.play() if @group and @group.alive
      @solid = false

  clone: () ->
    c = new Coin(@texture_idle, @texture_picked_up, @sound.clone())
    c.oncollect = @oncollect
    c
