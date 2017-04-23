# Public: Stats
class Fz2D.Plugins.Stats extends Fz2D.Plugin
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
    border: "2px solid #{Fz2D.FG}"
    font: '28px Arial'
    color: Fz2D.FG
    zIndex: 999
 
  # Public: Constructor.
  #
  # game - {Fz2D.Game}
  constructor: (game) ->
    @_game = game

    @_div = Fz2D.createEl('div', {}, @styles)
    Fz2D.appendEl(@_div)

    @_dt = 1001

  # Public: Updates stats on every frame.
  update: (timer, input) ->
    if @_dt > 1000
      @_div.innerHTML = "FPS: #{Math.min(timer.fps, 60)} <br/>
                         Renderer: #{Fz2D.Renderer.supported} <br/>
                         Audio: #{Fz2D.Audio.supported} <br/>
                         Draw Calls: #{@_game.draw_call_count} <br/>
                         GPU Draw Calls: #{@_game.flush_call_count}"
      @_dt = 0
    else
      @_dt += timer.dt
