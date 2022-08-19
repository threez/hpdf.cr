require "./page"

module Hpdf
  class Letter < Page
  end

  # Letter following the german national standard for page
  # sizes.
  class LetterDINA4 < Letter
    DIN_A4_HEIGHT = 297 # mm
    DIN_A4_WIDTH  = 210 # mm

    # mm converts the passed values to points,
    # usable in PDF documents.
    #
    # * *mm* the value in milimeters
    private def mm(mm : Number) : Number
      height / DIN_A4_HEIGHT * mm
    end
  end

  # Standard layout A defined in DIN5008. With sections for
  # * Heading area
  # * Address area
  #   * Return address / remarks
  #   * Postal address
  # * Information area
  # * Content area
  # * Footer area
  #
  # ![https://de.wikipedia.org/wiki/DIN_5008#/media/Datei:DIN_5008,_Form_A.svg](https://de.wikipedia.org/wiki/DIN_5008#/media/Datei:DIN_5008,_Form_A.svg)
  class LetterDIN5008A < LetterDINA4
    CONTENT_TOP          = 103.46 # mm
    CONTENT_LEFT         =  25.00 # mm
    CONTENT_RIGHT        =  20.00 # mm
    CONTENT_BOTTOM       =  25.00 # mm
    INFOBOX_LEFT         = 125.00 # mm
    INFOBOX_TOP          =  32.00 # mm
    INFOBOX_BOTTOM       =   8.46 # mm
    INFOBOX_WIDTH        =  75.00 # mm
    HEADING_HEIGHT       =  27.00 # mm
    REMARK_HEIGHT        =  17.70 # mm
    POSTAL_HEIGHT        =  27.30 # mm
    ADDRESS_LEFT         =  20.00 # mm
    ADDRESS_HEIGHT       =  45.00 # mm
    ADDRESS_WIDTH        =  85.00 # mm
    ADDRESS_PADDING_LEFT =   5.00 # mm
    FOLD_MARKER_1        =  87.00 # mm
    FOLD_MARKER_2_GAP    = 105.00 # mm
    NEXT_PAGE_SEP        =   4.23 # mm

    CONTENT_WIDTH  = DIN_A4_WIDTH - CONTENT_LEFT - CONTENT_RIGHT
    CONTENT_HEIGHT = DIN_A4_HEIGHT - CONTENT_BOTTOM - CONTENT_TOP
    INFOBOX_HEIGHT = CONTENT_TOP - INFOBOX_BOTTOM - INFOBOX_TOP
    ADDRESS_TOP    = HEADING_HEIGHT
    FOLD_MARKER_2  = FOLD_MARKER_1 + FOLD_MARKER_2_GAP

    class InfoBox
      getter rows : Array(Tuple(String, String))

      def initialize
        @rows = Array(Tuple(String, String)).new
      end

      def row(key : String = "", value : String = "")
        @rows << {key, value}
      end

      def keys : Array(String)
        @rows.map { |row| row[0] }
      end

      def values : Array(String)
        @rows.map { |row| row[1] }
      end

      def longest_key
        @rows.sort do |a, b|
          a[0].grapheme_size <=> b[0].grapheme_size
        end.last[0]
      end
    end

    def draw_infobox(font : String, font_size = Number)
      infobox = InfoBox.new
      v = with infobox yield

      padding = text font, font_size do |page|
        page.measure_text_width(infobox.longest_key).real_width
      end

      draw_multirow_text rect: information_rect,
        rows: infobox.keys,
        padding_left: 0,
        font_name: font,
        font_size: font_size,
        line_height: font_size * 1.3

      draw_multirow_text rect: information_rect,
        rows: infobox.values,
        padding_left: padding + mm(2.5),
        font_name: font,
        font_size: font_size,
        line_height: font_size * 1.3

      v
    end

    def draw_boxes
      draw_box heading_rect
      draw_box remark_area_rect
      draw_box postal_address_rect
      draw_box content_rect
      draw_box information_rect
      draw_box footer_rect
    end

    def draw_markers
      draw_marker at: mm(DIN_A4_HEIGHT)/2,
        width: mm(7.5)
      draw_marker at: mm(FOLD_MARKER_1),
        width: mm(5)
      draw_marker at: mm(FOLD_MARKER_2),
        width: mm(5)
    end

    def draw_address(*,
                     company : String = "",
                     salutation : String = "",
                     name : String = "",
                     street : String = "",
                     place : String = "",
                     country : String = "")
      self.gray_stroke = 0
      self.gray_fill = 0
      draw_multirow_text rect: postal_address_rect,
        rows: [company, salutation, name, street, place, country],
        padding_left: mm(ADDRESS_PADDING_LEFT),
        font_name: Base14::CourierBold
    end

    def draw_remark_area(*,
                         first : String = "",
                         second : String = "",
                         third : String = "",
                         fourth : String = "",
                         fifth : String = "")
      self.gray_stroke = 0.5
      self.gray_fill = 0.5
      draw_multirow_text rect: remark_area_rect,
        rows: [fifth, fourth, third, second, first],
        padding_left: mm(ADDRESS_PADDING_LEFT)
    end

    def draw_multirow_text(rect : Rectangle,
                           rows : Array(String),
                           padding_left : Number,
                           line_space : Number = 1,
                           font_name : String = Base14::Helvetica,
                           font_size : Number = -1,
                           line_height : Number = -1)
      line_height = rect.height / rows.size if line_height == -1 # auto calc
      font_size = line_height - line_space if font_size == -1    # auto calc
      self.text_leading = line_height
      text font_name, font_size do
        first_line = line_height * (rows.size - 1) + font.not_nil!.cap_height(font_size) / 2
        move_text_pos rect.x + padding_left, rect.y + first_line
        rows.each_with_index do |text, i|
          if i == 0
            show_text text
          else
            show_text_next_line text
          end
        end
      end
    end

    def postal_address_rect : Rectangle
      Rectangle.new(x: mm(ADDRESS_LEFT),
        y: height - mm(ADDRESS_TOP + REMARK_HEIGHT + POSTAL_HEIGHT),
        width: mm(ADDRESS_WIDTH),
        height: mm(POSTAL_HEIGHT))
    end

    def remark_area_rect : Rectangle
      Rectangle.new(x: mm(ADDRESS_LEFT),
        y: height - mm(ADDRESS_TOP + REMARK_HEIGHT),
        width: mm(ADDRESS_WIDTH),
        height: mm(REMARK_HEIGHT))
    end

    def content_rect : Rectangle
      Rectangle.new(x: mm(CONTENT_LEFT),
        y: mm(CONTENT_BOTTOM),
        width: mm(CONTENT_WIDTH),
        height: mm(CONTENT_HEIGHT))
    end

    def information_rect : Rectangle
      Rectangle.new(x: mm(INFOBOX_LEFT),
        y: height - mm(CONTENT_TOP - INFOBOX_BOTTOM),
        width: mm(INFOBOX_WIDTH),
        height: mm(INFOBOX_HEIGHT))
    end

    def heading_rect : Rectangle
      Rectangle.new(x: 0,
        y: height - mm(HEADING_HEIGHT),
        width: width,
        height: mm(HEADING_HEIGHT))
    end

    def footer_rect : Rectangle
      Rectangle.new(x: mm(CONTENT_LEFT),
        y: mm(5),
        width: mm(CONTENT_WIDTH),
        height: mm(15))
    end

    def draw_marker(at : Number, width : Number)
      self.gray_stroke = 0
      self.line_width = 1
      context do
        move_to 0, at
        line_to width, at
        stroke
      end
    end

    private def draw_box(r : Rectangle)
      # self.gray_fill = 0.5
      # rectangle r
      # fill
      self.gray_fill = 0.9
      rectangle r
      fill
      self.gray_stroke = 0.3
      draw_rectangle r.x, r.y, r.width, r.height
    end
  end
end
