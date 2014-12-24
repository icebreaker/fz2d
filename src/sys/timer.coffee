# Public: Timer
class Fz2D.Timer
  # Public: Constructor.
  constructor: () ->
    @_start  = new Date()
    @_last   = new Date()
    @_prev   = new Date()
    @_frames = 0

    @fps    = 0
    @dt     = 0
    @ticks  = 0

  # Public: Updates timer on every frame.
  update: () ->
    now = new Date()

    @_frames++
    if now - @_prev > 1000
      @_prev    = now
      @fps      = @_frames
      @_frames  = 0

    @dt     = now - @_last
    @ticks  = now - @_start
    @_last  = now
