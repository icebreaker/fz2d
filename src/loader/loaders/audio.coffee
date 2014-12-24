# Public: Audio Loader
class Fz2D.Loader.Loaders.Audio extends Fz2D.Loader.Base
  # Public: Respond to '.ogg' audio.
  extension: 'ogg'
  # Public: Relative 'audio' root path. 
  path: 'sounds'

  # Public: Loads an 'audio' asset.
  #
  # url - relative partial path
  #
  # Returns a {Fz2D.Audio}.
  load: (path) ->
    audio = new Fz2D.Audio()
 
    if Fz2D.Audio.supported?
      audio.onload = () =>
        @onload(audio)
      audio.load(@expand(path, Fz2D.Audio.extension))
    else
      @onload(audio)

    audio
