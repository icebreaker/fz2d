# Public: Timeout
class Fz2D.Timeout
  # Public: Constructor.
  constructor: () ->
    @_dt = 0

  # Public: Sets the timeout delay.
  #
  # delay - timeout delay (in ms)
  set: (delay) ->
    @_dt = delay

  # Public: On end callback.
  onend: () ->
    # empty

  # Public: Updates timeout on every frame.
  #
  # timer - {Fz2D.Timer}
  update: (timer) ->
    if @_dt > 0 and ((@_dt -= timer.dt) <= 0)
      @onend()
