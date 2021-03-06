# Public: Timeout
class Fz2D.Timeout
  # Public: Constructor.
  #
  # delay - delay in miliseconds
  # loop - loop state (default: false)
  constructor: (@delay, @loop=false) ->
    @_dt = 0
    @visible = false
    @exists = true
    @alive = true

  # Public: On end callback.
  onend: () ->
    # empty

  # Public: Resets the timeout.
  reset: () ->
    @exists = true
    @alive = true
    @_dt = @delay
    @

  # Public: Kills the timeout.
  kill: () ->
    @exists = false
    @alive = false
    @_dt = 0
    @

  # Public: Updates timeout on every frame.
  #
  # timer - {Fz2D.Timer}
  update: (timer) ->
    if @_dt > 0 and ((@_dt -= timer.dt) <= 0)
      @onend(@)

      if @loop
        @reset()
      else
        @kill()

    null
