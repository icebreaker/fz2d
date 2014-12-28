# Public: Joystick Button
class Fz2D.Plugins.Touch.TouchControlJoystickButton extends Fz2D.Plugins.Touch.TouchControl
  # Public: Fired on press.
  #
  # touch - Hash
  # input - {Fz2D.Input}
  pressed: (touch, input) ->
    @dy = 10
    for k, v of @_keys
      input.keys[v] = input.keys.pressed[v] = true

    null
