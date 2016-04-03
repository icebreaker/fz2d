# Public: Remote Debug
class Fz2D.Plugins.RemoteDebug extends Fz2D.Plugin
  # Public: Allowed in debug mode only.
  @supported: Fz2D.debug

  # Public: Constructor.
  #
  # game - {Fz2D.Game}
  constructor: (game) ->
    _loop = game._loop

    game._loop = () =>
      try
        _loop()
      catch e
        console.log(e)
