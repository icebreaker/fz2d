# Public: Fz2D
class Fz2D
  # Public: Version Number.
  @VERSION: '0.0.3'

  # Public: None.
  @NONE:    0
  # Public: Top.
  @TOP:     1 << 0
  # Public: Left.
  @LEFT:    1 << 1
  # Public: Right.
  @RIGHT:   1 << 2
  # Public: Bottom.
  @BOTTOM:  1 << 3

  # Public: Default foreground color.
  @FG: '#FFFFFF'
  # Public: Default background color.
  @BG: '#000000'

  # Public: Default canvas selector.
  @SELECTOR: '#canvas'

  # Public: Default assets path.
  @PATH: 'assets'

  # Public: Degree to Radian
  @DEG2RAD: Math.PI / 180.0

  # Public: Radian to Degree
  @RAD2DEG: 180.0 / Math.PI

  # Public: Hash of parsed and unescaped query paramaters.
  @query:(()->
    hash = {}

    query = window.location.href.split('?').pop()

    for q in query.split('&')
      [k, v] = q.split('=')

      kk = unescape(k)
      vv = unescape(v)

      if /^\d+$/.test(vv) # convert numbers
        vv = parseInt(vv)
      else if /^true|false$/i.test(vv) # convert booleans
        vv = JSON.parse(vv)
        unless kk of Fz2D
          Fz2D[kk] = kk if vv # alias booleans; but only if they are true?

      hash[kk] = vv

    hash
  )()

  # Public: URL without parameters.
  @url: (() ->
    window.location.href.split('?')[0]
  )()

  # Public: Is HTTPS supported?
  @https: (() ->
    if window.location.protocol == 'https:'
      'https'
    else
      null
  )()

  # Public: Production environment?
  @production: null

  # Public: Development environment?
  @development: (() ->
    return 'development' if Fz2D.debug?
    return 'development' if /localhost|127.0.0.1|192.168.\d+.\d+/i.test(window.location.hostname)
    Fz2D.production = 'production'
    null
  )()

  # Public: Is touch device?
  @touch: (() ->
    return 'supported' if Fz2D.forcetouch?
    return 'supported' if 'ontouchstart' in window
    return 'supported' if window.DocumentTouch and window.document instance DocumentTouch
    return 'supported' if window.navigator.maxTouchPoints > 0 or window.navigator.msMaxTouchPoints > 0
    null
  )()

  # Public: Is mobile device?
  @mobile: (() ->
    m = window.navigator.userAgent.match(/(iphone|ipod|ipad|android|iemobile|blackberry|bada)/i)
    if m
      m[1]
    else
      null
  )()

  # Public: Is Firefox?
  @firefox: (() ->
    if /firefox/i.test(window.navigator.userAgent)
      'firefox'
    else
      null
  )()

  # Public: Is Internet Explorer?
  @ie: (() ->
    m = window.navigator.userAgent.match(/(msie \d+|iemobile\/\d+|WPDesktop)/i)
    if m
      parseInt(m[1].replace(/(msie\s+|iemobile\/)/i, '')) || 11
    else
      null
  )()

  # Public: Returns true if an array, hash or string is not empty.
  #
  # o - array, hash or string
  @any: (o) ->
    not @empty(o)

  # Public: Returns true if an array, hash or string is empty.
  #
  # o - array, hash or string
  @empty: (o) ->
    return true unless o?
    return true if o.length? and o.length == 0

    for k, v of o
      return false
    
    true

  # Public: Clamps a given number between two limits.
  #
  # d   - number
  # min - minimum limit
  # max - maximum limit
  #
  # Returns the clamped number.
  @clamp: (d, min, max) ->
    Math.min(Math.max(d, min), max)

  # Public: Linearly interpolates a number within two limits based on time.
  #
  # t   - timestamp (step)
  # d   - number
  # min - minimum limit
  # max - maximum limit
  #
  # Returns the interpolated value for the given timestamp (step).
  @step: (t, d, min, max) ->
    dt = t / d
    Fz2D.clamp(((max * dt) + (min * (1 - dt))), Math.min(min, max), Math.max(min, max))

  # Public: Determines the distance between two objects.
  #
  # o1 - object
  # o2 - object
  # 
  # Returns the distance.
  #
  # See also {Fz2D.distSqr} for cases when you don't need the exact distance. 
  @dist: (o1, o2) ->
    x1 = o1.x + o1.bounds.x
    y1 = o1.y + o1.bounds.y
    
    x2 = o2.x + o2.bounds.x
    y2 = o2.y + o2.bounds.y
 
    dx = x2 - x1
    dy = y2 - y1

    Math.sqrt(dx * dx + dy * dy)

  # Public: Determines the squared distance between two objects.
  #
  # o1 - object
  # o2 - object
  # 
  # Returns the squared distance.
  #
  # See also {Fz2D.dist} for cases when you *need* the exact distance. 
  @distSqr: (o1, o2) ->
    x1 = o1.x + o1.bounds.x
    y1 = o1.y + o1.bounds.y
    
    x2 = o2.x + o2.bounds.x
    y2 = o2.y + o2.bounds.y
 
    dx = x2 - x1
    dy = y2 - y1
    
    (dx * dx + dy * dy)

  # Public: Determines the side of a collision.
  #
  # o1 - object
  # o2 - object
  #
  # Returns the sides of a collision.
  @getCollisionSide: (o1, o2) ->
    x1 = o1.x + o1.bounds.center.x
    y1 = o1.y + o1.bounds.center.y
 
    x2 = o2.x + o2.bounds.center.x
    y2 = o2.y + o2.bounds.center.y
   
    result = Fz2D.NONE

    if y1 > y2
      result |= Fz2D.BOTTOM
    else
      result |= Fz2D.TOP
    
    if x1 > x2
      result |= Fz2D.RIGHT
    else
      result |= Fz2D.LEFT

    result

  # Public: Determines if there's a collision between two objects.
  #
  # o1        - object or group
  # o2        - object or group
  # callback  - callback function to be called on each collision
  #
  # Unlike {Fz2D.overlap}, if `o1` and/or `o2` are groups, it *will* call 
  # `collide` against all of their children.
  #
  # Returns true or false.
  @collide: (o1, o2, callback) ->
    # 1. Both objects must exist and they cannot be the 'same'
    return false unless o1.exists and o1.solid and o2.exists and o2.solid and o1 != o2

    # 2. If both objects are groups then we'll try to collide
    # every object from the first group with every object from
    # the second group ...
    if o1._objects and o2._objects
      collide = false

      for o3 in o1._objects
        if Fz2D.collide(o3, o2, callback)
          collide = true

      return collide

    # 3. If object one or object two is a group then we'll arrange them
    # in a way where object two is always the group
    if o1._objects
      o3 = o1
      o1 = o2
      o2 = o3

    # 4. If object two is a group then we'll call collide for every object
    if o2._objects
      # If we have valid bounds set on the group, then see if we are actually
      # inside of it, before trying to collide with any of its children ...
      # This also comes handy for doing basic "spatial partioning", almost for free.
      return false if not o2.bounds.isNull() and not Fz2D.overlap(o1, o2)

      collide = false

      for o3 in o2._objects
        if Fz2D.collide(o1, o3, callback)
          collide = true

      return collide

    x1 = o1.x + o1.bounds.x
    y1 = o1.y + o1.bounds.y
    
    x2 = o2.x + o2.bounds.x
    y2 = o2.y + o2.bounds.y
 
    if !((x1 > x2 + o2.bounds.w) or
         (y1 > y2 + o2.bounds.h) or
         (x1 + o1.bounds.w < x2) or
         (y1 + o1.bounds.h < y2))
      callback(o1, o2)
      true
    else
      false

  # Public: Determines if an object or group contains a point.
  #
  # o - object or group
  # p - point
  #
  # Returns true or false.
  @contains: (o, p) ->
    x = o.x + o.bounds.x
    y = o.y + o.bounds.y
      
    ((p.x >= x) and (p.x <= x + o.bounds.w) and
     (p.y >= y) and (p.y <= y + o.bounds.h))

  # Public: Determines if an object or group overlaps with another object or group.
  #
  # o1 - object or group
  # o2 - object or group
  #
  # If `o1` or `o2` is a group, it will not call `overlap` against all of their children.
  #
  # See also {Fz2D.collide}.
  #
  # Returns a true or false.
  @overlap: (o1, o2) ->
    x1 = o1.x + o1.bounds.x
    y1 = o1.y + o1.bounds.y
    
    x2 = o2.x + o2.bounds.x
    y2 = o2.y + o2.bounds.y
 
    !((x1 > x2 + o2.bounds.w) or
      (y1 > y2 + o2.bounds.h) or
      (x1 + o1.bounds.w < x2) or
      (y1 + o1.bounds.h < y2))
 
  # Public: Swaps A with B.
  #
  # a - A
  # b - B
  #
  # Returns A and B swapped.
  @swap: (a, b) ->
    tmp = a
    a = b
    b = a

    [a, b]

  # Public: Converts HTML color code into floating point RGB components.
  #
  # color - HTML color code (with # prefix)
  #
  # Returns RGB converted to floating point components.
  @toRGB: (color) ->
    c = parseInt(color.slice(1), 16)
    { r: ((c >> 16) & 255) / 255.0, g: ((c >> 8) & 255) / 255.0, b: (c & 255) / 255.0 }

  # Public: Finds a HTML DOM element by id or class.
  #
  # selector - query selector
  #
  # Returns HTML DOM element or null.
  @getEl: (() ->
    if document.querySelector?
      (selector) -> document.querySelector(selector)
    else
      (selector) -> document.getElementById(selector.slice(1))
  )()

  # Public: Creates a new HTML DOM element.
  #
  # type - type of HTML DOM element
  # attrs - Hash of attributes (optional)
  # styles - Hash of style attributes (optional)
  #
  # Returns a new instance of a HTML DOM element of the given type.
  @createEl: (type, attrs={}, styles={}) ->
    el = document.createElement(type)

    for k, v of attrs
      el[k] = v

    for k, v of styles
      el.style[k] = v

    el

  # Public: Adds a HTML DOM element to a parent HTML DOM element.
  #
  # el - HTML DOM element
  # parent - parent HTML DOM element (default: document.body)
  #
  # Returns the element itself.
  @appendEl: (el, parent=document.body) ->
    parent.appendChild(el)
    el

  # Public: Sets style properties of a HTML DOM element.
  #
  # el -  HTML DOM element
  # styles - Hash of style attributes (default: {})
  # 
  # Returns the element itself.
  @setStyleEl: (el, styles={}) ->
    for k, v of styles
      el.style[k] = v

    el

  # Public: Performs an asynchronous HTTP GET request.
  #
  # url - url to perform the request for
  # callback - ready callback function
  #
  # Parses `responseText` as JSON before passing it to `callback`.
  #
  # Returns immediately with an undefined value.
  @getJSON: (url, callback) ->
    req = new XMLHttpRequest()
    req.open('GET', url, true)
    req.setRequestHeader('Content-type', 'application/json')
    req.onreadystatechange = () ->
      if req.readyState == 4
        if req.status == 200
          callback(window.JSON.parse(req.responseText), req.status)
        else
          callback(req.responseText, req.status)
    req.send(null)
  
   # Public: Plugin namespace.
   @Plugins: {}

   # Public: Plugin.
   class Fz2D.Plugin
     # Public: Supported?
     @supported: true

     # Public: Returns plugin name.
     @getName: () ->
       try
         @prototype.constructor.name
       catch
         "Generic"

   # Public: Gui namespace.
   @Gui: {}

############### BEGIN HACKS ####################
if global? and typeof global == 'object' # for tests :)
  Fz2D.__path = require('path')
  Fz2D.require = (file) ->
    require(Fz2D.__path.join(__dirname, file))
  global.Fz2D = Fz2D

unless window.requestAnimationFrame?
  window.requestAnimationFrame = ((window) ->
      window.webkitRequestAnimationFrame ||
      window.mozRequestAnimationFrame ||
      window.oRequestAnimationFrame ||
      window.msRequestAnimationFrame ||
      (callback, element) ->
        window.setTimeout(callback, 1000 / 60)
  )(window)

unless window.console?
  window.console = ((window) ->
    { log: (text) -> }
  )(window)

unless window.localStorage?
  window.localStorage = ((window) ->
    class LocalStorageImpl
      constructor: () ->
        @data = {}

      setItem: (name, value) ->
        @data[name] = data
    
      getItem: (name) ->
        @data[name]

      removeItem: (name) ->
        @data[name] = null

    new LocalStorageImpl()
  )(window)

unless window.performance?
  window.performance = {}

unless window.performance.memory?
  window.performance.memory = { usedJSHeapSize: 0 }
############### END HACKS ####################
