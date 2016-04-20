class Map extends Fz2D.Group
  constructor: () ->
    super
    @exists = false
    @_types = []
    @_map = null
  
  addType: (type, klass) ->
    @_types[type] = klass

  getTypeAt: (x, y) ->
    @_map[x + (y * @_map.w)]
 
  spawn: (type, x, y) ->
    if klass = @_types[type]
      entity = @add(klass.clone())
      entity.tag = type
      entity.reset(x, y)
      entity
    else
      null

  load: (map) ->
    @clear()

    for y in [0..map.h-1]
      for x in [0..map.w-1]
        @spawn(map.data[x + (y * map.w)], x * map.tw, y * map.th)

    @_map = map
