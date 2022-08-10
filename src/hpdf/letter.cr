require "./page"

module Hpdf
  class Letter < Page
  end

  # Letter following the german national standard for page
  # sizes.
  class LetterDINA4 < Letter
    DIN_A5_HEIGHT = 297 # mm
    DIN_A5_WIDTH  = 210 # mm

    # mm converts the passed values to points,
    # usable in PDF documents.
    #
    # * *mm* the value in milimeters
    private def mm(mm : Number) : Number
      height / DIN_A5_HEIGHT * mm
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
    RETURN_HEIGHT        =   5.00 # mm
    REMARK_HEIGHT        =  12.70 # mm
    POSTAL_HEIGHT        =  27.30 # mm
    ADDRESS_LEFT         =  20.00 # mm
    ADDRESS_HEIGHT       =  45.00 # mm
    ADDRESS_WIDTH        =  85.00 # mm
    ADDRESS_PADDING_LEFT =   5.00 # mm
    FOLD_MARKER_1        =  87.00 # mm
    FOLD_MARKER_2_GAP    = 105.00 # mm
    NEXT_PAGE_SEP        =   4.23 # mm

    CONTENT_WIDTH  = DIN_A5_WIDTH - CONTENT_LEFT - CONTENT_RIGHT
    CONTENT_HEIGHT = DIN_A5_HEIGHT - CONTENT_BOTTOM - CONTENT_TOP
    INFOBOX_HEIGHT = CONTENT_TOP - INFOBOX_BOTTOM - INFOBOX_TOP
    ADDRESS_TOP    = HEADING_HEIGHT
    FOLD_MARKER_2  = FOLD_MARKER_1 + FOLD_MARKER_2_GAP

    def draw
      self.gray_stroke = 0
      self.line_width = 1

      move_to 0, mm(FOLD_MARKER_1)
      line_to mm(10), mm(FOLD_MARKER_1)
      stroke

      move_to 0, mm(FOLD_MARKER_2)
      line_to mm(10), mm(FOLD_MARKER_2)
      stroke

      heading Rectangle.new(x: 0,
        y: height - mm(HEADING_HEIGHT),
        width: width,
        height: mm(HEADING_HEIGHT))

      box return_address_rect

      remark Rectangle.new(x: ADDRESS_LEFT,
        y: height - mm(ADDRESS_TOP + REMARK_HEIGHT),
        width: mm(ADDRESS_WIDTH),
        height: mm(REMARK_HEIGHT))

      box postal_address_rect

      information Rectangle.new(x: mm(INFOBOX_LEFT),
        y: height - mm(CONTENT_TOP - INFOBOX_BOTTOM),
        width: mm(INFOBOX_WIDTH),
        height: mm(INFOBOX_HEIGHT))

      content Rectangle.new(x: mm(CONTENT_LEFT),
        y: mm(CONTENT_BOTTOM),
        width: mm(CONTENT_WIDTH),
        height: mm(CONTENT_HEIGHT))

      footer Rectangle.new(x: mm(CONTENT_LEFT),
        y: mm(5),
        width: mm(CONTENT_WIDTH),
        height: mm(15))
    end

    def draw_address(*,
                     company : String = "",
                     salutation : String = "",
                     name : String = "",
                     street : String = "",
                     place : String = "",
                     country : String = "")
      r = postal_address_rect
      self.gray_stroke = 0
      self.gray_fill = 0
      font_size = 12
      line_height = font_size + 1
      self.text_leading = line_height
      text Base14::CourierBold, font_size do
        first_line = line_height * 5 + font.not_nil!.cap_height(font_size) / 2
        move_text_pos r.x + mm(ADDRESS_PADDING_LEFT), r.y + first_line
        show_text company
        show_text_next_line salutation
        show_text_next_line name
        show_text_next_line street
        show_text_next_line place
        show_text_next_line country
      end
    end

    def draw_return_address(text : String)
      r = return_address_rect
      self.gray_stroke = 0.5
      self.gray_fill = 0.5
      font_size = 8
      line_height = r.height
      text Base14::Helvetica, font_size do
        margin = (line_height - font.not_nil!.cap_height(font_size)) / 2
        move_text_pos r.x + mm(ADDRESS_PADDING_LEFT), r.y + margin
        show_text text
      end
    end

    def postal_address_rect : Rectangle
      Rectangle.new(x: ADDRESS_LEFT,
        y: height - mm(ADDRESS_TOP + RETURN_HEIGHT + REMARK_HEIGHT + POSTAL_HEIGHT),
        width: mm(ADDRESS_WIDTH),
        height: mm(POSTAL_HEIGHT))
    end

    def return_address_rect : Rectangle
      Rectangle.new(x: ADDRESS_LEFT,
        y: height - mm(ADDRESS_TOP + RETURN_HEIGHT + REMARK_HEIGHT),
        width: mm(ADDRESS_WIDTH),
        height: mm(RETURN_HEIGHT))
    end

    def heading(r : Rectangle)
      box r
    end

    def return_address(r : Rectangle)
      box r
    end

    def remark(r : Rectangle)
      box r
    end

    def postal_address(r : Rectangle)
      box r
    end

    def information(r : Rectangle)
      box r
    end

    def content(r : Rectangle)
      box r
    end

    def footer(r : Rectangle)
      box r
    end

    private def box(r : Rectangle)
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
