# Public: Base Loader
class Fz2D.Loader.Base
  # Public: Extension the loader responds to.
  extension: null
  # Public: Relative asset root path.
  path: null

  # Public: Constructor.
  #
  # path - relative assets root path
  constructor: (path) ->
    @_path = "#{path}/#{@path}"

  # Public: Expands a `partial` relative path into a `full` relative path.
  #
  # path - partial relative path to expand
  # extension - preferred extension (optional)
  #
  # Returns the expanded path.
  expand: (path, extension=null) ->
    if extension?
      "#{@_path}/#{path.slice(0, path.length - @extension.length)}#{extension}"
    else
      "#{@_path}/#{path}"

  # Public: Loads an asset.
  #
  # path - partial relative path
  #
  # Returns an instance of the asset.
  load: (path) ->
    throw 'load() must be implemented by each loader, and must call onload(asset)'

  # Public: On load(ed) callback.
  #
  # asset - the loaded asset
  onload: (asset) ->
    # empty
