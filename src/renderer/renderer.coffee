# Public: Renderer (2D or WebGL)
Fz2D.Renderer = ((Fz2D) ->
  if Fz2D.Canvas.supported?
    if Fz2D.nowebgl?
      Fz2D.Canvas
    else if Fz2D.CanvasWebGL.supported?
      Fz2D.CanvasWebGL
    else
      Fz2D.Canvas
  else
    null
)(Fz2D)
