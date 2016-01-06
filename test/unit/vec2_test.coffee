require '../test_helper'
require '../../src/fz2d'

Fz2D.require('scene/vec2')

test '#constructor with no arguments', ->
  p = new Fz2D.Vec2()
  assert_equal 0, p.x
  assert_equal 0, p.y

test '#constructor with arguments', ->
  p = new Fz2D.Vec2(13, 42)
  assert_equal 13, p.x
  assert_equal 42, p.y

test '#set', ->
  p = new Fz2D.Vec2()
  p.set(42, 13)
  assert_equal 42, p.x
  assert_equal 13, p.y

test '#equals', ->
  p1 = new Fz2D.Vec2(10, 11)
  p2 = new Fz2D.Vec2(10, 11)
  assert p1.equals(p2), 'P1 is not equal to P1.'

test 'not #equals', ->
  p1 = new Fz2D.Vec2(10, 12)
  p2 = new Fz2D.Vec2(10, 11)
  assert !p1.equals(p2), 'P1 is equal to P1.'

test '#isNull', ->
  p = new Fz2D.Vec2()
  assert p.isNull(), 'Vec2 is not null.'

test 'not #isNull', ->
  p = new Fz2D.Vec2(10, 20)
  assert !p.isNull(), 'Vec2 is null.'
