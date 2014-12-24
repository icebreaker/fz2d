# Public: Branding
class Fz2D.Plugins.Branding extends Fz2D.Plugin
  # Public: Constructor.
  #
  # game - {Fz2D.Game}
  constructor: (game) ->
    return unless game.branding?

    game.assets ?= {}
    game.assets.plugins ?= {}
    game.assets.plugins.branding = game.branding.logo

    game.branding.position ?= 'bottom-right'
    game.branding.border ?= 5
    
  # Public: On load(ed) callback.
  #
  # game - {Fz2D.Game}
  onload: (game) ->
    return unless game.branding?

    @logo = game.assets.plugins.branding
    @w = @logo.w
    @h = @logo.h

    switch game.branding.position
      when 'top-left'
        @x = game.branding.border
        @y = game.branding.border
      when 'top-right'
        @x = game.w - @w - game.branding.border
        @y = game.branding.border
      when 'bottom-left'
        @x = game.branding.border
        @y = game.h - @h - game.branding.border
      when 'bottom-right'
        @x = game.w - @w - game.branding.border
        @y = game.h - @h - game.branding.border

  # Public: Draws branding on every frame.
  #
  # ctx - {Fz2D.Canvas}
  draw: (ctx) ->
    return unless @logo?
    
    ctx.draw(@logo,
             0,
             0,
             @w,
             @h,
             @x,
             @y,
             @w,
             @h)
