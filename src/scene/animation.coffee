# Public: Animation
class Fz2D.Animation
  # Public: Constructor.
  #
  # tag - name of the animation
  # texture - {Fz2D.Texture}
  # count - number of frames (default: 1)
  # delay - delay in miliseconds between each frame (default: 1000.0 / count)
  constructor: (@tag, @texture, @count, @delay) ->
    @ended = true

    if not @count? or @count < 1
      if (@texture.w % @texture.h == 0) and (@texture.w / @texture.h > 2)
        @count = @texture.w / @texture.h
      else
        @count = 1

    @delay ?= 1000 / @count

    w = @texture.w / @count

    @frames = []
    
    for i in [0..@count-1]
      @frames.push(new Fz2D.Rect((@texture.x + (i * w)), @texture.y, w, @texture.h))

    @frame = @frames[0]

    @_index = 0
    @_dt    = 0
    @_loop  = false

    # Stub out .play() if we got only one frame <3
    if @count == 1
      @play = () =>
        @

  # Public: On end(ed) callback.
  #
  # animation - {Fz2D.Animation}
  onend: (animation) ->
    # empty

  # Public: Plays the animation.
  #
  # looped - loop state (default: false)
  play: (looped) ->
    @ended  = false
    @frame  = @frames[0]
    @_index = 0
    @_dt    = 0
    @_loop  = looped || false
    @

  # Public: Stops the animation.
  stop: () ->
    @ended = true
    @

  # Public: Updates animation on every frame.
  #
  # timer - {Fz2D.Timer}
  # input - {Fz2D.Input}
  update: (timer, input) ->
    return null if @ended

    @_dt += timer.dt
    return null if @_dt < @delay

    @frame = @frames[@_index]

    if ++@_index == @count
      if @_loop
        @_index = 0
      else
        --@_index

      if @ended = (@_index > 0)
        @onend(@)

    @_dt = 0

    null
