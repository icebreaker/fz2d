global.setup_browser = ->
  global.location =
    href: 'http://127.0.0.1:3000/?lola=girl&sam=simon'
    protocol: 'http:'
    hostname: '127.0.0.1'
    port: '3000'
  global.navigator =
    userAgent: 'Chrome/41.0.2251.0'

  global.document = {}
  global.window = global

global.setup_browser()
