# Public: Game
class Fz2D.Game
  # Public: Instantiates and executes the Game.
  #
  # opts - Hash of options (default: {})
  #
  # Returns a {Fz2D.Game}.
  @run: (opts={}) ->
    @instance ?= new @(opts)

  # Public: Constructor.
  #
  # opts - Hash of options (default: {})
  constructor: (opts={}) ->
    # Mixin opts
    for k, v of opts
      @[k] = v

    # Default background color
    @bg ?= Fz2D.BG

    # Default foreground color
    @fg ?= Fz2D.FG

    # Default canvas selector
    @selector ?= Fz2D.SELECTOR

    # Default assets path
    @path ?= Fz2D.PATH

    throw 'Game has invalid width and/or height :(' unless @w? and @h?
    throw 'Canvas is not supported by your browser :(' unless Fz2D.Renderer?
  
    @storage = new Fz2D.Storage()

    @_plugins = []

    if @plugins?
      for plugin in @plugins
        continue unless plugin.supported?

        instance = new plugin(@)
        @_plugins.push(instance) if typeof instance.update == 'function'

    @_timer  = new Fz2D.Timer()
    @_ctx    = new Fz2D.Renderer(@w, @h, @bg, @selector)
    
    @input   = new Fz2D.Input(@_ctx.toElement())
    @scene   = new Fz2D.Group(0, 0, @w, @h)

    @draw_call_count = 0

    @_loader  = new Fz2D.Loader(@)
    @_loader.onload = () =>
      @update(@_timer, @_input)
      @draw(@_ctx)

      @scene.remove(@_loader)
      @onload(@)

    @_loop()

    if @assets?
      @scene.add(@_loader)
      @_loadAssets(@assets)
    else
      @onload(@)

  # Public: Onload(ed) callback.
  #
  # game - {Fz2D.Game}
  onload: (game) ->
    # empty

  # Public: Loads an asset via the loader.
  #
  # path - partial relative path
  #
  # Returns an instance of the asset.
  load: (path) ->
    @scene.add(@_loader) unless @_loader.group?
    @_loader.load(path)

  # Public: Draws scene on every frame.
  #
  # ctx - {Fz2D.Canvas}
  draw: (ctx) ->
    @scene.draw(ctx)

  # Public: Updates scene on every frame.
  #
  # timer - {Fz2D.Timer}
  # input - {Fz2D.Input}
  update: (timer, input) ->
    @scene.update(timer, input)

  # Private: Load all assets recursively.
  _loadAssets: (assets) ->
    for k, url of assets
      if typeof url == 'object'
        @_loadAssets(url)
      else
        assets[k] = @_loader.load(url)

  # Private: Main Game Loop.
  _loop: () =>
    for plugin in @_plugins
      plugin.update(@_timer, @input)
 
    @update(@_timer, @input)

    @draw_call_count = @_ctx.draw_call_count

    @_ctx.clear()
    
    @draw(@_ctx)
    
    @_ctx.flush()

    @input.update()
    @_timer.update()

    requestAnimationFrame(@_loop)
