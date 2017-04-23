class MovingSprite extends Fz2D.Entity
  constructor: () ->
    super
    @moving = true
    @dx = 0.2
    @dy = 0.2

  update: (timer, input) ->
    super

    if @x <= 0
      @x = 0
      @dx = -@dx

    if @x + @w >= @group.w
      @x = @group.w - @w
      @dx = -@dx

    if @y <= 0
      @y = 0
      @dy = -@dy

    if @y + @h >= @group.h
      @y = @group.h - @h
      @dy = -@dy
