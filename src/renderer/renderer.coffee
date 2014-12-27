# Public: Renderer (2D or WebGL)
Fz2D.Renderer = ((Fz2D) ->
  if Fz2D.Canvas.supported?
    if Fz2D.nowebgl?
      console.log('Renderer: 2D (forced)')
      Fz2D.Canvas
    else if Fz2D.CanvasWebGL.supported?
      console.log('Renderer: WebGL')
      Fz2D.CanvasWebGL
    else
      console.log('Renderer: 2D')
      Fz2D.Canvas
  else
    null
)(Fz2D)
