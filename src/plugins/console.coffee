# Public: Console
class Fz2D.Plugins.Console extends Fz2D.Plugin
  # Public: Allowed in debug mode only.
  @supported: Fz2D.debug

  # Public: Styles.
  styles:
    backgroundColor: 'rgba(0, 0, 0, 0.5)'
    width: window.innerWidth - 60
    height: '100px'
    padding: '8px'
    position: 'absolute'
    bottom: 0
    right: 0
    margin: '20px'
    border: "2px solid #{Fz2D.FG}"
    font: '18px Arial'
    color: Fz2D.FG
    overflow: 'auto'
    zIndex: 999

  # Public: Constructor.
  #
  # game - {Fz2D.Game}
  constructor: (game) ->
    @_div = Fz2D.createEl('div', {}, @styles)
    Fz2D.appendEl(@_div)

    window.console ?= {}
    window.console.log = () =>
      text = []

      for arg in arguments
        if Fz2D.object(arg)
          text.push(JSON.stringify(arg, null, ' '))
        else
          text.push(arg)

      div = Fz2D.createEl('div')
      div.innerHTML = text.join(' ')

      @_div.appendChild(div)
      @_div.scrollTop = @_div.scrollHeight
