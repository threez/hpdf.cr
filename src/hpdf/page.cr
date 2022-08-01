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
    def rotate=(angle : Number)
      LibHaru.page_set_rotate(self, angle.to_u16)
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

    # sets the width of the line used to stroke a path.
    # An application can invoke `line_width=` when the graphics
    # mode of the page is in `GMode::PageDescription` or `GMode::TextObject`.
    #
    # * *line_width* the width of line.
    def line_width=(line_width : Number)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_set_line_width(self, real(line_width))
    end

    # sets the shape to be used at the ends of line.
    # An application can invoke `line_cap=` when the graphics
    # mode of the page is in `GMode::PageDescription` or `GMode::TextObject`.
    #
    # * *line_cap* the style of line-cap.
    def line_cap=(line_cap : LineCap)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_set_line_cap(self, line_cap.to_i)
    end

    # Sets the line join style in the page.
    # An application can invoke `line_join=` when the graphics
    # mode of the page is in `GMode::PageDescription` or `GMode::TextObject`.
    #
    # * *line_join* the style of line-join.
    def line_join=(line_join : LineJoin)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_set_line_join(self, line_join.to_i)
    end

    def miter_limit=(limit : Number)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_set_miter_limit(self, real(limit))
    end

    # Sets the line dash pattern in the page. An application can invoke
    # `set_dash` when the graphics mode of the page is in
    # `GMode::PageDescription` or `GMode::TextObject`.
    #
    # * *pattern* pattern of dashes and gaps used to stroke paths,
    #   can have at most 8 elements.
    # * *phase* the phase in which the pattern begins (default is 0).
    #
    # Samples of the dash pattern:
    # * `set_dash []`
    #   ![http://libharu.sourceforge.net/image/figure16.png](http://libharu.sourceforge.net/image/figure16.png)
    # * `set_dash [3], phase: 1`
    #   ![http://libharu.sourceforge.net/image/figure17.png](http://libharu.sourceforge.net/image/figure17.png)
    # * `set_dash [7, 3], phase: 2`
    #   ![http://libharu.sourceforge.net/image/figure18.png](http://libharu.sourceforge.net/image/figure18.png)
    # * `set_dash [8, 7, 2, 7]`
    #   ![http://libharu.sourceforge.net/image/figure19.png](http://libharu.sourceforge.net/image/figure19.png)
    def set_dash(pattern : Array(Number), *, phase = 0)
      requires_mode GMode::PageDescription, GMode::TextObject
      if pattern.size > 8
        raise Exception.new("to many elements in the dash pattern: #{pattern.size}")
      end
      pat = pattern.map { |i| uint16(i) }
      LibHaru.page_set_dash(self, pat, uint(pat.size), uint(phase))
    end

    # applys the graphics state to the page.
    # An application can invoke `ext_g_state=` when the graphics mode of
    # the page is in `GMode::PageDescription`.
    private def ext_g_state=(handle)
      requires_mode GMode::PageDescription
      LibHaru.page_set_ext_g_state(self, handle)
    end

    # saves the page's current graphics parameter to the stack.
    # An application can invoke `g_save` up to 28 and can restore the
    # saved parameter by invoking `g_restore`, when the graphics mode of
    # the page is in `GMode::PageDescription`.
    def g_save
      requires_mode GMode::PageDescription
      LibHaru.page_gsave(self)
    end

    # restore the graphics state which is saved by `g_save`.
    # An application can invoke `g_save` when the graphics mode of the
    # page is in `GMode::PageDescription`.
    def g_restore
      requires_mode GMode::PageDescription
      LibHaru.page_grestore(self)
    end

    # concatenates the page's current transformation matrix and specified
    # matrix. For example, if you want to rotate the coordinate system of the
    # page by 45 degrees, use `concat` as like demonstrated in the `rotate` method.
    # An application can invoke `concat` when the graphics mode of the
    # page is in `GMode::PageDescription`.
    #
    # ### Example to change the dpi using concat
    #
    # ```
    # concat 72 / dpi, 0, 0, 72 / dpi, 0, 0
    # ```
    #
    # ### Example rotate 45 degrees
    #
    # ```
    # rad1 = degree / 180 * Math::PI
    # graphics do
    #   concat Math.cos(rad1), Math.sin(rad1), -Math.sin(rad1),
    #          Math.cos(rad1), 0, 0
    #   text Hpdf::Base14::Helvetica, 70 do
    #     text_out 100, 100, "Hello World"
    #   end
    # end
    # ```
    def concat(a : Number, b : Number, c : Number, d : Number, x : Number, y : Number)
      requires_mode GMode::PageDescription
      LibHaru.page_concat(self, real(a), real(b), real(c), real(d), real(x), real(y))
    end

    # change the DPI of the page using `concat`
    def dpi=(dpi : Number)
      concat 72 / dpi, 0, 0, 72 / dpi, 0, 0
    end

    # starts a new subpath and move the current point for drawing path,
    # `move_to` sets the start point for the path to the point (x, y)
    # and changes the graphics mode to `GMode::PathObject`.
    #
    # An application can invoke `move_to` when the graphics mode of the
    # page is in `GMode::PageDescription` or `GMode::PathObject`.
    #
    # * *x*, *y* the start point for drawing path
    def move_to(x : Number, y : Number)
      requires_mode GMode::PageDescription, GMode::PathObject
      LibHaru.page_move_to(self, real(x), real(y))
    end

    # see `move_to`
    def move_to(p : Point)
      move_to p.x, p.y
    end

    # appends a path from the current point to the specified point.
    # An application can invoke `line_to` when the graphics mode of
    # the page is in `GMode::PathObject`.
    #
    # * *x*, *y* the end point of the path
    def line_to(x : Number, y : Number)
      requires_mode GMode::PathObject
      LibHaru.page_line_to(self, real(x), real(y))
    end

    # see `line_to`
    def line_to(p : Point)
      line_to p.x, p.y
    end

    # appends a Bézier curve to the current path using two specified points.
    # The point (x1, y1) and the point (x2, y2) are used as the control
    # points for a Bézier curve and current point is moved to the point
    # (x3, y3). An application can invoke `curve_to` when the graphics
    # mode of the page is in `GMode::PathObject`.
    #
    # * *x1*, *y1*, *x2*, *y2*, *x3*, *y3* the control points for a
    #   Bézier curve.
    #
    # ![http://libharu.sourceforge.net/image/figure20.png](http://libharu.sourceforge.net/image/figure20.png)
    def curve_to(x1 : Number, y1 : Number, x2 : Number, y2 : Number, x3 : Number, y3 : Number)
      requires_mode GMode::PathObject
      LibHaru.page_curve_to(self, real(x1), real(y1), real(x2), real(y2), real(x3), real(y3))
    end

    # see `curve_to`
    def curve_to(p1 : Point, p2 : Point, p3 : Point)
      curve_to p1.x, p1.y, p2.x, p2.y, p3.x, p3.y
    end

    # appends a Bézier curve to the current path using two spesified points.
    # The current point and the point (x2, y2) are used as the control
    # points for a Bézier curve and current point is moved to the point
    # (x3, y3). An application can invoke `curve_to2` when the graphics
    # mode of the page is in `GMode::PathObject`.
    #
    # ![http://libharu.sourceforge.net/image/figure21.png](http://libharu.sourceforge.net/image/figure21.png)
    def curve_to2(x1 : Number, y1 : Number, x2 : Number, y2 : Number)
      requires_mode GMode::PathObject
      LibHaru.page_curve_to2(self, real(x1), real(y1), real(x2), real(y2))
    end

    # see `curve_to2`
    def curve_to2(p1 : Point, p2 : Point)
      curve_to2 p1.x, p1.y, p2.x, p2.y
    end

    # appends a Bézier curve to the current path using two spesified points.
    # The point (x1, y1) and the point (x3, y3) are used as the control
    # points for a Bézier curve and current point is moved to the point
    # (x3, y3). An application can invoke `curve_to3` when the graphics
    # mode of the page is in `GMode::PathObject`.
    #
    # ![http://libharu.sourceforge.net/image/figure22.png](http://libharu.sourceforge.net/image/figure22.png)
    def curve_to3(x1 : Number, y1 : Number, x2 : Number, y2 : Number)
      requires_mode GMode::PathObject
      LibHaru.page_curve_to3(self, real(x1), real(y1), real(x2), real(y2))
    end

    # see `curve_to3`
    def curve_to3(p1 : Point, p2 : Point)
      curve_to3 p1.x, p1.y, p2.x, p2.y
    end

    # appends a strait line from the current point to the start point
    # of sub path. The current point is moved to the start point of sub
    # path. An application can invoke `close_path` when the graphics
    # mode of the page is in `GMode::PathObject`.
    def close_path
      requires_mode GMode::PathObject
      LibHaru.page_close_path(self)
    end

    # appends a rectangle to the current path.
    # An application can invoke `rectangle` when the graphics mode of
    # the page is in `GMode::PageDescription` or `GMode::PathObject`.
    def rectangle(x : Number, y : Number, w : Number, h : Number)
      requires_mode GMode::PageDescription, GMode::PathObject
      LibHaru.page_rectangle(self, real(x), real(y), real(w), real(h))
    end

    # see `rectangle`
    def rectangle(r : Rectangle)
      rectangle r.x, r.y, r.width, r.height
    end

    # paints the current path.
    # An application can invoke `stroke` when the graphics mode of the
    # page is in `GMode::PathObject`. And it changes the graphics mode
    # to `GMode::PageDescription`.
    def stroke
      requires_mode GMode::PathObject
      LibHaru.page_stroke(self)
    end

    # closes the current path, then it paints the path.
    # An application can invoke `close_path_stroke` when the graphics
    # mode of the page is in `GMode::PathObject`. And it changes the
    # graphics mode to `GMode::PageDescription`.
    def close_path_stroke
      requires_mode GMode::PathObject
      LibHaru.page_close_path_stroke(self)
    end

    # fills the current path using the nonzero winding number rule.
    # An application can invoke `fill` when the graphics mode of the`
    # page is in `GMode::PathObject`. And it changes the graphics mode
    # to `GMode::PageDescription`.
    def fill
      requires_mode GMode::PathObject
      LibHaru.page_fill(self)
    end

    # fills the current path using the even-odd rule.
    # An application can invoke `eofill` when the graphics mode of the
    # page is in `GMode::PathObject`. And it changes the graphics mode
    # to `GMode::PageDescription`.
    def eofill
      requires_mode GMode::PathObject
      LibHaru.page_eofill(self)
    end

    # fills the current path using the nonzero winding number rule,
    # then it paints the path. An application can invoke `fill_stroke`
    # when the graphics mode of the page is in `GMode::PathObject`.
    # And it changes the graphics mode to `GMode::PageDescription`.
    def fill_stroke
      requires_mode GMode::PathObject
      LibHaru.page_fill_stroke(self)
    end

    # fills the current path using the even-odd rule, then it paints
    # the path. An application can invoke `eofill_stroke` when the
    # graphics mode of the page is in `GMode::PathObject`. And it
    # changes the graphics mode to `GMode::PageDescription`.
    def eofill_stroke
      requires_mode GMode::PathObject
      LibHaru.page_fill_stroke(self)
    end

    # closes the current path, fills the current path using the
    # nonzero winding number rule, then it paints the path.
    # An application can invoke `close_path_fill_stroke` when the
    # graphics mode of the page is in `GMode::PathObject`. And it
    # changes the graphics mode to `GMode::PageDescription`.
    def close_path_fill_stroke
      requires_mode GMode::PathObject
      LibHaru.page_close_path_fill_stroke(self)
    end

    # closes the current path, fills the current path using the
    # even-odd rule, then it paints the path. An application can
    # invoke `close_path_eofill_stroke` when the graphics mode
    # of the page is in `GMode::PathObject`. And it changes the
    # graphics mode to `GMode::PageDescription`.
    def close_path_eofill_stroke
      requires_mode GMode::PathObject
      LibHaru.page_close_path_eofill_stroke(self)
    end

    # ends the path object without filling and painting operation.
    # An application can invoke `end_path` when the graphics mode
    # of the page is in `GMode::PathObject`. And it changes the
    # graphics mode to `GMode::PageDescription`.
    def end_path
      requires_mode GMode::PathObject
      LibHaru.page_end_path(self)
    end

    # `clip` modifies the current clipping path by intersecting
    # it with the current path using the nonzero winding number
    # rule. The clipping path is only modified after the succeeding
    # painting operator. To avoid painting the current path, use
    # the function `end_path`.
    #
    # Following painting operations will only affect the regions of
    # the page contained by the clipping path. Initially, the
    # clipping path includes the entire page. There is no way to
    # enlarge the current clipping path, or to replace the clipping
    # path with a new one. The functions `g_save` and `g_restore`
    # may be used to save and restore the current graphics state,
    # including the clipping path.
    def clip
      requires_mode GMode::PathObject
      LibHaru.page_clip(self)
    end

    # `clip` modifies the current clipping path by intersecting it
    # with the current path using the even-odd rule. The clipping
    # path is only modified after the succeeding painting operator.
    # To avoid painting the current path, use the function `end_path`.
    #
    # Following painting operations will only affect the regions of
    # the page contained by the clipping path. Initially, the
    # clipping path includes the entire page. There is no way to
    # enlarge the current clipping path, or to replace the clipping
    # path with a new one. The functions `g_save` and `g_restore`
    # may be used to save and restore the current graphics state,
    # including the clipping path.
    # HPDF_Page_Clip() modifies the current clipping path by intersecting it with the current path using the even-odd rule. The clipping path is only modified after the succeeding painting operator. To avoid painting the current path, use the function HPDF_Page_EndPath().
    def eoclip
      requires_mode GMode::PathObject
      LibHaru.page_eoclip(self)
    end

    # begins a text object and sets the current text position to
    # the point (0, 0). An application can invoke `begin_text` when
    # the graphics mode of the page is in `GMode::PageDescription`.
    # And it changes the graphics mode to `GMode::TextObject`.
    def begin_text
      requires_mode GMode::PageDescription
      LibHaru.page_begin_text(self)
    end

    # ends a text object. An application can invoke `text_end`
    # when the graphics mode of the page is in `GMode::TextObject`.
    # And it changes the graphics mode to `GMode::PageDescription`.
    def text_end
      requires_mode GMode::TextObject
      LibHaru.page_end_text(self)
    end

    # sets the character spacing for text showing.
    # The initial value of character spacing is 0.
    # An application can invoke `char_space=` when the graphics
    # mode of the page is in `GMode::PageDescription` or `GMode::TextObject`.
    #
    # * *value* the value of character spacing.
    def char_space=(value : Number)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_set_char_space(self, real(value))
    end

    # sets the word spacing for text showing.
    # The initial value of word spacing is 0.
    # An application can invoke `word_space=` when the graphics mode
    # of the page is in `GMode::PageDescription` or `GMode::TextObject`.
    #
    # * *value* the value of word spacing.
    def word_space=(value : Number)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_set_word_space(self, real(value))
    end

    # sets the horizontal scalling for text showing.
    # The initial value of horizontal scalling is 100.
    # An application can invoke `horizontal_scalling=` when the
    # graphics mode of the page is in `GMode::PageDescription` or
    # `GMode::TextObject`.
    def horizontal_scalling=(value : Number)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_set_horizontal_scalling(self, real(value))
    end

    # sets the text leading (line spacing) for text showing.
    # The initial value of leading is 0.
    # An application can invoke `text_leading=` when the graphics
    # mode of the page is in `GMode::PageDescription` or
    # `GMode::TextObject`.
    def text_leading=(value : Number)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_set_text_leading(self, real(value))
    end

    # sets the type of font and size leading.
    # An application can invoke `set_font_and_size` when the graphics
    # mode of the page is in `GMode::PageDescription` or
    # `GMode::TextObject`.
    def set_font_and_size(font : Hpdf::Font, size : Number)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_set_font_and_size(self, font, real(size))
    end

    # see `set_font_and_size`.
    def set_font_and_size(font : String, size : Number)
      set_font_and_size @doc.font(font), size
    end

    ###########################


    def set_rgb_stroke(r, g, b)
      LibHaru.page_set_rgb_stroke(self, real(r), real(g), real(b))
    end

    def set_rgb_fill(r, g, b)
      LibHaru.page_set_rgb_fill(self, real(r), real(g), real(b))
    end



    def clip
      LibHaru.page_clip(self)
    end


    def text_height(text)
      LibHaru.page_text_height(self, text)
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


    def move_text_pos(x, y)
      LibHaru.page_move_text_pos(self, real(x), real(y))
    end

    def show_text(text)
      LibHaru.page_show_text(self, text)
    end


    def show_text_next_line(text)
      LibHaru.page_show_text_next_line(self, text)
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

    ### Helper ###

    def reset_dash
      LibHaru.page_set_dash(self, nil, uint(0), uint(0))
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

    private def requires_mode(*modes : GMode)
      unless modes.includes? g_mode
        raise Exception.new "expected to be in different graphics mode #{modes}, but was in #{g_mode}"
      end
    end

    ### DSL ###

    # build enables DSL style access to building a page
    def build
      with self yield self
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

    def graphics
      g_save  # Save the current graphic state
      with self yield self
      g_restore
    end

    def path(x : Number, y : Number)
      move_to x, y
      with self yield self
      close_path
    end
  end
end
