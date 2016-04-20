class Game extends Fz2D.Game
  w: window.innerWidth
  h: window.innerHeight

  assets:
    sprites: 'sprites.atl'
    night_adventure: 'night_adventure.ogg'
  
  plugins: [
    Fz2D.Plugins.Touch,
    Fz2D.Plugins.GitHub,
    Fz2D.Plugins.Stats
  ]

  github:
    username: 'icebreaker'
    repository: 'fz2d'

  onload: (game) ->
    assets = game.assets
    scene = game.scene

    sprites = assets.sprites
   
    logo = sprites.getTexture('fz2d')

    x = (game.w - logo.w) >> 1
    y = (game.h - logo.h) >> 1

    scene.add(new Fz2D.Entity(logo, x, y))

    assets.night_adventure.play(true)

Game.run()
