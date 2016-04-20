// Generated by CoffeeScript 1.10.0
var Coin, ExitPost, Game, Hud, Map, Menu, Player,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Coin = (function(superClass) {
  extend(Coin, superClass);

  function Coin(texture, texture_picked_up, sound) {
    var picked_up_anim;
    Coin.__super__.constructor.call(this, texture);
    this.texture_picked_up = texture_picked_up;
    this.sound = sound;
    picked_up_anim = this.addAnimation('picked_up', texture_picked_up);
    picked_up_anim.onend = (function(_this) {
      return function() {
        return _this.kill();
      };
    })(this);
  }

  Coin.prototype.oncollect = function() {};

  Coin.prototype.reset = function(x, y) {
    if (x != null) {
      x += this.bounds.hw;
    }
    if (y != null) {
      y += this.bounds.hh;
    }
    return Coin.__super__.reset.apply(this, arguments);
  };

  Coin.prototype.kill = function() {
    if (this.is('picked_up') && !this.solid) {
      Coin.__super__.kill.apply(this, arguments);
      this.play('_default', true);
      this.solid = true;
      return this.oncollect(this);
    } else {
      this.play('picked_up');
      if (this.group && this.group.alive) {
        this.sound.play();
      }
      return this.solid = false;
    }
  };

  Coin.prototype.clone = function() {
    var c;
    c = new Coin(this.texture, this.texture_picked_up, this.sound.clone());
    c.oncollect = this.oncollect;
    return c;
  };

  return Coin;

})(Fz2D.Entity);

ExitPost = (function(superClass) {
  extend(ExitPost, superClass);

  function ExitPost(texture, texture_disappear, sound_appear, sound_disappear) {
    this.kill = bind(this.kill, this);
    var appear_anim, disappear_anim;
    ExitPost.__super__.constructor.call(this, texture.getSubTexture(0));
    this.sound_appear = sound_appear;
    this.sound_disappear = sound_disappear;
    appear_anim = this.addAnimation('appear', texture);
    disappear_anim = this.addAnimation('disappear', texture_disappear);
    disappear_anim.onend = this.kill;
    this.hidden = false;
  }

  ExitPost.prototype.onexit = function(exitpost) {};

  ExitPost.prototype.reset = function() {
    ExitPost.__super__.reset.apply(this, arguments);
    this.hidden = !this.hidden;
    this.exists = this.hidden;
    if (this.exists) {
      if (!this.is('_default')) {
        this.sound_appear.play();
      }
      return this.play('appear');
    }
  };

  ExitPost.prototype.kill = function() {
    if (this.is('disappear')) {
      ExitPost.__super__.kill.apply(this, arguments);
      return this.onexit(this);
    } else {
      if (this.group && this.group.alive) {
        this.sound_disappear.play();
      }
      return this.play('disappear');
    }
  };

  ExitPost.prototype.clone = function() {
    return this;
  };

  return ExitPost;

})(Fz2D.Entity);

Hud = (function(superClass) {
  extend(Hud, superClass);

  function Hud(w, h, sprites) {
    var font8;
    Hud.__super__.constructor.call(this, 0, 0, w, h);
    font8 = new Fz2D.Font(sprites.getTexture('8x8_font'), null, '0', '9');
    this.score = new Fz2D.Gui.Label('', w - 40, 15, font8);
    this.add(this.score);
    this.add(new Fz2D.Entity(sprites.getTexture('spinning_coin_gold'), w - 60, 10));
    this.exists = false;
  }

  Hud.prototype.reset = function() {
    Hud.__super__.reset.apply(this, arguments);
    return this.score.setText('0');
  };

  return Hud;

})(Fz2D.Group);

