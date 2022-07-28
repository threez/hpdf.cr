require "./helper"
require "./enum"

module Hpdf
  class Page
    include Helper

    @font : Font? = nil
    @font_size : Float32 = 0

    def initialize(@page : LibHaru::Page, @doc : Doc)
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

    def line_width=(stroke_width)
      LibHaru.page_set_line_width(self, real(stroke_width))
    end

    def rectangle(x, y, w, h)
      LibHaru.page_rectangle(self, real(x), real(y), real(w), real(h))
    end

    def move_to(x, y)
      LibHaru.page_move_to(self, real(x), real(y))
    end

    def line_to(x, y)
      LibHaru.page_line_to(self, real(x), real(y))
    end

    # dash_pattern - Pattern of dashes and gaps used to stroke paths.
    # num_elem - Number of elements in dash_pattern. 0 <= num_param <= 8.
    # phase - The phase in which the pattern begins (default is 0).
    def set_dash(dash_pattern, *, phase = 0)
      #svalid = [0..8]
      #unless valid.includes?(dash_pattern.size)
      #  raise Exception.new("pattern size #{dash_pattern.size} invalid, size has to be between #{valid}")
      #end
      pat = dash_pattern.map { |i| uint16(i) }
      LibHaru.page_set_dash(self, pat, uint(pat.size), uint(phase))
    end

    def set_rgb_stroke(r, g, b)
      LibHaru.page_set_rgb_stroke(self, real(r), real(g), real(b))
    end

    def set_rgb_fill(r, g, b)
      LibHaru.page_set_rgb_fill(self, real(r), real(g), real(b))
    end

    def set_line_cap(kind : LineCap)
      LibHaru.page_set_line_cap(self, kind)
    end

    def set_line_join(kind : LineJoin)
      LibHaru.page_set_line_join(self, kind)
    end

    def stroke
      LibHaru.page_stroke(self)
    end

    def fill
      LibHaru.page_fill(self)
    end

    def fill_stroke
      LibHaru.page_fill_stroke(self)
    end

    def gsave
      LibHaru.page_gsave(self)
    end

    def grestore
      LibHaru.page_grestore(self)
    end

    def clip
      LibHaru.page_clip(self)
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

    def set_text_leading(lead)
      LibHaru.page_set_text_leading(self, real(lead))
    end

    def show_text_next_line(text)
      LibHaru.page_show_text_next_line(self, text)
    end

    def curve_to(x1, y1, x2, y2, x3, y3)
      LibHaru.page_curve_to(self, x1, y1, x2, y2, x3, y3)
    end

    def curve_to2(x1, y1, x2, y2)
      LibHaru.page_curve_to2(self, x1, y1, x2, y2)
    end

    def curve_to3(x1, y1, x2, y2)
      LibHaru.page_curve_to3(self, x1, y1, x2, y2)
    end

    # shows an image in one operation.
    #
    # * *image* the image object.
    # * *x*, *y* the lower-left point of the region where image is displayed.
    # * *width* the width of the region where image is displayed.
    # * *height* the width of the region where image is displayed.
    def draw_image(image : Image, x : Number, y : Number, width : Number, height : Number)
      LibHaru.page_draw_image(self, image, real(x),real(y),real(width),real(height))
    end

    ### Page Helper

    def reset_dash
      LibHaru.page_set_dash(self, nil, uint(0), uint(0))
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

    def use_font(name, size)
      @font = @doc.font(name)
      @font_size = size.to_f32
      set_font_and_size(@font.not_nil!, @font_size)
    end

    def draw_rectangle(x : Number, y : Number, w : Number, h : Number, *, line_width lw = 1)
      line_width = lw
      rectangle(x, y, w, h)
      stroke
    end

    def with_graphic_state(&block)
      gsave  # Save the current graphic state
      block.call
      grestore
    end
  end
end
