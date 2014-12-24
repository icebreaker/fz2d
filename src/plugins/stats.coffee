# Public: Stats
class Fz2D.Plugins.Stats
  # Public: Allowed in stats mode only.
  @supported: Fz2D.stats

  # Public: Styles.
  styles:
    backgroundColor: 'rgba(0, 0, 0, 0.5)'
    padding: '8px'
    position: 'absolute'
    left: 0
    top: 0
    margin: '20px'
    border: '2px solid #B00000'
    font: '28px Arial'
    color: '#B00000'
    zIndex: 999
 
  # Public: Constructor.
  #
  # game - {Fz2D.Game}
  constructor: (game) ->
    @_game = game

    @_div = Fz2D.createEl('div', {}, @styles)
    Fz2D.appendEl(@_div)

    @_dt = 1111

  # Public: Updates stats on every frame.
  update: (timer, input) ->
    if @_dt > 1000
      @_div.innerHTML = "FPS: #{timer.fps} <br/> CTX: #{Fz2D.Renderer.supported} <br/> DRW: #{@_game.draw_call_count} <br/> AO: #{Fz2D.Audio.supported}"
      @_dt = 0
    else
      @_dt += timer.dt