Map = (function(superClass) {
  extend(Map, superClass);

  function Map() {
    Map.__super__.constructor.apply(this, arguments);
    this.exists = false;
    this._types = [];
    this._map = null;
  }

  Map.prototype.addType = function(type, klass) {
    return this._types[type] = klass;
  };

  Map.prototype.getTypeAt = function(x, y) {
    return this._map[x + (y * this._map.w)];
  };

  Map.prototype.spawn = function(type, x, y) {
    var entity, klass;
    if (klass = this._types[type]) {
      entity = this.add(klass.clone());
      entity.tag = type;
      entity.reset(x, y);
      return entity;
    } else {
      return null;
    }
  };

  Map.prototype.load = function(map) {
    var i, j, ref, ref1, x, y;
    this.clear();
    for (y = i = 0, ref = map.h - 1; 0 <= ref ? i <= ref : i >= ref; y = 0 <= ref ? ++i : --i) {
      for (x = j = 0, ref1 = map.w - 1; 0 <= ref1 ? j <= ref1 : j >= ref1; x = 0 <= ref1 ? ++j : --j) {
        this.spawn(map.data[x + (y * map.w)], x * map.tw, y * map.th);
      }
    }
    return this._map = map;
  };

  return Map;

})(Fz2D.Group);

Menu = (function(superClass) {
  extend(Menu, superClass);

  function Menu(w, h, sprites) {
    var button, cx, cy, icons;
    Menu.__super__.constructor.call(this, 0, 0, w, h);
    this.add(new Fz2D.Entity(sprites.getTexture('title'), 0, 0));
    icons = sprites.getTexture('icons_left');
    cx = (w - icons.h) >> 1;
    cy = (h - icons.h) >> 1;
    button = new Fz2D.Gui.Button(cx, cy, icons.getSubTexture(0), icons.getSubTexture(2), icons.getSubTexture(1));
    button.onclick = (function(_this) {
      return function() {
        return _this.onplay(_this);
      };
    })(this);
    this.add(button);
    this.add(new Fz2D.Gui.Mouse(sprites.getTexture('pointer'), 0, 0));
  }

  Menu.prototype.onplay = function(menu) {};

  return Menu;

})(Fz2D.Group);

Player = (function(superClass) {
  var Key;

  extend(Player, superClass);

  Key = Fz2D.Input.Keyboard.Key;

  function Player(sprites, sound) {
    this.collision = bind(this.collision, this);
    this.kill = bind(this.kill, this);
    var die_anim;
    Player.__super__.constructor.call(this, sprites.getTexture('snipe_idle'), 50, 200);
    this.addAnimation('idle_right', sprites.getTexture('snipe_blink_facing_right'));
    this.addAnimation('idle_left', sprites.getTexture('snipe_blink_facing_left'));
    this.addAnimation('run_right', sprites.getTexture('snipe_run_right'));
    this.addAnimation('run_left', sprites.getTexture('snipe_run_left'));
    this.addAnimation('jump_right', sprites.getTexture('snipe_jump_right'));
    this.addAnimation('jump_left', sprites.getTexture('snipe_jump_left'));
    die_anim = this.addAnimation('die', sprites.getTexture('snipe_die'));
    die_anim.onend = this.kill;
    this.sound = sound;
    this.bounds.set(5, 5, 23, 27);
    this.exists = false;
    this.moving = true;
    this.jumping = false;
    this.grounded = false;
  }

  Player.prototype.clone = function() {
    return this;
  };

  Player.prototype.reset = function(x, y) {
    if (this.ox == null) {
      this.ox = x;
    }
    if (this.oy == null) {
      this.oy = y;
    }
    return Player.__super__.reset.call(this, this.ox, this.oy);
  };

  Player.prototype.kill = function() {
    if (this.is('die')) {
      Player.__super__.kill.apply(this, arguments);
      this.solid = true;
      return this.play('_default');
    } else {
      this.solid = false;
      this.dx = 0.0;
      this.dy = 0.0;
      return this.play('die');
    }
  };

  Player.prototype.update = function(timer, input) {
    Player.__super__.update.apply(this, arguments);
    if (!this.solid) {
      return;
    }
    if (input.keys[Key.LEFT] && this.x > 0) {
      if (!this.is('run_left')) {
        this.play('run_left', true);
      }
      this.dx = -0.2;
    } else if (input.keys[Key.RIGHT] && this.x + this.w < this.group.w) {
      if (!this.is('run_right')) {
        this.play('run_right', true);
      }
      this.dx = 0.2;
    } else {
      if (this.is('run_left')) {
        this.play('idle_left', true);
      } else if (this.is('run_right')) {
        this.play('idle_right', true);
      }
      this.dx = 0.0;
    }
    this.dy += 0.1;
    if ((input.keys[Key.UP] || input.keys[Key.X]) && this.grounded) {
      this.dy = -1.0;
      this.jumping = true;
      this.grounded = false;
      this.sound.replay();
      return;
    }
    return Fz2D.collide(this, this.group, this.collision);
  };

  Player.prototype.collision = function(o1, o2) {
    var result;
    if (o2 instanceof Coin) {
      o2.kill();
      return;
    } else if (o2 instanceof ExitPost) {
      o1.kill();
      o2.kill();
      return;
    }
    result = Fz2D.getCollisionSide(o1, o2);
    if (this.jumping && this.dy < 0.0) {
      if (result & Fz2D.BOTTOM) {
        this.dy = 0.0;
        return this.jumping = false;
      }
    } else if (result & Fz2D.TOP) {
      o1.y = o2.y - o2.h;
      this.dy = 0.0;
      this.jumping = false;
      return this.grounded = true;
    }
  };

  return Player;

})(Fz2D.Entity);

