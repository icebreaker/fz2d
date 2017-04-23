class Game extends Fz2D.Game
  w: window.innerWidth
  h: window.innerHeight

  assets:
    sprites: 'sprites.atl'
    night_adventure: 'night_adventure.ogg'
  
  plugins: [
    Fz2D.Plugins.GitHub,
    Fz2D.Plugins.Stats,
    Fz2D.Plugins.Console
  ]

  github:
    username: 'icebreaker'
    repository: 'fz2d'

  onload: (game) ->
    assets = game.assets
    scene = game.scene

    sprites = assets.sprites

    rand = new Fz2D.Random()

    for i in [1..1023]
      name = if rand.nextBool() then 'red' else 'yellow'
      scene.add(new RandomSprite(sprites.getTexture(name)))

    scene.add(new MovingSprite(sprites.getTexture('red')))

    assets.night_adventure.play(true)

Game.run()
