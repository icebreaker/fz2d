# Public: Group
class Fz2D.Group extends Fz2D.Object
  # Public: Constructor.
  #
  # x - position on the X axis (default: 0)
  # y - position on the Y axis (default: 0)
  # w - width of group (default: 0)
  # h - height of group (default: 0)
  constructor: (x=0, y=0, w=0, h=0) ->
    super(x, y, w, h)
    @_objects = []

  # Public: Iterates over each object and calls the given callback.
  #
  # cb - iteration callback function
  # arg - additional argument to be passed to the callback function
  #
  # Returns the first object for which the callback function returned true.
  find: (cb, arg) ->
    for o in @_objects
      if cb(o, arg) is true
        return o

    null

  # Public: Iterates over each object.
  #
  # cb - iteration callback function
  each: (cb) ->
    for o in @_objects
      if cb(o) is false
        break

    null

  # Public: Iterates over each object of a given class.
  #
  # klass - a class
  # cb - iteration callback function
  eachByClass: (klass, cb) ->
    for o in @_objects
      if o instanceof klass and cb(o) is false
        break

    null

  # Public: Sorts objects.
  #
  # cb - compare callback function
  sort: (cb) ->
    @_objects.sort.apply(@_objects, arguments)
    @

  # Public: Sorts objects by their z value.
  sortByZ: () ->
    @sort(@_compareZ)

  # Public: Recycle an object.
  # Returns first {Fz2D.Object} that doesn't exist.
  recycle: () ->
    for o in @_objects
      return o unless o.exists

    null

  # Public: Recycle an object by tag.
  #
  # tag - name of the object
  #
  # Returns first {Fz2D.Object} with the given tag that doesn't exist.
  recycleByTag: (tag) ->
    for o in @_objects
      return o if not o.exists and o.tag == tag

    null

  # Public: Recycle an object by class.
  #
  # klass - class
  #
  # Returns first {Fz2D.Object} with the given class that doesn't exist.
  recycleByClass: (klass) ->
    for o in @_objects
      return o if not o.exists and o instanceof klass

    null

  # Public: Returns true if there's at least one object that is alive.
  hasAlive: () ->
    @firstAlive()?

  # Public: Returns true if there's at least one object that is alive with the given tag.
  #
  # tag - name of the object
  hasAliveByTag: (tag) ->
    @firstAliveByTag(tag)?

  # Public: Returns true if there's at least one object that is alive with the given class.
  #
  # klass - class of the object
  hasAliveByClass: (klass) ->
    @firstAliveByClass(klass)?

  # Public: Returns true if there's at least one object that is dead.
  hasDead: () ->
    @firstDead()?

  # Public: Returns true if there's at least one object that is dead with the given tag.
  #
  # tag - name of the object
  hasDeadByTag: (tag) ->
    @firstDeadByTag(tag)?

  # Public: Returns true if there's at least one object that is dead with the given class.
  #
  # klass - class of the object
  hasDeadByClass: (klass) ->
    @firstDeadByClass(klass)?

  # Public: Returns true if there's at least one object that is visible.
  hasVisible: () ->
    @firstVisible()?

  # Public: Returns true if there's at least one object that is visible with the given tag.
  #
  # tag - name of the object
  hasVisibleByTag: (tag) ->
    @firstVisibleByTag(tag)?

  # Public: Returns true if there's at least one object that is visible with the given class.
  #
  # klass - class of the object
  hasVisibleByClass: (klass) ->
    @firstVisibleByClass(klass)?

  # Public: Returns first {Fz2D.Object} that doesn't exist.
  firstAvail: () ->
    for o in @_objects
      return o unless o.exists
    
    null

  # Public: Returns first {Fz2D.Object} by tag that doesn't exist.
  #
  # tag - name of the object
  firstAvailByTag: (tag) ->
    for o in @_objects
      return o if not o.exists and o.tag == tag

    null

  # Public: Returns first {Fz2D.Object} by class that doesn't exist.
  #
  # klass - class of the object
  firstAvailByClass: (klass) ->
    for o in @_objects
      return o if not o.exists and o instanceof klass

    null

  # Public: Returns first {Fz2D.Object} that exist.
  firstExisting: () ->
    for o in @_objects
      return o if o.exists

    null

  # Public: Returns first {Fz2D.Object} by tag that exist.
  #
  # tag - name of the object
  firstExistingByTag: (tag) ->
    for o in @_objects
      return o if o.exists and o.tag == tag

    null

  # Public: Returns first {Fz2D.Object} by class that exist.
  #
  # klass - class of the object
  firstExistingByClass: (klass) ->
    for o in @_objects
      return o if o.exists and o instanceof klass

    null

  # Public: Returns first {Fz2D.Object} that is alive.
  firstAlive: () ->
    for o in @_objects
      return o if o.alive

    null

  # Public: Returns first {Fz2D.Object} by tag that is alive.
  #
  # tag - name of the object
  firstAliveByTag: (tag) ->
    for o in @_objects
      return o if o.alive and o.tag == tag

    null

  # Public: Returns first {Fz2D.Object} by class that is alive.
  #
  # klass - class of the object
  firstAliveByClass: (klass) ->
    for o in @_objects
      return o if o.alive and o instanceof klass

    null

  # Public: Returns first {Fz2D.Object} that is dead.
  firstDead: () ->
    for o in @_objects
      return o unless o.alive

    null

  # Public: Returns first {Fz2D.Object} by tag that is dead.
  #
  # tag - name of the object
  firstDeadByTag: (tag) ->
    for o in @_objects
      return o if not o.alive and o.tag == tag

    null

  # Public: Returns first {Fz2D.Object} by class that is dead.
  #
  # klass - class of the object
  firstDeadByClass: (klass) ->
    for o in @_objects
      return o if not o.alive and o instanceof klass

    null

  # Public: Returns first {Fz2D.Object} that is visible.
  firstVisible: () ->
    for o in @_objects
      return o if o.visible

    null

  # Public: Returns first {Fz2D.Object} by tag that is visible.
  #
  # tag - name of the object
  firstVisibleByTag: (tag) ->
    for o in @_objects
      return o if o.visible and o.tag == tag

    null

  # Public: Returns first {Fz2D.Object} by class that is visible.
  #
  # klass - class of the object
  firstVisibleByClass: (klass) ->
    for o in @_objects
      return o if o.visible and o instanceof klass

    null

  # Public: Returns true if all objects are alive.
  allAlive: () ->
    !@hasDead()

  # Public: Returns true if all objects are dead.
  allDead: () ->
    !@hasAlive()

  # Public: Adds an object.
  #
  # object - {Fz2D.Object}
  #
  # Returns the object itself.
  add: (object) ->
    @_objects.push(object)
    object.group ?= @
    object

  # Public: Removes an object.
  #
  # object - {Fz2D.Object}
  #
  # Returns the object itself.
  remove: (object) ->
    @removeByIndex(@_objects.indexOf(object))

  # Public: Removes an object by index.
  #
  # i - index (>= 0 and <= length - 1)
  #
  # Returns the object itself.
  removeByIndex: (i) ->
    if i > -1
      arr = @_objects.splice(i, 1)
      if arr.length == 1
        object = arr[0]
        object.group = null if object.group == @
        object
      else
        null
    else
      null

  # Public: Removes an object by tag.
  #
  # tag - name of the object
  #
  # Returns the object itself.
  removeByTag: (tag) ->
    for o in @_objects
      return @remove(o) if o.tag == tag
    
    null

  # Public: Removes an object by class.
  #
  # klass - class of the object
  #
  # Returns the object itself.
  removeByClass: (klass) ->
    for o in @_objects
      return @remove(o) if o instanceof klass
    
    null

  # Public: Kills all objects.
  killAll: () ->
    for o in @_objects
      o.killAll()
    
    null

  # Public: Resets all objects.
  resetAll: () ->
    for o in @_objects
      o.resetAll()
    
    null

  # Public: Hides all objects.
  hideAll: () ->
    for o in @_objects
      o.visible = false

  # Public: Shows all objects.
  showAll: () ->
    for o in @_objects
      o.visible = true

  # Public: Finds an object by tag.
  #
  # tag - name of the object
  #
  # Returns the object or null.
  findByTag: (tag) ->
    for o in @_objects
      return o if o.tag == tag

    null

  # Public: Finds an object by class.
  #
  # klass - class of the object
  #
  # Returns the object or null.
  findByClass: (klass) ->
    for o in @_objects
      return o if o instanceof klass

    null

  # Public: Returns first object.
  first: () ->
    @_objects[0]

  # Public: Returns last object.
  last: () ->
    @_objects[@_objects.length - 1]

  # Public: Returns object at a given index.
  #
  # i - index (>= 0 and <= length - 1)
  at: (i) ->
    @_objects[i]

  # Public: Removes all objects.
  clear: () ->
    @_objects = []

  # Public: Returns the number of objects.
  length: () ->
    @_objects.length

  # Public: Draws group on every frame.
  #
  # ctx - {Fz2D.Canvas}
  draw: (ctx) ->
    for o in @_objects
      o.draw(ctx) if o.exists and o.visible

    null

  # Public: Updates group on every frame.
  #
  # timer - {Fz2D.Timer}
  # input - {Fz2D.Input}
  update: (timer, input) ->
    for o in @_objects
      o.update(timer, input) if o.exists and o.alive

    null

  # Private: Compares the z value of two objects.
  #
  # o1 - {Fz2D.Object}
  # o2 - {Fz2D.Object}
  # 
  # Returns negative if o1 is smaller, positive if o1 is bigger and zero if they are equal.
  _compareZ: (o1, o2) ->
    o1.z - o2.z
