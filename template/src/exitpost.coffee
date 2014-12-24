class ExitPost extends Fz2D.Entity
  constructor: (texture, texture_disappear, sound_appear, sound_disappear) ->
    super(texture.getSubTexture(0))
    @sound_appear = sound_appear
    @sound_disappear = sound_disappear

    appear_anim = @addAnimation('appear', texture)

    disappear_anim = @addAnimation('disappear', texture_disappear)
    disappear_anim.onend = @kill

    @hidden = false

  onexit: (exitpost) ->
    # empty

  reset: () ->
    super
    
    @hidden = !@hidden
    @exists = @hidden

    if @exists
      @sound_appear.play() unless @is('_default')
      @play('appear')

  kill: () =>
    if @is('disappear')
      super
      @onexit(@)
    else
      @sound_disappear.play()
      @play('disappear')

  clone: () ->
    @
