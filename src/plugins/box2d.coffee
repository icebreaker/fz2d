# Public: Box2D
class Fz2D.Plugins.Box2D extends Fz2D.Plugin
  # Public: Allowed only if Box2D is loaded.
  @supported: (()->
    'supported' if window.Box2D?
  )()

  # Public: Constructor.
  #
  # game - {Fz2D.Game}
  constructor: (game) ->
    @_world = game.world = new Box2D.World()

  # Public: Updates Box2D on every frame.
  #
  # timer - {Fz2D.Timer}
  # input - {Fz2D.Input}
  update: (timer, input) ->
    @_world.update(timer)
