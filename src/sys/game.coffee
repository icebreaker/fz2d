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
        @registerPlugin(new plugin(@)) if plugin.supported?

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

      @loaded = true
      @_onloadPlugins()
      @onload(@)

    @_loop()

    if @assets?
      @scene.add(@_loader)
      @_loadAssets(@assets)
    else
      @loaded = true
      @_onloadPlugins()
      @onload(@)

  # Public: Registers a plugin dynamically.
  #
  # plugin - {Fz2D.Plugin}
  registerPlugin: (plugin) ->
    if typeof plugin.onload == 'function'
      @_plugins_onloadable.push(plugin) unless plugin in @_plugins_onloadable

    if typeof plugin.update == 'function'
      @_plugins_updateable.push(plugin) unless plugin in @_plugins_updateable

    if typeof plugin.draw == 'function'
      @_plugins_drawable.push(plugin) unless plugin in @_plugins_drawable

    plugin

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
    unless @_loader.group?
      @loaded = false
      @scene.add(@_loader)

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
      if typeof url == 'object'
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

    @_ctx.clear()
    
    @draw(@_ctx)

    for plugin in @_plugins_drawable
      plugin.draw(@_ctx, @)

    @_ctx.flush()

    @input.update()
    @_timer.update()

    requestAnimationFrame(@_loop)
