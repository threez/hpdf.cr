require "./helper"
require "./enum"

module Hpdf
  # The page handle is used to operate an individual page.
  # When `Doc#add_page` or `Doc#insert_page` is invoked, a page object
  # is created.
  class Page
    include Helper

    @font : Font? = nil
    @font_size : Float32 = 0

    def initialize(@page : LibHaru::Page, @doc : Doc)
    end

    def to_unsafe
      @page
    end

    # changes the width of a page.
    #
    # * *w* Specify the new width of a page. The valid value is between 3 and 14400.
    def width=(w : Number)
      LibHaru.page_set_width(self, uint(w))
    end

    # changes the height of a page.
    #
    # * *h* Specify the new height of a page. The valid value is between 3 and 14400.
    def height=(h : Number)
      LibHaru.page_set_height(self, uint(h))
    end

    # changes the size and direction of a page to a predefined size.
    #
    # * *size* Specify a predefined page-size value. The following values are available.
    # * *direction* Specify the direction of the page.
    def set_size(size : PageSizes,
                 direction : PageDirection = PageDirection::Portrait)
      LibHaru.page_set_size(self, size.to_i32, direction.to_i32)
    end

    # sets rotation angle of the page.
    #
    # * *angle* Specify the rotation angle of the page. It must be a
    #   multiple of 90 Degrees.
    def rotate=(angle : Uint16)
      LibHaru.page_set_rotate(self, angle)
    end

    # gets the height of a page.
    def height : Int32
      LibHaru.page_get_height(self).to_i
    end

    # gets the width of a page.
    def width : Int32
      LibHaru.page_get_width(self).to_i
    end

    # creates a new destination object for the page.
    def create_destination : Destination
      Destination.new(LibHaru.page_create_destination(self), @doc)
    end

    # TODO HPDF_Page_CreateTextAnnot
    # TODO HPDF_Page_CreateLinkAnnot
    # TODO HPDF_Page_CreateURILinkAnnot

    # gets the width of the text in current fontsize, character spacing and word spacing.
    def text_width(text : String) : Float32
      LibHaru.page_text_width(self, text).to_f32
    end

    # calculates the byte length which can be included within the specified width.
    #
    # * *text* the text to get the width for.
    # * *width* The width of the area to put the text.
    # * *word_wrap* When there are three words of `"ABCDE FGH IJKL"`, and the substring
    #   until `"J"` can be included within the width, if *word_wrap* parameter is `false`
    #   it returns `12`,  and if word_wrap parameter is `false` *word_wrap* parameter is
    #   `false` it returns `10` (the end of the previous word).
    def measure_text(text : String, *, width : Number, word_wrap : Bool = true) : MeasuredText
      size = LibHaru.page_measure_text(self, text,
        real(width),  bool(word_wrap), out real_width)
      return MeasuredText.new(size, real_width)
    end

    # gets the current graphics mode.
    def g_mode : GMode
      GMode.new(LibHaru.page_get_g_mode(self))
    end

    # gets the current position for path painting. It returns a `Point`
    # struct indicating the current position for path painting of the page.
    # Otherwise it returns a `Point` struct of {0, 0}.
    #
    # An application can invoke `#current_pos` only when graphics mode is `GMode::PathObject`.
    def current_pos : Point
      Point.new(LibHaru.page_get_current_pos(self))
    end

    # gets the current position for text showing. It returns a `Point` struct
    # indicating the current position for text showing of the page.
    # Otherwise it returns a `Point` struct of {0, 0}.
    #
    # An application can invoke `current_text_pos` only when graphics
    # mode is `GMode::TextObject`.
    def current_text_pos : Point
      Point.new(LibHaru.page_get_current_pos(self))
    end

    # gets the handle of the page's current font.
    def current_font : Font?
      f = LibHaru.page_get_current_font(self)
      Font.new(f, @doc) unless f.null?
    end

    # gets the size of the page's current font. It returns the size of the
    # page's current font. Otherwise it returns 0.
    def current_font_size : Float32
      LibHaru.page_get_current_font_size(self).to_f32
    end

    # TODO HPDF_Page_GetTransMatrix

    # gets the current line width of the page. It returns the current
    # line width for path painting of the page. Otherwise it returns 1.
    def line_width : Float32
      LibHaru.page_get_line_width(self).to_f32
    end

    # gets the current line cap style of the page.
    def line_cap : LineCap
      LineCap.new(LibHaru.page_get_line_cap(self).to_i32)
    end

    # gets the current line join style of the page
    def line_join : LineJoin
      LineJoin.new(LibHaru.page_get_line_join(self).to_i32)
    end

    # gets the current value of the page's miter limit.
    def miter_limit : Float32
      LibHaru.page_get_miter_limit(self).to_f32
    end

    # gets the current pattern of the page.
    # First argument is the pattern, second is the phase.
    def dash : {Array(Int32), Int32}
      mode = LibHaru.page_get_dash(self)
      pattern = Array(Int32).new
      mode.num_ptn.times do |i|
        pattern << mode.ptn[i].to_i32
      end
      {pattern, mode.phase.to_i32}
    end

    # gets the current value of the page's flatness.
    def flat : Float32
      LibHaru.page_get_flat(self).to_f32
    end

    # gets the current value of the page's character spacing.
    def char_space : Float32
      LibHaru.page_get_char_space(self).to_f32
    end

    # returns the current value of the page's word spacing.
    def word_space : Float32
      LibHaru.page_get_word_space(self).to_f32
    end

    # returns the current value of the page's horizontal scaling for text showing.
    def horizontal_scaling : Float32
      LibHaru.page_get_horizontal_scalling(self).to_f32
    end

    # TODO HPDF_Page_GetTextRenderingMode

    # returns the current value of the page's text rising.
    def text_rise : Float32
      LibHaru.page_get_text_rise(self).to_f32
    end

    # returns the current value of the page's filling color. `rgb_fill` is valid
    # only when the page's filling color space is `ColorSpace::DeviceRgb`.
    def rgb_fill : RGB
      RGB.new(LibHaru.page_get_rgb_fill(self))
    end

    # returns the current value of the page's stroking color. `rgb_stroke` is
    # valid only when the page's stroking color space is `ColorSpace::DeviceRgb`.
    def rgb_stroke : RGB
      RGB.new(LibHaru.page_get_rgb_stroke(self))
    end

    # returns the current value of the page's filling color. `cmyk_fill` is
    # valid only when the page's filling color space is `ColorSpace::DeviceCmyk`.
    def cmyk_fill : CMYK
      CMYK.new(LibHaru.page_get_cmyk_fill(self))
    end

    # returns the current value of the page's stroking color. `cmyk_stroke` is
    # valid only when the page's stroking color space is `ColorSpace::DeviceCmyk`.
    def cmyk_stroke : CMYK
      CMYK.new(LibHaru.page_get_cmyk_stroke(self))
    end

    # returns the current value of the page's filling color. `gray_fill` is
    # valid only when the page's stroking color space is `ColorSpace::DeviceGray`.
    def gray_fill : Float32
      LibHaru.page_get_gray_fill(self).to_f32
    end

    # returns the current value of the page's stroking color. `gray_fill` is
    # valid only when the page's stroking color space is `ColorSpace::DeviceGray`.
    def gray_stroke : Float32
      LibHaru.page_get_gray_stroke(self).to_f32
    end

    # returns the current value of the page's stroking color space.
    def stroking_color_space : ColorSpace
      ColorSpace.new(LibHaru.page_get_stroking_color_space(self).to_i32)
    end

    # returns the current value of the page's stroking color space.
    def filling_color_space : ColorSpace
      ColorSpace.new(LibHaru.page_get_filling_color_space(self).to_i32)
    end

    # HPDF_Page_GetTextMatrix

    # returns the number of the page's graphics state stack.
    def g_state_depth : Int32
      LibHaru.page_get_g_state_depth(self).to_i32
    end

    # configures the setting for slide transition of the page.
    #
    # * *style* the transition style.
    # * *disp_time* the display duration of the page. (in seconds)
    # * *trans_time* the duration of the transition effect. Default value is 1 (second).
    def set_slide_show(style : TransitionStyle, disp_time : Number, trans_time : Number = 1)
      LibHaru.page_set_slide_show(self, style.to_i, real(disp_time), real(trans_time))
    end

    ###########################

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
      with self yield
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
