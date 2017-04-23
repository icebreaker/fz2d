class ExitPost extends Fz2D.Entity
  constructor: (texture, texture_disappear, sound_appear, sound_disappear) ->
    super(texture.getSubTexture(0))
    @sound_appear = sound_appear
    @sound_disappear = sound_disappear

    appear_anim = @addAnimation('appear', texture)

    disappear_anim = @addAnimation('disappear', texture_disappear)
    disappear_anim.onend = @kill

  onexit: (exitpost) ->
    # empty

  show: () ->
    super
    if @is('_default')
      @sound_appear.play()
      @exists = true
      @play('appear')

  reset: () ->
    super
    @exists = false

  kill: () =>
    if @is('disappear')
      super
      @play('_default')
      @onexit(@)
    else if @is('appear')
      @sound_disappear.play() if @group and @group.alive
      @play('disappear')

  clone: () ->
    @