Game = (function(superClass) {
  extend(Game, superClass);

  function Game() {
    return Game.__super__.constructor.apply(this, arguments);
  }

  Game.prototype.w = 640;

  Game.prototype.h = 480;

  Game.prototype.assets = {
    sprites: 'sprites.atl',
    header: 'header.png',
    map: 'level.json',
    pickup: 'pickup.ogg',
    jump: 'jump.ogg',
    exitpost_appear: 'exitpost_appear.ogg',
    exitpost_disappear: 'exitpost_disappear.ogg',
    winter_snow: 'winter_snow.ogg'
  };

  Game.prototype.plugins = [Fz2D.Plugins.Touch, Fz2D.Plugins.GitHub, Fz2D.Plugins.Stats];

  Game.prototype.github = {
    username: 'icebreaker',
    repository: 'fz2d'
  };

  Game.prototype.onload = function(game) {
    var assets, background, coin, exit_post, hud, input, map, menu, mosaic, player, scene, sprites, tiles;
    game.input.mouse.hide();
    assets = game.assets;
    scene = game.scene;
    sprites = assets.sprites;
    tiles = sprites.getTexture('tiles');
    assets.winter_snow.play(true);
    menu = new Menu(scene.w, scene.h, sprites);
    hud = new Hud(scene.w, scene.h, sprites);
    background = new Fz2D.Entity(sprites.getTexture('bg'), 0, 0);
    background.exists = false;
    exit_post = new ExitPost(sprites.getTexture('exitpost_appear'), sprites.getTexture('exitpost_disappear'), assets.exitpost_appear, assets.exitpost_disappear);
    coin = new Coin(sprites.getTexture('spinning_coin_gold'), sprites.getTexture('picked_up'), assets.pickup);
    coin.oncollect = function(c) {
      hud.score.inc();
      if (!c.group.hasAliveByClass(Coin)) {
        return exit_post.reset();
      }
    };
    player = new Player(sprites, assets.jump);
    map = new Map(scene.x, scene.y, scene.w, scene.h);
    map.addType(1, new Fz2D.Entity(tiles.getSubTexture(30, 32), 0, 0));
    map.addType(2, new Fz2D.Entity(tiles.getSubTexture(31, 32), 0, 0));
    map.addType(3, new Fz2D.Entity(tiles.getSubTexture(5, 32), 0, 0));
    map.addType(4, exit_post);
    map.addType(5, coin);
    map.addType(6, player);
    map.load(assets.map);
    exit_post.onexit = function() {
      hud.kill();
      map.kill();
      background.kill();
      return menu.reset();
    };
    menu.onplay = function() {
      menu.kill();
      background.reset();
      map.reset();
      return hud.reset();
    };
    scene.add(menu);
    scene.add(background);
    scene.add(map);
    scene.add(hud);
    input = new Fz2D.TextureInput().addMosaic(1.0, 16);
    return mosaic = scene.add(new Fz2D.Entity(new Fz2D.Texture(input, game.w, game.h), 0, 0));
  };

  return Game;

})(Fz2D.Game);

Game.run();