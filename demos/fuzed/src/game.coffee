class Game extends Fz2D.Game
  w: 640
  h: 480

  assets:
    sprites: 'sprites.atl'
    header: 'header.png'
    map: 'level.json'
    pickup: 'pickup.ogg'
    jump: 'jump.ogg'
    exitpost_appear: 'exitpost_appear.ogg'
    exitpost_disappear: 'exitpost_disappear.ogg'
    winter_snow: 'winter_snow.ogg'
  
  plugins: [
    Fz2D.Plugins.Touch,
    Fz2D.Plugins.GitHub,
    Fz2D.Plugins.Stats
  ]

  github:
    username: 'icebreaker'
    repository: 'fz2d'

  ga:
    id: 'UA-3042007-2'
  
  onload: (game) ->
    game.input.mouse.hide()

    assets = game.assets
    scene = game.scene

    sprites = assets.sprites
    tiles = sprites.getTexture('tiles')

    assets.winter_snow.play(true)

    menu = new Menu(scene.w, scene.h, sprites)
    hud = new Hud(scene.w, scene.h, sprites)

    background = new Fz2D.Entity(sprites.getTexture('bg'), 0, 0)
    background.exists = false

    exit_post = new ExitPost(sprites.getTexture('exitpost_appear'),
                             sprites.getTexture('exitpost_disappear'),
                             assets.exitpost_appear,
                             assets.exitpost_disappear)

    coin = new Coin(sprites.getTexture('spinning_coin_gold'), sprites.getTexture('picked_up'), assets.pickup)
    coin.oncollect = (c) ->
      hud.score.inc()
      # If we used '.tag' with no custom classes, 
      # we could perform these operations ...byTag() <3
      # Also we could have stored the coins in a separate group
      # in which case, we could just do hasAlive() without any
      # type information.
      unless c.group.hasAliveByClass(Coin)
        exit_post.reset()

    player = new Player(sprites, assets.jump)

    map = new Map(scene.x, scene.y, scene.w, scene.h)
    map.addType(1, new Fz2D.Entity(tiles.getSubTexture(30, 32), 0, 0))
    map.addType(2, new Fz2D.Entity(tiles.getSubTexture(31, 32), 0, 0))
    map.addType(3, new Fz2D.Entity(tiles.getSubTexture(5, 32), 0, 0))
    map.addType(4, exit_post)
    map.addType(5, coin)
    map.addType(6, player)

    map.load(assets.map)

    exit_post.onexit = ->
      hud.kill()
      map.kill()
      background.kill()
      menu.reset()

    menu.onplay = ->
      menu.kill()
      background.reset()
      map.reset()
      hud.reset()

    scene.add(menu)
    scene.add(background)
    scene.add(map)
    scene.add(hud)

Game.run()
