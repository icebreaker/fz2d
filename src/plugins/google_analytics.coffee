# Public: Google Analytics
class Fz2D.Plugins.GoogleAnalytics
  # Public: Allowed in production mode only.
  @supported: Fz2D.production

  # Public: Tracks an event for a given account id.
  #
  # id - Google Analytics Account Id
  # event - event array with options (default: ['_trackPageview'])
  #
  # Returns nothing.
  @track: (id, event=['_trackPageview']) ->
    if window._gaq
      window._gaq.push(event)
      return

    window._gaq = []
    window._gaq.push(['_setAccount', id])
    window._gaq.push(event)

    ga = Fz2D.createEl('script', type: 'text/javascript', async: true)

    if Fz2D.https?
      ga.src = 'https://ssl.google-analytics.com/ga.js'
    else
      ga.src = 'http://www.google-analytics.com/ga.js'

    script = document.getElementsByTagName('script')[0]
    script.parentNode.insertBefore(ga, script)

  # Public: Constructor.
  #
  # game - {Fz2D.Game}
  constructor: (game) ->
    # FIXME: check if ga is a hash
    Fz2D.GoogleAnalytics.track(game.ga.id, game.ga.event) if game.ga? and game.ga.id?
