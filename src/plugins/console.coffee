# Public: Console
class Fz2D.Plugins.Console
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
    border: '2px solid #B00000'
    font: '18px Arial'
    color: '#B00000'
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
        if typeof arg == 'object'
          text.push(JSON.stringify(arg, null, ' '))
        else
          text.push(arg)

      div = Fz2D.createEl('div')
      div.innerHTML = text.join(' ')

      @_div.appendChild(div)
      @_div.scrollTop = @_div.scrollHeight
