# Public: Touch
class Fz2D.Plugins.Touch extends Fz2D.Plugin
  Key = Fz2D.Input.Keyboard.Key

  # Public: Allowed in 'touch' mode only.
  @supported: Fz2D.touch

  # Public: Default touch control configuration.
  config:
    left:
      type: 'joystick'
      radius: 50
      keys:
        right: Key.RIGHT
        left: Key.LEFT
    right:
      type: 'button'
      radius: 50
      keys:
        up: Key.UP

  # Public: Constructor.
  #
  # game - {Fz2D.Game}
  constructor: (game) ->
    @_controls = []

    # Set default config if user configuration is missing
    game.touch ?= @config

    if left = game.touch.left
      left.radius ?= 50
      left.left = true
      @_controls.push(@_create_control(game.w, game.h, left))
 
    if right = game.touch.right
      right.radius ?= 50
      @_controls.push(@_create_control(game.w, game.h, right))
    
  # Public: Updates controls on every frame.
  #
  # timer - {Fz2D.Timer}
  # input - {Fz2D.Input}
  update: (timer, input) ->
    for control in @_controls
      control.update(timer, input)

  # Public: Draws controls on every frame.
  #
  # ctx - {Fz2D.Canvas}
  draw: (ctx) ->
    for control in @_controls
      control.draw(ctx)

  # Private: Creates a control based on its type.
  #
  # w - game width
  # h - game height
  # config - configuration hash
  _create_control: (w, h, config) ->
    switch config.type
      when 'joystick'
        new Fz2D.Plugins.Touch.TouchControlJoystick(w, h, config)
      when 'button'
        new Fz2D.Plugins.Touch.TouchControlJoystickButton(w, h, config)
      else
        throw 'Invalid touch control configuration type'
