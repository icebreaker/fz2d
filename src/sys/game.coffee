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

    @_plugins_onloadable = []
    @_plugins_updateable = []
    @_plugins_drawable = []

    if @plugins?
      for plugin in @plugins
        if plugin.supported?
          @registerPlugin(new plugin(@))
          console.log("Plugin: #{plugin.getName()} << enabled >>")
        else
          console.log("Plugin: #{plugin.getName()} << not supported or is disabled in the current environment >>")

    @_timer  = new Fz2D.Timer()
    @_ctx    = new Fz2D.Renderer(@w, @h, @bg, @selector)
    
    @input   = new Fz2D.Input(@_ctx.toElement())
    @scene   = new Fz2D.Group(0, 0, @w, @h)

    @draw_call_count = 0
    @flush_call_count = 0

    @_loader  = @scene.add(new Fz2D.Loader(@))
    @_loader.onload = () =>
      @update(@_timer, @_input)
      @draw(@_ctx)

      @scene.remove(@_loader)

      @loaded = true
      @_onloadPlugins()
      @onload(@)

    @_loop()

    if Fz2D.empty(@assets)
      @_loader.complete()
    else
      @_loadAssets(@assets)

  # Public: Registers a plugin dynamically.
  #
  # plugin - {Fz2D.Plugin}
  registerPlugin: (plugin) ->
    if Fz2D.callable(plugin.onload)
      @_plugins_onloadable.push(plugin) unless plugin in @_plugins_onloadable

    if Fz2D.callable(plugin.update)
      @_plugins_updateable.push(plugin) unless plugin in @_plugins_updateable

    if Fz2D.callable(plugin.draw)
      @_plugins_drawable.push(plugin) unless plugin in @_plugins_drawable

    plugin

  # Public: Onload(ed) callback.
  #
  # game - {Fz2D.Game}
  onload: (game) ->
    # empty

  # Public: Loads one or more asset via the loader.
  #
  # path - one or more partial relative paths
  #
  # Returns an instance of the asset.
  load: (path) ->
    return if Fz2D.empty(path)

    if not @_loader.group?
      @loaded = false
      @scene.add(@_loader)

    if Fz2D.enumerable(path)
      @_loadAssets(path)
    else
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

  # Private: Call onload on all onloadable plugins.
  _onloadPlugins: () ->
    unless @_plugins_onloaded
      for plugin in @_plugins_onloadable
        plugin.onload(@)

      @_plugins_onloaded = true
    
    null

  # Private: Load all assets recursively.
  _loadAssets: (assets) ->
    for k, url of assets
      if Fz2D.enumerable(url)
        @_loadAssets(url)
      else
        assets[k] = @_loader.load(url)

    null

  # Private: Main Game Loop.
  _loop: () =>
    for plugin in @_plugins_updateable
      plugin.update(@_timer, @input, @)
 
    @update(@_timer, @input)

    @draw_call_count = @_ctx.draw_call_count
    @flush_call_count = @_ctx.flush_call_count

    @_ctx.clear()
    
    @draw(@_ctx)

    for plugin in @_plugins_drawable
      plugin.draw(@_ctx, @)

    @_ctx.flush()

    @input.update()
    @_timer.update()

    requestAnimationFrame(@_loop)
