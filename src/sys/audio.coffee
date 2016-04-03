# Public: Audio
class Fz2D.Audio
  # Public: Maximum volume value.
  @MAX_VOLUME: 100.0
  # Public: Inverse of maximum volume value.
  @INV_MAX_VOLUME: 1.0 / @MAX_VOLUME

  # Public: Audio Formats.
  @FORMATS:
    'audio/ogg'   : 'ogg'
    'audio/aac'   : 'm4a'
    'audio/x-m4a' : 'm4a'
    'audio/wav'   : 'wav'

  # Public: Static "audio extension" property.
  @extension: ((audio, formats) ->
    for format, extension of formats
      if Fz2D.present(audio.canPlayType(format))
        console.log("Audio: #{format}")
        return extension

    console.log('No audio support :(')
    null
  )(new window.Audio(), @FORMATS)
  
  # Public: Static "supported" property.
  @supported: (() ->
    if Fz2D.noaudio?
      console.log('Audio support has been disabled :(')
      null
    else
      Audio.extension
  )()

  # Public: Relative path.
  src: null

  # Public: Constructor.
  # 
  # audio - {Fz2D.Audio} (default: null)
  constructor: (audio=null) ->
    if audio instanceof Fz2D.Audio
      @_native = audio._native.cloneNode(true)
    else
      @_native = new window.Audio()
      @_native.loop = false
      @_native.preload = true
      @_native.addEventListener 'loadedmetadata', () =>
        console.log("Loaded audio: #{@_native.src}")
        @onload(@)
      @_native.onerror = () =>
        console.log("Failed to load audio: #{@_native.src}")
        @onload(@)

  # Public: On load(ed) callback.
  #
  # audio - {Fz2D.Audio}
  onload: (audio) ->
    # empty

  # Public: Loads an audio.
  #
  # path - relative path
  load: (path) ->
    @src = path
    @_native.src = path
    @

  # Public: Play the audio.
  play: (looped) ->
    @_native.loop = looped || false
    @_native.play()
    @

  # Public: Replay the audio.
  replay: () ->
    @_native.currentTime = 0 if @_native.currentTime > 0
    @_native.play()
    @

  # Public: Pauses the audio.
  pause: () ->
    @_native.pause()
    @

  # Public: Stops the audio.
  stop: () ->
    @_native.pause()
    @_native.currentTime = 0 if @_native.currentTime > 0
    @

  # Public: Sets loop state.
  #
  # state - true or false
  setLoop: (state) ->
    @_native.loop = state
    @

  # Public: Sets volume.
  #
  # volume - number in the range of 0 to 100
  setVolume: (volume) ->
    @_native.volume = parseFloat(Fz2D.clamp(volume, 0.0, Fz2D.Audio.MAX_VOLUME) * Fz2D.Audio.INV_MAX_VOLUME)
    @

  # Public: Clones audio
  #
  # Returns a {Fz2D.Audio} pointing to the same audio.
  clone: () ->
    new Fz2D.Audio(@)

  # Public: Returns "native" audio instance.
  toAudio: () ->
    @_native
