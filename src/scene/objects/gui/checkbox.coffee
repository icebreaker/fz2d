# Public: Checkbox
class Fz2D.Gui.Checkbox extends Fz2D.Entity
  # Public: Constructor
  #
  # x - position on the X axis
  # y - position on the Y axis
  # checked - {Fz2D.Texture}
  # unchecked - {Fz2D.Texture}
  constructor: (x, y, checked, unchecked) ->
    super(checked, x, y, 'checked')
    @addAnimation('unchecked', unchecked)

  # Public: On click(ed) callback.
  #
  # button - {Fz2D.Gui.Checkbox}
  onclick: (checkbox) ->
    # empty

  # Public: Updates checkbox on every frame.
  #
  # timer - {Fz2D.Timer}
  # input - {Fz2D.Input}
  update: (timer, input) ->
    return null unless Fz2D.contains(@, input.mouse.position)
    return null unless input.mouse.released[Fz2D.Input.Mouse.Button.LEFT] # on click (once!)

    if @is('checked')
      @play('unchecked')
    else if @is('unchecked')
      @play('checked')

    @onclick(@)

    null
