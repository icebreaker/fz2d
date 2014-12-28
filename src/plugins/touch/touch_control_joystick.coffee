class Fz2D.Plugins.Touch.TouchControlJoystick extends Fz2D.Plugins.Touch.TouchControl
  # Public: Fired on move.
  #
  # touch - Hash
  # input - {Fz2D.Input}
  moved:(touch, input) ->
    # FIXME: do not check on every move
    if @_keys.left? and @_keys.right?
      dx = touch.offsetX - @cx
      dir = dx / 50
      if dir < 0
        @dx = -10
        input.keys[@_keys.left]  = input.keys.pressed[@_keys.left]  = true
        input.keys[@_keys.right] = input.keys.pressed[@_keys.right] = false
      else if dir > 0
        @dx = 10
        input.keys[@_keys.left]  = input.keys.pressed[@_keys.left]  = false
        input.keys[@_keys.right] = input.keys.pressed[@_keys.right] = true
      else
        @dx = 0

    if @_keys.up? and @_keys.down?
      dy = touch.offsetY - @cy
      dir = dy / 50
      if dir < 0
        @dy = -10
        input.keys[@_keys.up]   = input.keys.pressed[@_keys.up]   = true
        input.keys[@_keys.down] = input.keys.pressed[@_keys.down] = false
      else if dir > 0
        @dy = 10
        input.keys[@_keys.up]   = input.keys.pressed[@_keys.up]   = false
        input.keys[@_keys.down] = input.keys.pressed[@_keys.down] = true
      else
        @dy = 0

    null
