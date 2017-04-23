class Player extends Fz2D.Entity
  Key = Fz2D.Input.Keyboard.Key

  constructor: (sprites, sound) ->
    super(sprites.getTexture('snipe_idle'), 50, 200)

    @addAnimation('idle_right', sprites.getTexture('snipe_blink_facing_right'))
    @addAnimation('idle_left', sprites.getTexture('snipe_blink_facing_left'))
    @addAnimation('run_right', sprites.getTexture('snipe_run_right'))
    @addAnimation('run_left', sprites.getTexture('snipe_run_left'))
    @addAnimation('jump_right', sprites.getTexture('snipe_jump_right'))
    @addAnimation('jump_left', sprites.getTexture('snipe_jump_left'))
    
    die_anim = @addAnimation('die', sprites.getTexture('snipe_die'))
    die_anim.onend = @kill

    @sound = sound

    # 'tighter' collision bounds ...
    @bounds.set(5, 5, 23, 27)

    @exists = false
    @moving = true
    @jumping = false
    @grounded = false

  clone: () ->
    @

  reset: (x, y) ->
    @ox ?= x
    @oy ?= y
    super(@ox, @oy)
    @solid = true
    @dx = 0.0
    @dy = 0.0
    @play('_default')

  kill: () =>
    if @is('die')
      super
      @solid = true
      @play('_default')
    else
      @solid = false
      @dx = 0.0
      @dy = 0.0
      @play('die')

  update: (timer, input) ->
    super

    return unless @solid

    if input.keys[Key.LEFT] and @x > 0
      @play('run_left', true) unless @is('run_left')
      @dx = -0.2
    else if input.keys[Key.RIGHT] and @x + @w < @group.w
      @play('run_right', true) unless @is('run_right')
      @dx = 0.2
    else
      if @is('run_left')
        @play('idle_left', true)
      else if @is('run_right')
        @play('idle_right', true)
      @dx = 0.0

    @dy += 0.1

    if (input.keys[Key.UP] or input.keys[Key.X]) and @grounded
      @dy = -1.0
      @jumping = true
      @grounded= false
      @sound.replay()
      return

    Fz2D.collide(@, @group, @collision)

  collision: (o1, o2) =>
    if o2 instanceof Coin
      o2.kill()
      return
    else if o2 instanceof ExitPost
      o1.kill()
      o2.kill()
      return

    result = Fz2D.getCollisionSide(o1, o2)

    if @jumping and @dy < 0.0
      if result & Fz2D.BOTTOM
        @dy = 0.0
        @jumping = false
    else if result & Fz2D.TOP
      o1.y = o2.y - o2.h
      @dy = 0.0
      @jumping = false
      @grounded = true
