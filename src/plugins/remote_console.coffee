# Public: Remote Console
class Fz2D.Plugins.RemoteConsole extends Fz2D.Plugin
  # Public: Allowed in debug mode only.
  @supported: Fz2D.debug

  # Public: Constructor.
  #
  # game - {Fz2D.Game}
  constructor: (game) ->
    @_setup_before()
    document.addEventListener 'io', @_setup_after

  # Private: Patch console before io is ready.
  _setup_before: () ->
    @_args = []
    @_log = window.console.log
    window.console.log = () =>
      @_args.push(arguments)

  # Private: Path console after io is ready.
  _setup_after: () =>
    window.console.log = () =>
      @_log.apply(window.console, arguments)

      args = []

      for arg in arguments
        if typeof arg == 'object'
          args.push(JSON.stringify(arg, null, ' '))
        else
          args.push(arg)

      @socket.emit('log', args: args)

    @socket = window.io.connect(window.location.url)
    for args in @_args
      window.console.log.apply(window.console, args)
