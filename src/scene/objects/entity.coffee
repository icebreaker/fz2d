# Public: Entity
class Fz2D.Entity extends Fz2D.Object
  # Public: Constructor.
  #
  # texture - {Fz2D.Texture}
  # x - position on the X axis
  # y - position on the Y axis
  # tag - name of the entity (default: '_default')
  constructor: (@texture, x, y, tag) ->
    w = @texture.w
    h = @texture.h

    w = h if (w % h == 0) and (w / h > 2)

    super(x, y, w, h, tag)

    @dx = 0
    @dy = 0
 
    @moving = false

    @animations = {}

    @addAnimation(@tag, @texture)
    @play(@tag, true)

  # Public: Clones entity.
  # Returns a {Fz2D.Entity}.
  clone: () ->
    instance          = new Fz2D.Entity(@texture, @x, @y, @tag)
    instance.dx       = @dx
    instance.dy       = @dy
    instance.moving   = @moving
    instance.solid    = @solid
    instance.visible  = @visible
    instance.alive    = @alive
    instance.exists   = @true
    instance.angle    = @angle
    instance.alpha    = @alpha
    instance.z        = @

    for tag, animation of @animations
      instance.animations[tag] = animation.clone()

    instance

  # Public: Returns true if the entity is out of bounds.
  isOutOfBounds: () ->
    @group and not Fz2D.overlap(@group, @)

  # Public: Plays a given animation.
  #
  # tag - name of the animation
  # looped - loop state (default: false)
  #
  # Returns a {Fz2D.Animation}.
  play: (tag, looped) ->
    @animation = @animations[tag]
    @animation.play(looped)
    @animation

  # Public: Stops the active animation.
  # Returns a {Fz2D.Animation}.
  stop: () ->
    @animation.stop()
    @animation

  # Public: Is active animation?
  #
  # tag - name of the animation
  #
  # Returns true if the current animation matches the given tag.
  is: (tag) ->
    @animation.tag == tag

  # Public: Returns the name of the active animation.
  active: () ->
    @animation.tag

  # Public: Adds an animation.
  #
  # tag - name of the animation
  # texture - {Fz2D.Texture}
  # count - number of frames (default: 1)
  # delay - delay in miliseconds between each frame (default: 1000.0 / count)
  # 
  # Returns a {Fz2D.Animation}.
  addAnimation: (tag, texture, count, delay) ->
    @animations[tag] = new Fz2D.Animation(tag, texture, count, delay)

  # Public: Draws entity on every frame.
  #
  # ctx - {Fz2D.Canvas}
  draw: (ctx) ->
    ctx.draw(@animation.texture,
             @animation.frame.x,
             @animation.frame.y,
             @animation.frame.w,
             @animation.frame.h,
             @x,
             @y,
             @w,
             @h,
             @bounds.hw,
             @bounds.hh
             @angle,
             @alpha)
    null

  # Public: Updates entity on every frame.
  #
  # timer - {Fz2D.Timer}
  # input - {Fz2D.Input}
  update: (timer, input) ->
    @animation.update(timer) unless @animation.ended

    if @moving
      @x += (@dx * timer.dt) | 0
      @y += (@dy * timer.dt) | 0

    null
