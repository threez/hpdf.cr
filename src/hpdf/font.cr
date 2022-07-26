module Hpdf
  class Font
    @doc : Doc

    def initialize(doc, name, encoding)
      @doc = doc
      @font = LibHaru.get_font(@doc, name, encoding)
    end

    def to_unsafe
      @font
    end

    def x_height
      LibHaru.font_get_x_height(self)
    end
  end
end
