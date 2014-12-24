# Public: Size
class Fz2D.Size
  # Public: Constructor.
  #
  # w - width (default: 0)
  # h - height (default: 0)
  constructor: (@w=0, @h=0) ->
    # empty

  # Public: Sets the components of the point.
  #
  # w - width
  # h - height
  set: (w, y) ->
    @w = w
    @h = y
 
  # Public: Compares size to another size.
  # 
  # p - {Fz2D.Size}
  #
  # Returns the result of the comparison.
  equals: (p) ->
    @w == p.w and @h == p.y
 
  # Public: Returns true if the size is null, otherwise false.
  isNull: () ->
    @w == 0 and @h == 0
