# Public: Canvas (WebGL)
class Fz2D.CanvasWebGL extends Fz2D.Canvas
  # Public: Supported Canvas Type?
  @supported: (() ->
    try
      if window.WebGLRenderingContext
        canvas = Fz2D.createEl('canvas')
        if canvas.getContext('webgl')
          'webgl'
        else if canvas.getContext('experimental-webgl')
          'experimental-webgl'
        else
          null
      else
        null
    catch
      null
  )()

  # Public: Vertex Cache Size. (note: should be power of two)
  @VERTEX_CACHE_MAX_SIZE: 48 * 2048

  # Private: Vertex Shader.
  @VERTEX_SHADER: """
  precision mediump float;

  uniform vec2 screen;
  uniform vec2 texture;

  attribute vec4 pos;
  attribute vec4 uv;

  varying vec2 texture_coord;
  varying float alpha;

  void main(void)
  { 
    texture_coord = uv.st * texture;
    alpha = uv.w;
    
    float r = radians(uv.z);
    float cosr = cos(r);
    float sinr = sin(r);

    vec2 pp = pos.xy - pos.zw;
    vec2 p  = vec2(pp.x * cosr - pp.y * sinr, pp.x * sinr + pp.y * cosr);

    p += pos.zw;
    p *= screen;

    gl_Position = vec4(p.x - 1.0, 1.0 - p.y, 0.0, 1.0);
  }
  """
   
  # Private: Fragment Shader.
  @FRAGMENT_SHADER: """
  precision mediump float;

  uniform sampler2D texture_id;
  varying vec2 texture_coord;
  varying float alpha;
    
  void main(void)
  {
    vec4 color = texture2D(texture_id, texture_coord);
    color.a *= alpha;

    gl_FragColor = color;
  }
  """

  # Public: Constructor.
  #
  # w - width
  # h - height
  # color - background HTML color code (default: Fz2D.BG)
  # selector - query selector or id (default: Fz2D.SELECTOR)
  constructor: () ->
    super

    @gl = @_ctx # alias context <3

    @_texture_id = 0

    @gl.disable(@gl.DEPTH_TEST)
    @gl.disable(@gl.CULL_FACE)

    @gl.enable(@gl.BLEND)
    @gl.blendFuncSeparate(@gl.SRC_ALPHA, @gl.ONE_MINUS_SRC_ALPHA,
                          @gl.ONE, @gl.ONE_MINUS_SRC_ALPHA)

    @_program = @_createShaderProgram(Fz2D.CanvasWebGL.VERTEX_SHADER,
                                      Fz2D.CanvasWebGL.FRAGMENT_SHADER)

    @_pos_loc = @gl.getAttribLocation(@_program, "pos")
    @_uv_loc = @gl.getAttribLocation(@_program, "uv")
    @_texture_id_loc = @gl.getUniformLocation(@_program, "texture_id")
    @_texture_loc = @gl.getUniformLocation(@_program, "texture")
    @_screen_loc = @gl.getUniformLocation(@_program, "screen")

    @gl.uniform1i(@_texture_id_loc, 0)
    @gl.uniform2f(@_screen_loc, 2.0 / @bounds.w, 2.0 / @bounds.h)

    @_buffer = @gl.createBuffer()
    @gl.bindBuffer(@gl.ARRAY_BUFFER, @_buffer)

    @_vertex_cache = new Float32Array(Fz2D.CanvasWebGL.VERTEX_CACHE_MAX_SIZE)
    @_vertex_cache_size = 0

    @gl.bufferData(@gl.ARRAY_BUFFER, @_vertex_cache, @gl.DYNAMIC_DRAW)

    @gl.enableVertexAttribArray(@_pos_loc)
    @gl.enableVertexAttribArray(@_uv_loc)

    @gl.vertexAttribPointer(@_pos_loc, 4, @gl.FLOAT, false, 32, 0)
    @gl.vertexAttribPointer(@_uv_loc,  4, @gl.FLOAT, false, 32, 16)

  # Public: Fills the canvas with a solid color.
  #
  # color - HTML color code
  fill: (color) ->
    c = Fz2D.toRGB(color)
    @gl.clearColor(c.r, c.g, c.b, 1.0)

  # Public: Clears the canvas.
  clear: () ->
    @draw_call_count = 0
    @flush_call_count = 0
    @gl.clear(@gl.COLOR_BUFFER_BIT)

  # Public: Flushes the canvas.
  flush: () ->
    return if @_vertex_cache_size == 0
    @flush_call_count++

    @gl.bufferSubData(@gl.ARRAY_BUFFER, 0, @_vertex_cache)
    @gl.drawArrays(@gl.TRIANGLES, 0, @_vertex_cache_size >> 3)

    @_vertex_cache_size = 0

  # Public: Draws a {Fz2D.Texture}.
  #
  # texture - {Fz2D.Texture}
  # sx - source position on the X axis
  # sy - source position on the Y axis
  # sw - source width
  # sh - source height
  # x - desired position on the X axis
  # y - desired position on the Y axis
  # w - desired width
  # h - desired height
  # hw - desired half width
  # hh - desired half height
  # angle - rotation angle
  # alpha - alpha value
  draw: (texture, sx, sy, sw, sh, x, y, w, h, hw, hh, angle, alpha) ->
    @draw_call_count++

    if texture._native._texture_id != @_texture_id
      @flush()

      if texture._native._texture_id
        @gl.bindTexture(@gl.TEXTURE_2D, texture._native._texture_id)
      else
        texture._native._texture_id = @_createTexture(texture._native)
      
      @_texture_id = texture._native._texture_id
 
      @gl.uniform2f(@_texture_loc, texture.iw, texture.ih)
    
    r = x + w
    b = y + h

    sr = sx + sw
    sb = sy + sh
    
    cx = x + hw
    cy = y + hh

    @_vertex_cache[@_vertex_cache_size++] = x
    @_vertex_cache[@_vertex_cache_size++] = y
    @_vertex_cache[@_vertex_cache_size++] = cx
    @_vertex_cache[@_vertex_cache_size++] = cy

    @_vertex_cache[@_vertex_cache_size++] = sx
    @_vertex_cache[@_vertex_cache_size++] = sy
    @_vertex_cache[@_vertex_cache_size++] = angle
    @_vertex_cache[@_vertex_cache_size++] = alpha
    
    @_vertex_cache[@_vertex_cache_size++] = r
    @_vertex_cache[@_vertex_cache_size++] = y
    @_vertex_cache[@_vertex_cache_size++] = cx
    @_vertex_cache[@_vertex_cache_size++] = cy

    @_vertex_cache[@_vertex_cache_size++] = sr
    @_vertex_cache[@_vertex_cache_size++] = sy
    @_vertex_cache[@_vertex_cache_size++] = angle
    @_vertex_cache[@_vertex_cache_size++] = alpha
    
    @_vertex_cache[@_vertex_cache_size++] = x
    @_vertex_cache[@_vertex_cache_size++] = b
    @_vertex_cache[@_vertex_cache_size++] = cx
    @_vertex_cache[@_vertex_cache_size++] = cy

    @_vertex_cache[@_vertex_cache_size++] = sx
    @_vertex_cache[@_vertex_cache_size++] = sb
    @_vertex_cache[@_vertex_cache_size++] = angle
    @_vertex_cache[@_vertex_cache_size++] = alpha
 
    @_vertex_cache[@_vertex_cache_size++] = x
    @_vertex_cache[@_vertex_cache_size++] = b
    @_vertex_cache[@_vertex_cache_size++] = cx
    @_vertex_cache[@_vertex_cache_size++] = cy

    @_vertex_cache[@_vertex_cache_size++] = sx
    @_vertex_cache[@_vertex_cache_size++] = sb
    @_vertex_cache[@_vertex_cache_size++] = angle
    @_vertex_cache[@_vertex_cache_size++] = alpha
 
    @_vertex_cache[@_vertex_cache_size++] = r
    @_vertex_cache[@_vertex_cache_size++] = y
    @_vertex_cache[@_vertex_cache_size++] = cx
    @_vertex_cache[@_vertex_cache_size++] = cy

    @_vertex_cache[@_vertex_cache_size++] = sr
    @_vertex_cache[@_vertex_cache_size++] = sy
    @_vertex_cache[@_vertex_cache_size++] = angle
    @_vertex_cache[@_vertex_cache_size++] = alpha
 
    @_vertex_cache[@_vertex_cache_size++] = r
    @_vertex_cache[@_vertex_cache_size++] = b
    @_vertex_cache[@_vertex_cache_size++] = cx
    @_vertex_cache[@_vertex_cache_size++] = cy

    @_vertex_cache[@_vertex_cache_size++] = sr
    @_vertex_cache[@_vertex_cache_size++] = sb
    @_vertex_cache[@_vertex_cache_size++] = angle
    @_vertex_cache[@_vertex_cache_size++] = alpha
 
    if @_vertex_cache_size == Fz2D.CanvasWebGL.VERTEX_CACHE_MAX_SIZE
      @flush()

  # Private: Creates a GL shader.
  #
  # source - shader source (text)
  # type - shader type
  #
  # Returns the shader or throws an exception.
  _createShader: (source, type) ->
    shader = @gl.createShader(type)

    @gl.shaderSource(shader, source)
    @gl.compileShader(shader)

    unless @gl.getShaderParameter(shader, @gl.COMPILE_STATUS)
      console.log(@gl.getShaderInfoLog(shader))
      throw "Failed to compile shader :("

    shader

  # Private: Creates a GL shader program.
  #
  # vertex - vertex shader source
  # fragment - fragment shader source
  # 
  # Returns the shader program or throws an exception.
  _createShaderProgram: (vertex, fragment) ->
    program = @gl.createProgram()

    vs = @_createShader(vertex, @gl.VERTEX_SHADER)
    fs = @_createShader(fragment, @gl.FRAGMENT_SHADER)

    @gl.attachShader(program, vs)
    @gl.attachShader(program, fs)
    @gl.linkProgram(program)

    unless @gl.getProgramParameter(program, @gl.LINK_STATUS)
      console.log(@gl.glGetProgramInfoLog(program))
      throw "Failed to link shader program :("

    @gl.useProgram(program)

    program

  # Private: Creates a GL texture from an image.
  #
  # image - an image
  # 
  # Returns the texture.
  _createTexture: (image) ->
    texture_id = @gl.createTexture()

    @gl.bindTexture(@gl.TEXTURE_2D, texture_id)
    @gl.texImage2D(@gl.TEXTURE_2D, 0, @gl.RGBA, @gl.RGBA, @gl.UNSIGNED_BYTE, image)

    @gl.texParameteri(@gl.TEXTURE_2D, @gl.TEXTURE_MAG_FILTER, @gl.LINEAR)
    @gl.texParameteri(@gl.TEXTURE_2D, @gl.TEXTURE_MIN_FILTER, @gl.LINEAR)
    @gl.texParameteri(@gl.TEXTURE_2D, @gl.TEXTURE_WRAP_S,     @gl.CLAMP_TO_EDGE)
    @gl.texParameteri(@gl.TEXTURE_2D, @gl.TEXTURE_WRAP_T,     @gl.CLAMP_TO_EDGE)

    # @gl.bindTexture(@gl.TEXTURE_2D, null)

    texture_id
