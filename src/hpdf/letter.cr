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
    REMARK_HEIGHT        =  17.70 # mm
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
      line_to mm(5), mm(FOLD_MARKER_1)
      stroke

      move_to 0, mm(FOLD_MARKER_2)
      line_to mm(5), mm(FOLD_MARKER_2)
      stroke

      move_to 0, mm(DIN_A5_HEIGHT/2)
      line_to mm(7.5), mm(DIN_A5_HEIGHT/2)
      stroke

      heading Rectangle.new(x: 0,
        y: height - mm(HEADING_HEIGHT),
        width: width,
        height: mm(HEADING_HEIGHT))

      box remark_area_rect

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
      r = remark_area_rect
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
                           font_name : String = Base14::Helvetica)
      line_height = rect.height / rows.size
      font_size = line_height - line_space
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
      Rectangle.new(x: ADDRESS_LEFT,
        y: height - mm(ADDRESS_TOP + REMARK_HEIGHT + POSTAL_HEIGHT),
        width: mm(ADDRESS_WIDTH),
        height: mm(POSTAL_HEIGHT))
    end

    def remark_area_rect : Rectangle
      Rectangle.new(x: ADDRESS_LEFT,
        y: height - mm(ADDRESS_TOP + REMARK_HEIGHT),
        width: mm(ADDRESS_WIDTH),
        height: mm(REMARK_HEIGHT))
    end

    def heading(r : Rectangle)
      box r
    end

    def remark_area(r : Rectangle)
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
