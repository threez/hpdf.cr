module Hpdf
  # An extended graphics state object controls transparency and blend modes
  # for page content. Create one with `Doc#create_ext_g_state`, configure it,
  # then apply it to a page with `Page#ext_g_state=`.
  #
  # ```
  # gs = doc.create_ext_g_state
  # gs.alpha_fill = 0.5
  # gs.blend_mode = Hpdf::BlendMode::Multiply
  # page.ext_g_state = gs
  # ```
  class ExtGState
    include Helper

    def initialize(@ext_g_state : LibHaru::ExtGState, @doc : Doc)
    end

    def to_unsafe
      @ext_g_state
    end

    # sets the stroke alpha (opacity) of the graphics state.
    # *value* must be between `0.0` (fully transparent) and `1.0` (fully opaque).
    def alpha_stroke=(value : Number)
      LibHaru.ext_g_state_set_alpha_stroke(self, real(value))
    end

    # sets the fill alpha (opacity) of the graphics state.
    # *value* must be between `0.0` (fully transparent) and `1.0` (fully opaque).
    def alpha_fill=(value : Number)
      LibHaru.ext_g_state_set_alpha_fill(self, real(value))
    end

    # sets the blend mode of the graphics state. The blend mode controls how
    # painted content is composited with the existing page content.
    # See `BlendMode` for available modes.
    def blend_mode=(mode : BlendMode)
      LibHaru.ext_g_state_set_blend_mode(self, mode.to_u32)
    end
  end
end
