// Generated by CoffeeScript 1.12.3
var Game, MovingSprite, RandomSprite,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

MovingSprite = (function(superClass) {
  extend(MovingSprite, superClass);

  function MovingSprite() {
    MovingSprite.__super__.constructor.apply(this, arguments);
    this.moving = true;
    this.dx = 0.2;
    this.dy = 0.2;
  }

  MovingSprite.prototype.update = function(timer, input) {
    MovingSprite.__super__.update.apply(this, arguments);
    if (this.x <= 0) {
      this.x = 0;
      this.dx = -this.dx;
    }
    if (this.x + this.w >= this.group.w) {
      this.x = this.group.w - this.w;
      this.dx = -this.dx;
    }
    if (this.y <= 0) {
      this.y = 0;
      this.dy = -this.dy;
    }
    if (this.y + this.h >= this.group.h) {
      this.y = this.group.h - this.h;
      return this.dy = -this.dy;
    }
  };

  return MovingSprite;

})(Fz2D.Entity);

RandomSprite = (function(superClass) {
  extend(RandomSprite, superClass);

  function RandomSprite() {
    RandomSprite.__super__.constructor.apply(this, arguments);
    this.rand = new Fz2D.Random();
    this.dt = 0;
  }

  RandomSprite.prototype.update = function(timer, input) {
    RandomSprite.__super__.update.apply(this, arguments);
    this.dt += timer.dt;
    if (this.dt > 60) {
      this.dt = 0;
      this.x = this.rand.next(this.group.w - this.w);
      return this.y = this.rand.next(this.group.h - this.h);
    }
  };

  return RandomSprite;

})(Fz2D.Entity);

Game = (function(superClass) {
  extend(Game, superClass);

  function Game() {
    return Game.__super__.constructor.apply(this, arguments);
  }

  Game.prototype.w = window.innerWidth;

  Game.prototype.h = window.innerHeight;

  Game.prototype.assets = {
    sprites: 'sprites.atl',
    night_adventure: 'night_adventure.ogg'
  };

  Game.prototype.plugins = [Fz2D.Plugins.GitHub, Fz2D.Plugins.Stats, Fz2D.Plugins.Console];

  Game.prototype.github = {
    username: 'icebreaker',
    repository: 'fz2d'
  };

  Game.prototype.onload = function(game) {
    var assets, i, j, name, rand, scene, sprites;
    assets = game.assets;
    scene = game.scene;
    sprites = assets.sprites;
    rand = new Fz2D.Random();
    for (i = j = 1; j <= 1023; i = ++j) {
      name = rand.nextBool() ? 'red' : 'yellow';
      scene.add(new RandomSprite(sprites.getTexture(name)));
    }
    scene.add(new MovingSprite(sprites.getTexture('red')));
    return assets.night_adventure.play(true);
  };

  return Game;

})(Fz2D.Game);

Game.run();