# Public: GitHub 'Fork Me' Ribbon
class Fz2D.Plugins.GitHub extends Fz2D.Plugin
  # Public: Allowed in production mode only.
  @supported: (Fz2D.production || Fz2D.github)

  # Public: Available ribbon colors.
  colors:
    'red'     : 'aa0000'
    'green'   : '007200'
    'darkblue': '126121'
    'orange'  : 'ff7600'
    'gray'    : '6d6d6d'
    'white'   : 'ffffff'

  # Public: Available ribbon positions.
  positions: ['left', 'right']

  # Public: Constructor.
  #
  # game - {Fz2D.Game}
  constructor: (game) ->
    # FIXME: check if github is a hash
    return unless game.github?

    config = game.github
    config.color = 'red' unless config.color of @colors
    config.position = 'right' unless config.position in @positions

    @_createRibbon(config.username, config.repository, config.color, config.position)

  # Public: Creates a 'Fork Me' ribbon.
  #
  # username - GitHub username
  # repository - GitHub repository
  # color - Ribbon color
  # position - Ribbon position
  #
  # Returns HTML DOM element.
  _createRibbon: (username, repository, color, position) ->
    a = Fz2D.createEl('a', href: "https://github.com/#{username}/#{repository}", target: '_blank')

    image = new Image()
    image.alt = 'Fork me on GitHub'
    image.src = "https://s3.amazonaws.com/github/ribbons/forkme_#{position}_#{color}_#{@colors[color]}.png"

    Fz2D.setStyleEl(image, { position: 'absolute', top: 0, border: 0, zIndex: 999  })

    if position == 'left'
      Fz2D.setStyleEl(image, left: 0)
    else
      Fz2D.setStyleEl(image, right: 0)

    Fz2D.appendEl(image, a)
    Fz2D.appendEl(a)

    a
