# Public: Keyboard
class Fz2D.Input.Keyboard
  # Public: Constructor.
  constructor: () ->
    @update()

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
    @pressed = {}
