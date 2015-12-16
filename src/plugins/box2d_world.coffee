# Private: Box2D.World
class Fz2D.Plugins.Box2D.World
  window.Box2D   ?= {}

  b2Vec2          = window.Box2D.b2Vec2
  b2World         = window.Box2D.b2World
  b2BodyDef       = window.Box2D.b2BodyDef
  b2PolygonShape  = window.Box2D.b2PolygonShape
  b2_dynamicBody  = window.Box2D.b2_dynamicBody
  b2_staticBody   = window.Box2D.b2_staticBody

  # Private: Update frequency.
  @UPDATE_HZ: 1.0 / 60.0

  # Private: Velocity correction frequency.
  @VELOCITY: 3

  # Private: Position correction frequency.
  @POSITION: 2

  # Private: Gravity.
  @GRAVITY: 8.0

  # Private: Scale.
  @SCALE: 100.0

  # Private: Inverse scale.
  @INV_SCALE: 1.0 / @SCALE

  # Public: Constructor.
  constructor: () ->
    @_entities = []
    @_world = new b2World(new b2Vec2(0.0, World.GRAVITY))
    @_vec = new b2Vec2(0.0, 0.0)
    @_bodydef = new b2BodyDef()

  # Public: Sets gravity.
  #
  # gravity - gravity
  setGravity: (gravity) ->
    @_vec.Set(0.0, gravity)
    @_world.SetGravity(@_vec)

  # Public: Updates entities.
  #
  # timer - {Fz2D.Timer}
  update: (timer) ->
    @_world.Step(World.UPDATE_HZ, World.VELOCITY, World.POSITION)

    for entity in @_entities
      continue unless entity.exists

      body = entity.body

      if entity.isOutOfBounds()
        entity.kill()

        body.SetActive(0)
        body.SetAwake(0)

        continue

      position = body.GetPosition()
      entity.x = (position.get_x() * World.SCALE) - entity.bounds.center.x
      entity.y = (position.get_y() * World.SCALE) - entity.bounds.center.y
      entity.angle = body.GetAngle() * Fz2D.RAD2DEG

    null

  # Public: Adds an entity.
  #
  # entity - {Fz2D.Entity}
  add: (entity) ->
    return entity unless entity.exists or entity.body

    entity.density ?= 0.0

    bounds = entity.bounds

    x = entity.x + bounds.center.x
    y = entity.y + bounds.center.y
    @_vec.Set(x * World.INV_SCALE, y * World.INV_SCALE)

    @_bodydef.set_position(@_vec)
    @_bodydef.set_angle(entity.angle * Fz2D.DEG2RAD)

    if entity.density > 0.0
      @_bodydef.set_type(b2_dynamicBody)
    else
      @_bodydef.set_type(b2_staticBody)

    body = @_world.CreateBody(@_bodydef)

    shape = new b2PolygonShape()
    shape.SetAsBox(bounds.hw * World.INV_SCALE, bounds.hh * World.INV_SCALE)

    body.CreateFixture(shape, entity.density)

    entity.body   = body

    @_entities.push(entity)

    entity
  
  # Public: Kills an entity.
  #
  # entity - {Fz2D.Entity}
  kill: (entity) ->
    return unless entity.body

    body = entity.body
    body.SetActive(0)
    body.SetAwake(0)

    null

  # Public: Resets an entity.
  #
  # entity - {Fz2D.Entity}
  reset: (entity) ->
    return unless entity.body

    body = entity.body

    bounds = entity.bounds
    
    x = entity.x + bounds.center.x
    y = entity.y + bounds.center.y

    @_vec.Set(x * World.INV_SCALE, y * World.INV_SCALE)
    body.SetTransform(@_vec, entity.angle * Fz2D.DEG2RAD)

    if entity.density > 0.0
      body.SetType(b2_dynamicBody)
    else
      body.SetType(b2_staticBody)

    body.SetActive(1)
    body.SetAwake(1)
   
    null

  # Public: Removes an entity.
  #
  # entity - {Fz2D.Entity}
  #
  # Returns true or false.
  remove: (entity) ->
    return false unless entity.body

    @_world.DestroyBody(entity.body)
    entity.body = null

    i = @_entities.indexOf(entity)
    if i > -1
      @_entities.splice(i, 1)
      true
    else
      false

  # Public: Removes all entities.
  clear: () ->
    for entity in @_entities
      @_world.DestroyBody(entity.body)
      entity.body = null

    @_entities = []
