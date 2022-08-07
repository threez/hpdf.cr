require "./page"

module Hpdf
  class Letter < Page

  end

  # Letter following the german national standard for page
  # sizes.
  class LetterDINA4 < Letter
    DIN_A5_HEIGHT = 297 # mm
    DIN_A5_WIDTH = 210 # mm

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

    CONTENT_TOP = 103.46
    CONTENT_LEFT = 25
    CONTENT_RIGHT = 20
    CONTENT_WIDTH = DIN_A5_WIDTH - CONTENT_LEFT - CONTENT_RIGHT
    CONTENT_BOTTOM = 25
    CONTENT_HEIGHT = DIN_A5_HEIGHT - CONTENT_BOTTOM - CONTENT_TOP

    INFOBOX_LEFT = 125
    INFOBOX_TOP = 32
    INFOBOX_BOTTOM = 8.46
    INFOBOX_WIDTH = 75
    INFOBOX_HEIGHT = CONTENT_TOP - INFOBOX_BOTTOM - INFOBOX_TOP

    HEADING_HEIGHT = 27

    RETURN_HEIGHT = 5
    REMARK_HEIGHT = 12.7
    POSTAL_HEIGHT = 27.3
    ADDRESS_LEFT = 20
    ADDRESS_TOP = HEADING_HEIGHT
    ADDRESS_HEIGHT = 45
    ADDRESS_WIDTH = 85
    ADDRESS_PADDING_LEFT = 5

    FOLD_MARKER_1 = 87
    FOLD_MARKER_2 = FOLD_MARKER_1 + 105

    NEXT_PAGE_SEP = 4.23

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

      return_address Rectangle.new(x: ADDRESS_LEFT,
                            y: height - mm(ADDRESS_TOP + RETURN_HEIGHT),
                            width: mm(ADDRESS_WIDTH),
                            height: mm(RETURN_HEIGHT))

      remark Rectangle.new(x: ADDRESS_LEFT,
                           y: height - mm(ADDRESS_TOP + RETURN_HEIGHT + REMARK_HEIGHT),
                           width: mm(ADDRESS_WIDTH),
                           height: mm(REMARK_HEIGHT))

      postal_address postal_address_rect

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

    def draw_address(*, company : String = "",
                        salutation : String = "",
                        name : String = "",
                        street : String = "",
                        place : String = "",
                        country : String = "")
      r = postal_address_rect
      self.gray_stroke = 1
      self.gray_fill = 1
      self.text_leading = 13
      text Base14::Helvetica, 12 do
        move_text_pos r.x + mm(ADDRESS_PADDING_LEFT), r.y + r.height
        show_text company
        show_text_next_line salutation
        show_text_next_line name
        show_text_next_line street
        show_text_next_line place
        show_text_next_line country
      end
    end

    def postal_address_rect : Rectangle
      Rectangle.new(x: ADDRESS_LEFT,
                    y: height - mm(ADDRESS_TOP + RETURN_HEIGHT + REMARK_HEIGHT + POSTAL_HEIGHT),
                    width: mm(ADDRESS_WIDTH),
                    height: mm(POSTAL_HEIGHT))
    end

    def heading(r : Rectangle)
      self.gray_fill = 0.5
      rectangle r
      fill
    end

    def return_address(r : Rectangle)
      self.gray_fill = 0.5
      rectangle r
      fill
    end

    def remark(r : Rectangle)
      self.gray_fill = 0.5
      rectangle r
      fill
    end

    def postal_address(r : Rectangle)
      self.gray_fill = 0.5
      rectangle r
      fill
    end

    def information(r : Rectangle)
      self.gray_fill = 0.5
      rectangle r
      fill
    end

    def content(r : Rectangle)
      self.gray_fill = 0.5
      rectangle r
      fill
    end

    def footer(r : Rectangle)
      self.gray_fill = 0.5
      rectangle r
      fill
    end
  end
end
