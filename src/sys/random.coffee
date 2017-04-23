# Public: Random
class Fz2D.Random
  # Private: Maximum Unsigned Integer.
  @UINT_MAX: 0xffffffff # == Math.pow(2, 32) - 1
  # Private: Inverse of the Maximum Unsigned Integer.
  @UINT_MAX_INV: 1.0 / @UINT_MAX
  # Private: Number of bits.
  @BITS: 32

  # Public: Constructor.
  #
  # seed - initial seed (default: random)
  constructor: (@seed) ->
    @seed ?= Math.ceil(Math.random() * Fz2D.Random.UINT_MAX)

  # Public: Returns a random integer between 0 and (n - 1).
  #
  # n - integer
  next: (n) ->
    (@nextFloat() * n) | 0

  # Public: Returns a random float between 0 and 1.
  nextFloat: () ->
    @seed += (@seed * @seed) | 5
    (@seed >>> Fz2D.Random.BITS) * Fz2D.Random.UINT_MAX_INV

  # Public: Returns a random bool.
  nextBool: () ->
    !!(((@nextFloat() * Fz2D.Random.BITS) | 0) & 1)

  # Public: Returns a random direction, -1 or 1.
  nextDirection: () ->
    (-1.0 + @nextBool() * 2.0) | 0

  # Public: Returns a random integer between min and max.
  #
  # min - integer
  # max - integer
  nextBetween: (min, max) ->
    min + @next((max + 1) - min)
