require '../test_helper'

Fz2D.require('scene/size')

test '#constructor with no arguments', ->
  s = new Fz2D.Size()
  assert_equal 0, s.w
  assert_equal 0, s.h

test '#constructor with arguments', ->
  s = new Fz2D.Size(13, 42)
  assert_equal 13, s.w
  assert_equal 42, s.h

test '#set', ->
  s = new Fz2D.Size()
  s.set(42, 13)
  assert_equal 42, s.w
  assert_equal 13, s.h

test '#equals', ->
  s1 = new Fz2D.Size(10, 11)
  s2 = new Fz2D.Size(10, 11)
  assert s1.equals(s2), 's1 is not equal to s1.'

"""
test 'not #equals', ->
  s1 = new Fz2D.Size(10, 12)
  s2 = new Fz2D.Size(10, 11)
  assert !s1.equals(s2), 's1 is equal to s1.'

test '#isNull', ->
  s = new Fz2D.Size()
  assert s.isNull(), 'Size is not null.'

test 'not #isNull', ->
  s = new Fz2D.Size(10, 20)
  assert !s.isNull(), 'Size is null.'
"""
