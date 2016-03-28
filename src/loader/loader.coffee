# Public: Loader
class Fz2D.Loader
  # Public: Static Hash of registered loaders.
  @Loaders: {}

  # Public: Constructor.
  #
  # game - {Fz2D.Game}
  constructor: (game) ->
    @loaded = 0
    @total = 0
    @pct = 0
    
    @visible = @alive = @exists = true

    # FIXME: do not hardcode these ...
    @w = 256
    @h = 24

    @x = (game.w - @w) >> 1 # center X
    @y = (game.h - @h) >> 1 # center Y

    @_outer = new Fz2D.Texture(game.fg, @w, @h)
    @_inner = new Fz2D.Texture(game.bg, @w, @h)

    @_timeout = new Fz2D.Timeout(400)
    @_timeout.onend = () =>
      @onload()

    @_files = {}
    @_loaders = {}

    for k, loader of Fz2D.Loader.Loaders
      _loader = new loader(game.path)

      _loader.onload = () =>
        if ++@loaded >= @total
          @pct = 1
          @_timeout.reset()

        console.log("Loaded: #{Math.ceil(@pct * 100)}%") if @pct > 0

      console.log("Registered loader #{k} for the `#{_loader.extension}` extension.")
      @_loaders[_loader.extension] = _loader

  # Public: On load(ed) callback.
  onload: () ->
    # empty

  # Public: Loads an asset.
  #
  # path - partial relative path
  #
  # Returns an instance of the asset.
  load: (path) ->
    return @_files[path] if @_files[path]?

    extension = path.split('.').pop()
    if extension?
      loader = @_loaders[extension]
      if loader?
        @total++
        @_files[path] = loader.load(path)
      else
        console.log("No loader registered for this `#{extension}` extension. Sorry :(")
        null
    else
      console.log("Ignoring `#{path}` because it has no extension. :(")
      null

  # Public: Draws loader on every frame.
  draw: (ctx) ->
    # FIXME: allow user to configure these borders
    ctx.draw(@_outer, 0, 0, @w, @h, @x, @y, @w, @h, @w/2, @h/2, 0.0, 1.0)
    ctx.draw(@_inner, 0, 0, @w-4, @h-4, @x+2, @y+2, @w-4, @h-4, (@w-4)/2, (@h-4)/2, 0.0, 1.0)
    ctx.draw(@_outer, 0, 0, @w-12, @h-12, @x+6, @y+6, @pct * (@w-12), @h-12, (@pct * (@w - 12) / 2), (@h - 12 / 2), 0.0, 1.0)

  # Public: Updates loader on every frame.
  update: (timer, input) ->
    @pct = @loaded / @total
    @_timeout.update(timer)

  # Public: Returns true if still loading.
  isLoading: () ->
    @loaded < @total
