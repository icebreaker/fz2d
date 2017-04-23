class RandomSprite extends Fz2D.Entity
  constructor: () ->
    super
    @rand = new Fz2D.Random()
    @dt = 0

  update: (timer, input) ->
    super

    @dt += timer.dt

    if @dt > 60
      @dt = 0
      @x = @rand.next(@group.w - @w)
      @y = @rand.next(@group.h - @h)
