# Public: Iso
class Fz2D.Iso
  # Public: Converts carteesian coordinates to isometric coordinates.
  #
  # x - value on the X axis
  # y - value on the Y axis
  #
  # Returns a {Fz2D.Vec2}.
  @to: (x, y) ->
    @_toVec2(x - y, ((x + y) >> 1))

  # Public: Converts isometric coordinates to carteesian coordinates.
  #
  # x - value on the X axis
  # y - value on the Y axis
  #
  # Returns a {Fz2D.Vec2}.
  @from: (x, y) ->
    @_toVec2((((y << 1) + x) >> 1), (((y << 1) - x) >> 1))

  # Private: Returns a {Fz2D.Vec2}.
  #
  # x - value on the X axis
  # y - value on the Y axis
  @_toVec2: (x, y) ->
    @_temp ?= Fz2D.Vec2()
    @_temp.set(x, y)
    @_temp
