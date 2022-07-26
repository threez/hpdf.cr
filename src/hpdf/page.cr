require "./helper"

module Hpdf
  class Page
    include Helper

    @doc : Doc
    @font : Font?
    @font_size : Float32 = 0

    def initialize(doc)
      @doc = doc
      @page = LibHaru.add_page(doc)
    end

    def to_unsafe
      @page
    end

    def height
      LibHaru.page_get_height(self)
    end

    def width
      LibHaru.page_get_width(self)
    end

    def set_line_width(stroke_width)
      LibHaru.page_set_line_width(self, real(stroke_width))
    end

    def rectangle(x, y, w, h)
      LibHaru.page_rectangle(self, real(x), real(y), real(w), real(h))
    end

    def stroke
      LibHaru.page_stroke(self)
    end

    def set_font_and_size(font : Hpdf::Font, size)
      LibHaru.page_set_font_and_size(self, font, real(size))
    end

    def text_width(text)
      LibHaru.page_text_width(self, text)
    end

    def text_height(text)
      LibHaru.page_text_height(self, text)
    end

    def text(name = nil, size = nil, &block)
      if name && size
        use_font(name, size)
      end
      begin_text
      block.call
    ensure
      text_end
    end

    def begin_text
      LibHaru.page_begin_text(self)
    end

    def text_out(x, y, text)
      if x == :center
        x = (width - text_width(text)) / 2
      end

      if y == :center
        if @font.nil?
          raise Exception.new("no font set, can't calculate y")
        else
          y = height / 2 - @font_size / 2
        end
      end

      LibHaru.page_text_out(self, real(x.as(Number)), real(y.as(Number)), text)
    end

    def text_end
      LibHaru.page_end_text(self)
    end

    def move_text_pos(x, y)
      LibHaru.page_move_text_pos(self, real(x), real(y))
    end

    def show_text(text)
      LibHaru.page_show_text(self, text)
    end

    def use_font(name, size)
      @font = @doc.font(name)
      @font_size = size.to_f32
      set_font_and_size(@font.not_nil!, @font_size)
    end

    def draw_rectangle(x : Number, y : Number, w : Number, h : Number, *, line_width = 1)
      set_line_width(line_width)
      rectangle(x, y, w, h)
      stroke
    end
  end
end
