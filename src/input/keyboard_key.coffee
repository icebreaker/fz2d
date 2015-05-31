# Public: Keyboard Keys
class Fz2D.Input.Keyboard.Key
  # Public: Maximum Number of Keys.
  @MAX = 256

  # Public: No Key.
  @NONE = 0

  for c in ['A'.charCodeAt(0)..'Z'.charCodeAt(0)]
    @[String.fromCharCode(c)] = c

  # Public: Enter Key.
  @ENTER  = 13
  # Public: Escape Key.
  @ESC    = 27
  # Public: Space Key.
  @SPACE  = 32
  # Public: Left Arrow.
  @LEFT   = 37
  # Public: Up Arrow.
  @UP     = 38
  # Public: Right Arrow.
  @RIGHT  = 39
  # Public: Down Arrow.
  @DOWN   = 40
