# Public: Keyboard
class Fz2D.Input.Keyboard
  # Public: Constructor.
  constructor: () ->
    @pressed = {}

    for i in [0..Fz2D.Input.Keyboard.Key.MAX]
      @[i] = @pressed[i] = false

    if window.event?
      window.onkeydown = (e) =>
        @[e.which] = @pressed[e.which] = true

      window.onkeyup = (e) =>
        @[e.which] = @pressed[e.which] = false
    else
      window.onkeydown = (e) =>
        @[e.keyCode] = @pressed[e.keyCode] = true

      window.onkeyup = (e) =>
        @[e.keyCode] = @pressed[e.keyCode] = false
  
  # Public: Updates keyboard state on every frame.
  update: () ->
    for i in [0..Fz2D.Input.Keyboard.Key.MAX]
      @pressed[i] = false

    null
