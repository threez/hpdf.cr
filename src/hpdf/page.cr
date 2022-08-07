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

    # creates a new text annotation object for the page.
    #
    # * *rect* a rectangle where the annotation is displayed
    # * *text* the text to be displayed.
    # * *encoder* an encoder handle which is used to encode the text.
    #   If it is null, PDFDocEncoding is used.
    def create_text_annotation(rect : Rectangle, text : String, encoder : Encoder? = nil) : TextAnnotation
      TextAnnotation.new(LibHaru.page_create_text_annotation(self, rect, text, encoder), @doc, self)
    end

    # creates a new link annotation object for the page.
    #
    # * *rect* a rectangle of clickable area.
    # * *dst* a handle of destination object to jump to.
    def create_link_annotation(rect : Rectangle, dst : Destination) : LinkAnnotation
      LinkAnnotation.new(LibHaru.page_create_link_annotation(self, rect, dst), @doc, self)
    end

    # creates a new web link annotation object for the page.
    #
    # * *rect* a rectangle of clickable area.
    # * *uri* URL of destination to jump to.
    def create_uri_link_annotation(rect : Rectangle, uri : String)
      LinkAnnotation.new(LibHaru.page_create_uri_link_annotation(self, rect, uri), @doc, self)
    end

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
        real(width), bool(word_wrap), out real_width)
      MeasuredText.new(size, real_width)
    end

    # gets the current graphics mode.
    def graphics_mode : GMode
      GMode.new(LibHaru.page_get_g_mode(self))
    end

    # see `graphics_mode`.
    def g_mode
      graphics_mode
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
      Point.new(LibHaru.page_get_current_text_pos(self))
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

    # gets the current transformation matrix of the page.
    def trans_matrix : TransMatrix
      TransMatrix.new(LibHaru.page_get_trans_matrix(self))
    end

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
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_get_char_space(self).to_f32
    end

    # returns the current value of the page's word spacing.
    def word_space : Float32
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_get_word_space(self).to_f32
    end

    # returns the current value of the page's horizontal scaling for text showing.
    def horizontal_scaling : Float32
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_get_horizontal_scalling(self).to_f32
    end

    # returns the current value of the page's text rising.
    def text_rise : Float32
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_get_text_rise(self).to_f32
    end

    # returns the current value of the page's filling color. `rgb_fill` is valid
    # only when the page's filling color space is `ColorSpace::DeviceRgb`.
    def rgb_fill : RGB
      requires_mode GMode::PageDescription, GMode::TextObject
      RGB.new(LibHaru.page_get_rgb_fill(self))
    end

    # returns the current value of the page's stroking color. `rgb_stroke` is
    # valid only when the page's stroking color space is `ColorSpace::DeviceRgb`.
    def rgb_stroke : RGB
      requires_mode GMode::PageDescription, GMode::TextObject
      RGB.new(LibHaru.page_get_rgb_stroke(self))
    end

    # returns the current value of the page's filling color. `cmyk_fill` is
    # valid only when the page's filling color space is `ColorSpace::DeviceCmyk`.
    def cmyk_fill : CMYK
      requires_mode GMode::PageDescription, GMode::TextObject
      CMYK.new(LibHaru.page_get_cmyk_fill(self))
    end

    # returns the current value of the page's stroking color. `cmyk_stroke` is
    # valid only when the page's stroking color space is `ColorSpace::DeviceCmyk`.
    def cmyk_stroke : CMYK
      requires_mode GMode::PageDescription, GMode::TextObject
      CMYK.new(LibHaru.page_get_cmyk_stroke(self))
    end

    # draws the XObject using the current graphics context. This is used
    # by `draw_image` to draw the `Image` by first calling `g_save` and
    # `concat` and then calling `g_restore` after `execute_x_object`.
    # It could be used manually to rotate an image.
    def execute_x_object(image : Image)
      requires_mode GMode::PageDescription
      LibHaru.page_execute_x_object(self, image)
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
    # `set_dash` when the `graphics_mode` of the page is in
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
        raise ArgumentError.new("to many elements in the dash pattern: #{pattern.size}")
      end
      pat = pattern.map { |i| uint16(i) }
      LibHaru.page_set_dash(self, pat, uint(pat.size), uint(phase))
    end

    # applys the graphics state to the page.
    # An application can invoke `ext_g_state=` when the `graphics_mode` of
    # the page is in `GMode::PageDescription`.
    private def ext_g_state=(handle)
      requires_mode GMode::PageDescription
      LibHaru.page_set_ext_g_state(self, handle)
    end

    # saves the page's current graphics parameter to the stack.
    # An application can invoke `g_save` up to 28 and can restore the
    # saved parameter by invoking `g_restore`, when the `graphics_mode` of
    # the page is in `GMode::PageDescription`.
    def g_save
      requires_mode GMode::PageDescription
      LibHaru.page_gsave(self)
    end

    # restore the graphics state which is saved by `g_save`.
    # An application can invoke `g_save` when the `graphics_mode` of the
    # page is in `GMode::PageDescription`.
    def g_restore
      requires_mode GMode::PageDescription
      LibHaru.page_grestore(self)
    end

    # concatenates the page's current transformation matrix and specified
    # matrix. For example, if you want to rotate the coordinate system of the
    # page by 45 degrees, use `concat` as like demonstrated in the `rotate` method.
    # An application can invoke `concat` when the `graphics_mode` of the
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
    # context do
    #   concat Math.cos(rad1), Math.sin(rad1), -Math.sin(rad1),
    #     Math.cos(rad1), 0, 0
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
    # An application can invoke `move_to` when the `graphics_mode` of the
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
    # An application can invoke `line_to` when the `graphics_mode` of
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
    # An application can invoke `rectangle` when the `graphics_mode` of
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
    # An application can invoke `stroke` when the `graphics_mode` of the
    # page is in `GMode::PathObject` or `GMode::ClippingPath`.
    # And it changes the graphics mode to `GMode::PageDescription`.
    def stroke
      requires_mode GMode::PathObject, GMode::ClippingPath
      LibHaru.page_stroke(self)
    end

    # closes the current path, then it paints the path.
    # An application can invoke `close_path_stroke` when the graphics
    # mode of the page is in `GMode::PathObject` or `GMode::ClippingPath`. And it changes the
    # graphics mode to `GMode::PageDescription`.
    def close_path_stroke
      requires_mode GMode::PathObject, GMode::ClippingPath
      LibHaru.page_close_path_stroke(self)
    end

    # fills the current path using the nonzero winding number rule.
    # An application can invoke `fill` when the `graphics_mode` of the`
    # page is in `GMode::PathObject` or `GMode::ClippingPath`. And it changes the graphics mode
    # to `GMode::PageDescription`.
    def fill
      requires_mode GMode::PathObject, GMode::ClippingPath
      LibHaru.page_fill(self)
    end

    # fills the current path using the even-odd rule.
    # An application can invoke `eofill` when the `graphics_mode` of the
    # page is in `GMode::PathObject` or `GMode::ClippingPath`. And it changes the graphics mode
    # to `GMode::PageDescription`.
    def eofill
      requires_mode GMode::PathObject, GMode::ClippingPath
      LibHaru.page_eofill(self)
    end

    # fills the current path using the nonzero winding number rule,
    # then it paints the path. An application can invoke `fill_stroke`
    # when the `graphics_mode` of the page is in `GMode::PathObject` or `GMode::ClippingPath`.
    # And it changes the graphics mode to `GMode::PageDescription`.
    def fill_stroke
      requires_mode GMode::PathObject, GMode::ClippingPath
      LibHaru.page_fill_stroke(self)
    end

    # fills the current path using the even-odd rule, then it paints
    # the path. An application can invoke `eofill_stroke` when the
    # graphics mode of the page is in `GMode::PathObject` or `GMode::ClippingPath`. And it
    # changes the graphics mode to `GMode::PageDescription`.
    def eofill_stroke
      requires_mode GMode::PathObject, GMode::ClippingPath
      LibHaru.page_fill_stroke(self)
    end

    # closes the current path, fills the current path using the
    # nonzero winding number rule, then it paints the path.
    # An application can invoke `close_path_fill_stroke` when the
    # graphics mode of the page is in `GMode::PathObject` or `GMode::ClippingPath`. And it
    # changes the graphics mode to `GMode::PageDescription`.
    def close_path_fill_stroke
      requires_mode GMode::PathObject, GMode::ClippingPath
      LibHaru.page_close_path_fill_stroke(self)
    end

    # closes the current path, fills the current path using the
    # even-odd rule, then it paints the path. An application can
    # invoke `close_path_eofill_stroke` when the `graphics_mode`
    # of the page is in `GMode::PathObject` or `GMode::ClippingPath`. And it changes the
    # graphics mode to `GMode::PageDescription`.
    def close_path_eofill_stroke
      requires_mode GMode::PathObject, GMode::ClippingPath
      LibHaru.page_close_path_eofill_stroke(self)
    end

    # ends the path object without filling and painting operation.
    # An application can invoke `end_path` when the `graphics_mode`
    # of the page is in `GMode::PathObject` or `GMode::ClippingPath`. And it changes the
    # graphics mode to `GMode::PageDescription`.
    def end_path
      requires_mode GMode::PathObject, GMode::ClippingPath
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
    # when the `graphics_mode` of the page is in `GMode::TextObject`.
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
    # An application can invoke `word_space=` when the `graphics_mode`
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

    # returns the current text rendering mode.
    def text_rendering_mode : TextRenderingMode
      TextRenderingMode.new(LibHaru.page_get_text_rendering_mode(self).to_i)
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

    # sets the text rendering mode.
    # The initial value of text rendering mode is `TextRenderingMode::Fill`.
    # An application can invoke `text_rendering_mode=` when the graphics
    # mode of the page is in `GMode::PageDescription` or `GMode::TextObject`.
    def text_rendering_mode=(mode : TextRenderingMode)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_set_text_rendering_mode(self, mode.to_i)
    end

    # moves the text position in vertical direction by the amount of `value`.
    # Useful for making subscripts or superscripts.
    # An application can invoke `text_rise=` when the graphics
    # mode of the page is in `GMode::PageDescription` or `GMode::TextObject`.
    #
    # * *value* text rise, in user space units.
    def text_rise=(value : Number)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_set_text_rise(self, real(value))
    end

    # moves the current text position to the start of the next line with
    # using specified offset values. If the start position of the current
    # line is (x1, y1), the start of the next line is (x1 + x, y1 + y).
    # An application can invoke `move_text_pos` when the `graphics_mode` of
    # the page is in `GMode::TextObject`.
    #
    # * *x*, *y* the offset of the start of the next line.
    def move_text_pos(x : Number, y : Number)
      requires_mode GMode::TextObject
      LibHaru.page_move_text_pos(self, real(x), real(y))
    end

    # changes the current text position, using the specified offset values.
    # If the current text position is (x1, y1), the new text position will
    # be (x1 + x, y1 + y). Also, the text-leading is set to -y.
    # An application can invoke `move_text_pos` when the `graphics_mode` of
    # the page is in `GMode::TextObject`.
    #
    # * *x*, *y* the offset of the start of the next line.
    def page_move_text_pos2(x : Number, y : Number)
      requires_mode GMode::TextObject
      LibHaru.page_move_text_pos2(self, real(x), real(y))
    end

    # `set_text_matrix` sets a transformation matrix for text to be drawn
    # in using `show_text`.
    #
    # * *a* the horizontal rotation of the text. Typically expressed as cosine(Angle)
    # * *b* the vertical rotation of the text. Typically expressed as sine(Angle)
    # * *c*, *d* ?? appear to be controlling offset adjustments after text drawn ???
    # * *x* the page x coordinate
    # * *y* the page y coordinate
    #
    # If the parameter a or d is zero, then the parameters b or c cannot
    # be zero.
    #
    # Text is typically output using the `show_text` function. The function
    # `text_rect` does not use the active text matrix.
    # An application can invoke `set_text_matrix` when the `graphics_mode` of
    # the page is in `GMode::TextObject`.
    def set_text_matrix(a : Number, b : Number, c : Number, d : Number, x : Number, y : Number)
      requires_mode GMode::TextObject
      LibHaru.page_set_text_matrix(self, real(a), real(b), real(c), real(d), real(x), real(y))
    end

    # moves the current text position to the start of the next line.
    # If the start position of the current line is (x1, y1), the start
    # of the next line is (x1, y1 - text leading).
    # An application can invoke `move_to_next_line` when the graphics
    # mode of the page is in `GMode::TextObject`.
    #
    # **NOTE: Since the default value of Text Leading is `0`, an application
    # has to invoke `text_leading=` before `move_to_next_line` to set
    # text leading.**
    def move_to_next_line
      requires_mode GMode::TextObject
      LibHaru.page_move_to_next_line(self)
    end

    # prints the text at the current position on the page.
    # An application can invoke `show_text` when the `graphics_mode` of the
    # page is in `GMode::PageDescription` or `GMode::TextObject`.
    #
    # * *text* the text to print.
    def show_text(text : String)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_show_text(self, text)
    end

    # moves the current text position to the start of the next line,
    # then prints the text at the current position on the page.
    # An application can invoke `show_text_next_line` when the
    # graphics mode of the page is in `GMode::PageDescription` or
    # `GMode::TextObject`.
    def show_text_next_line(text : String)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_show_text_next_line(self, text)
    end

    # moves the current text position to the start of the next line,
    # then sets the word spacing, character spacing and prints the
    # text at the current position on the page.
    # An application can invoke `show_text_next_line_ex` when the
    # graphics mode of the page is in `GMode::TextObject`.
    def show_text_next_line_ex(text : String, word_space : Number, char_space : Number)
      requires_mode GMode::TextObject
      LibHaru.page_show_text_next_line_ex(self, real(word_space), real(char_space), text)
    end

    # sets the filling color.
    # An application can invoke `gray_fill=` when the `graphics_mode`
    # of the page is in `GMode::PageDescription` or `GMode::TextObject`.
    #
    # * *value* the value of the gray level between 0 and 1.
    def gray_fill=(value : Number)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_set_gray_fill(self, real(value))
    end

    # sets the stroking color.
    # An application can invoke `gray_stroke=` when the `graphics_mode`
    # of the page is in `GMode::PageDescription` or `GMode::TextObject`.
    #
    # * *value* the value of the gray level between 0 and 1.
    def gray_stroke=(value : Number)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_set_gray_stroke(self, real(value))
    end

    # sets the filling color.
    # An application can invoke `set_rgb_fill` when the `graphics_mode`
    # of the page is in `GMode::PageDescription` or `GMode::TextObject`.
    #
    # * *r*, *g*, *b* the level of each color element. They must be
    #   between 0 and 1.
    def set_rgb_fill(r : Number, g : Number, b : Number)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_set_rgb_fill(self, real(r), real(g), real(b))
    end

    # sets the stroking color.
    # An application can invoke `set_rgb_stroke` when the `graphics_mode`
    # of the page is in `GMode::PageDescription` or `GMode::TextObject`.
    #
    # * *r*, *g*, *b* the level of each color element. They must be
    #   between 0 and 1.
    def set_rgb_stroke(r : Number, g : Number, b : Number)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_set_rgb_stroke(self, real(r), real(g), real(b))
    end

    # sets the filling color.
    # An application can invoke `set_cmyk_fill` when the `graphics_mode`
    # of the page is in `GMode::PageDescription` or `GMode::TextObject`.
    #
    # * *c*, *m*, *y*, *k* the level of each color element. They must be
    #   between 0 and 1.
    def set_cmyk_fill(c : Number, m : Number, y : Number, k : Number)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_set_cmyk_fill(self, real(c), real(m), real(y), real(k))
    end

    # sets the stroking color.
    # An application can invoke `set_cmyk_stroke` when the `graphics_mode`
    # of the page is in `GMode::PageDescription` or `GMode::TextObject`.
    #
    # * *c*, *m*, *y*, *k* the level of each color element. They must be
    #   between 0 and 1.
    def set_cmyk_stroke(c : Number, m : Number, y : Number, k : Number)
      requires_mode GMode::PageDescription, GMode::TextObject
      LibHaru.page_set_cmyk_stroke(self, real(c), real(m), real(y), real(k))
    end

    # shows an image in one operation.
    # An application can invoke `draw_image` when the `graphics_mode`
    # of the page is in `GMode::PageDescription`.
    #
    # * *image* the image object.
    # * *x*, *y* the lower-left point of the region where image is displayed.
    # * *width* the width of the region where image is displayed.
    # * *height* the width of the region where image is displayed.
    def draw_image(image : Image, x : Number, y : Number, width : Number, height : Number)
      requires_mode GMode::PageDescription
      LibHaru.page_draw_image(self, image, real(x), real(y), real(width), real(height))
    end

    # see `draw_image`.
    def draw_image(image : Image, rect : Rectangle)
      draw_image image, rect.x, rect.y, rect.width, rect.height
    end

    # appends a circle to the current path.
    # An application can invoke `circle` when the `graphics_mode` of the
    # page is in `GMode::PageDescription` or `GMode::PathObject`.
    #
    # * *x*, *y* the center point of the circle.
    # * *ray* the ray of the circle.
    def circle(x : Number, y : Number, ray : Number)
      requires_mode GMode::PageDescription, GMode::PathObject
      LibHaru.page_circle(self, real(x), real(y), real(ray))
    end

    # appends a circle to the current path.
    # An application can invoke `arc` when the `graphics_mode` of the
    # page is in `GMode::PageDescription` or `GMode::PathObject`.
    #
    # * *x*, *y* the center point of the circle.
    # * *ray* the ray of the circle.
    # * *ang1* the angle of the begining of the arc.
    # * *ang2* the angle of the end of the arc. It must be greater than ang1.
    def arc(x : Number, y : Number, ray : Number, ang1 : Number, ang2 : Number)
      requires_mode GMode::PageDescription, GMode::PathObject
      LibHaru.page_arc(self, real(x), real(y), real(ray), real(ang1), real(ang2))
    end

    # prints the text on the specified position.
    # An application can invoke `text_out` when the `graphics_mode`
    # of the page is in `GMode::TextObject`.
    #
    # * *x*, *y* the point position where the text is displayed.
    # * *text* the text to show.
    def text_out(x : Number | Symbol, y : Number | Symbol, text : String)
      requires_mode GMode::TextObject
      if x == :center
        x = (width - text_width(text)) / 2
      end

      if y == :center
        if @font.nil?
          raise ArgumentError.new("no font set, can't calculate y")
        else
          y = height / 2 - @font_size / 2
        end
      end
      LibHaru.page_text_out(self, real(x.as(Number)), real(y.as(Number)), text)
    end

    # print the text inside the specified region. Some chars may not
    # in the displayed in the space, the number of displayed chars is
    # returned.
    # An application can invoke `text_rect` when the `graphics_mode`
    # of the page is in `GMode::TextObject`.
    #
    # * *left*, *top*, *right*, *bottom* coordinates of corners of the
    #   region to output text.
    # * *text* the text to show.
    # * *align* the alignment of the text.
    def text_rect(left : Number, top : Number, right : Number, bottom : Number,
                  text : String, *, align : TextAlignment = TextAlignment::Left) : Number
      requires_mode GMode::TextObject
      LibHaru.page_text_rect(self, real(left), real(top),
        real(right), real(bottom),
        text, align.to_i, out len)
      len
    end

    # ## Helper ###

    def reset_dash
      LibHaru.page_set_dash(self, nil, uint(0), uint(0))
    end

    def use_font(name, size)
      @font = @doc.font(name)
      @font_size = size.to_f32
      set_font_and_size(@font.not_nil!, @font_size)
    end

    def draw_rectangle(x : Number, y : Number, w : Number, h : Number, *, line_width lw = 1)
      @line_width = lw
      rectangle(x, y, w, h)
      stroke
    end

    private def requires_mode(*modes : GMode)
      unless modes.includes? g_mode
        raise ArgumentError.new "expected to be in different graphics mode #{modes}, but was in #{g_mode}"
      end
    end

    # ## DSL ###

    # build enables DSL style access to building a page
    def build
      with self yield self
    end

    def text(name = nil, size = nil, &block)
      if name && size
        use_font(name, size)
      end
      begin_text
      with self yield self
      text_end
    end

    # saves the current graphic state and restores it after
    # the block is completed
    def context
      g_save
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
