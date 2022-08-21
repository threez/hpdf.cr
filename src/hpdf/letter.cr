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

  # Standard layout defined in DIN5008. With sections for
  # * Heading area
  # * Address area
  #   * Return address / remarks
  #   * Postal address
  # * Information area
  # * Content area
  # * Footer area
  abstract class LetterDIN5008 < LetterDINA4
    INFOBOX_LEFT         = 125.00 # mm
    INFOBOX_WIDTH        =  75.00 # mm
    INFOBOX_BOTTOM       =   8.46 # mm
    CONTENT_BOTTOM       =  35.00 # mm
    CONTENT_LEFT         =  25.00 # mm
    CONTENT_RIGHT        =  20.00 # mm
    CONTENT_TOP          = 103.46 # mm
    ADDRESS_LEFT         =  20.00 # mm
    ADDRESS_HEIGHT       =  45.00 # mm
    ADDRESS_WIDTH        =  85.00 # mm
    ADDRESS_PADDING_LEFT =   5.00 # mm
    REMARK_HEIGHT        =  17.70 # mm
    POSTAL_HEIGHT        =  27.30 # mm
    NEXT_PAGE_SEP        =   4.23 # mm
    FOLD_MARKER_SMALL    =  87.00 # mm
    FOLD_MARKER_LARGE    = 105.00 # mm
    PAGE_INFO_BOTTOM     =  23.00 # mm

    CONTENT_WIDTH  = DIN_A4_WIDTH - CONTENT_LEFT - CONTENT_RIGHT
    CONTENT_HEIGHT = DIN_A4_HEIGHT - CONTENT_BOTTOM - CONTENT_TOP

    class InfoBox
      # Create`s a new infromation box. It is a key value like table.
      def initialize
        @rows = Array(Tuple(String, String)).new
      end

      # adds a row to the info box. To add an empty row
      # keep *key* and *value* as empty strings.
      #
      # * *key* the left side of the info box
      # * *value* the right side of the info box
      def row(key : String = "", value : String = "")
        @rows << {key, value}
      end

      # returns all keys
      def keys : Array(String)
        @rows.map { |row| row[0] }
      end

      # returns all values
      def values : Array(String)
        @rows.map { |row| row[1] }
      end

      # returns the longest key of all given rows
      def longest_key
        @rows.sort do |a, b|
          a[0].grapheme_size <=> b[0].grapheme_size
        end.last[0]
      end
    end

    # draws the infobox section using the passed font and size.
    #
    # * *font* the name of the font to use
    # * *font_size* the size of the font to use
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

    # draws boxes around all sections of the page for debugging purposes
    def debug_draw_boxes
      draw_box heading_rect
      draw_box remark_area_rect
      draw_box postal_address_rect
      draw_box content_rect
      draw_box information_rect
      draw_box footer_rect
      draw_box page_info_rect
    end

    # draws markers for whole making and folding
    def draw_markers
      draw_marker at: mm(DIN_A4_HEIGHT)/2,
        width: mm(7.5)
      draw_marker at: mm(fold_marker_1),
        width: mm(5)
      draw_marker at: mm(fold_marker_2),
        width: mm(5)
    end

    # draws the address as specified by the given fields. The order of the
    # fields is:
    # * *company* (1)
    # * *salutation* (2)
    # * *name* (3)
    # * *street* (4)
    # * *place* (5)
    # * *country* (6)
    #
    # Use *gray* to change the text color.
    def draw_address(*,
                     company : String = "",
                     salutation : String = "",
                     name : String = "",
                     street : String = "",
                     place : String = "",
                     country : String = "",
                     gray : Number = 0)
      context do
        self.gray_fill = gray
        draw_multirow_text rect: postal_address_rect,
          rows: [company, salutation, name, street, place, country],
          padding_left: mm(ADDRESS_PADDING_LEFT),
          font_name: Base14::CourierBold
      end
    end

    # draws remarks on top of the address area. *fifth* is the last
    # line of the remark area, *first* is the first line of the area.
    # Use *gray* to change the text color.
    def draw_remark_area(*,
                         first : String = "",
                         second : String = "",
                         third : String = "",
                         fourth : String = "",
                         fifth : String = "",
                         gray : Number = 0.5)
      context do
        self.gray_fill = gray
        draw_multirow_text rect: remark_area_rect,
          rows: [fifth, fourth, third, second, first],
          padding_left: mm(ADDRESS_PADDING_LEFT)
      end
    end

    # the rectangle for the address section
    def postal_address_rect : Rectangle
      Rectangle.new(x: mm(ADDRESS_LEFT),
        y: height - mm(address_top + REMARK_HEIGHT + POSTAL_HEIGHT),
        width: mm(ADDRESS_WIDTH),
        height: mm(POSTAL_HEIGHT))
    end

    # the rectangle for address and other remarks
    def remark_area_rect : Rectangle
      Rectangle.new(x: mm(ADDRESS_LEFT),
        y: height - mm(address_top + REMARK_HEIGHT),
        width: mm(ADDRESS_WIDTH),
        height: mm(REMARK_HEIGHT))
    end

    # the rectangle for the content section
    def content_rect : Rectangle
      Rectangle.new(x: mm(CONTENT_LEFT),
        y: mm(CONTENT_BOTTOM),
        width: mm(CONTENT_WIDTH),
        height: mm(CONTENT_HEIGHT))
    end

    # the rectangle for the information section
    def information_rect : Rectangle
      Rectangle.new(x: mm(INFOBOX_LEFT),
        y: height - mm(CONTENT_TOP - INFOBOX_BOTTOM),
        width: mm(INFOBOX_WIDTH),
        height: mm(infobox_height))
    end

    # the rectangle for the header section
    def heading_rect : Rectangle
      Rectangle.new(x: 0,
        y: height - mm(address_top),
        width: width,
        height: mm(address_top))
    end

    # the rectangle where to place current page
    # and number of pages information
    def page_info_rect : Rectangle
      Rectangle.new(x: mm(CONTENT_LEFT),
        y: mm(PAGE_INFO_BOTTOM) + mm(NEXT_PAGE_SEP),
        width: mm(CONTENT_WIDTH),
        height: mm(NEXT_PAGE_SEP))
    end

    # the rectangle where to place the footer information
    def footer_rect : Rectangle
      Rectangle.new(x: mm(CONTENT_LEFT),
        y: mm(10),
        width: mm(CONTENT_WIDTH),
        height: mm(15))
    end

    # draws a merker for page folding or whole making.
    #
    # * *at* the position on the y axis
    # * *width* the width of the marker
    def draw_marker(at : Number, width : Number)
      self.gray_stroke = 0
      self.line_width = 1
      context do
        move_to 0, at
        line_to width, at
        stroke
      end
    end

    # visualize a rect on the page
    private def draw_box(r : Rectangle)
      self.gray_fill = 0.9
      rectangle r
      fill
      self.gray_stroke = 0.3
      draw_rectangle r.x, r.y, r.width, r.height
    end

    # draws a text into multiple rows, like a single column table
    private def draw_multirow_text(rect : Rectangle,
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
  end

  # ![https://upload.wikimedia.org/wikipedia/commons/6/64/DIN_5008%2C_Form_A.svg](https://upload.wikimedia.org/wikipedia/commons/6/64/DIN_5008%2C_Form_A.svg)
  class LetterDIN5008A < LetterDIN5008
    HEADING_HEIGHT = 27.00 # mm
    INFOBOX_TOP    = 32.00 # mm

    def infobox_height
      CONTENT_TOP - INFOBOX_BOTTOM - INFOBOX_TOP
    end

    def fold_marker_1
      DIN_A4_HEIGHT - FOLD_MARKER_SMALL
    end

    def fold_marker_2
      FOLD_MARKER_LARGE
    end

    def address_top
      HEADING_HEIGHT
    end
  end

  # ![https://upload.wikimedia.org/wikipedia/commons/0/00/DIN_5008_Form_B.svg](https://upload.wikimedia.org/wikipedia/commons/0/00/DIN_5008_Form_B.svg)
  class LetterDIN5008B < LetterDIN5008
    HEADING_HEIGHT = 45.00 # mm
    INFOBOX_TOP    = 50.00 # mm

    def infobox_height
      CONTENT_TOP - INFOBOX_BOTTOM - INFOBOX_TOP
    end

    def fold_marker_1
      FOLD_MARKER_SMALL
    end

    def fold_marker_2
      DIN_A4_HEIGHT - FOLD_MARKER_LARGE
    end

    def address_top
      HEADING_HEIGHT
    end
  end
end
