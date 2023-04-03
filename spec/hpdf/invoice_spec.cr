describe Hpdf::Letter do
  it "creates invoice letters with ease" do
    testdoc "invoice" do
      page Hpdf::LetterDIN5008A do |page|
        draw_markers
        # debug_draw_boxes

        # Header
        draw_address company: "Evil Corp",
          salutation: "Mr.",
          name: "Robot",
          street: "Street 1",
          place: "New York",
          country: "USA"

        draw_remark_area first: "Good Corp | Awesomestr. 20 | 12345 Place"

        draw_infobox Hpdf::Base14::Helvetica, 12 do
          row "Your contact:", "Max Mustermann"
          row "Department:", "Customer Service"
          row
          row "Phone:", "09161 620-9800"
          row "Fax:", "09161 8989-2000"
          row "E-Mail:", "info@goodcorp.com"
          row
          row "Date:", "2022-02-01"
        end

        # Content
        text Hpdf::Base14::HelveticaBold, 12 do
          move_text_pos content_rect.left, content_rect.top - 15
          show_text "Invoice"
        end

        text Hpdf::Base14::Helvetica, 12 do
          page.text_leading = 12 + 12/3
          text_rect content_rect, "\n\n\nThanks for using our services," +
                                  "\n\nplease pay the following bill in the next 30 days." +
                                  "\n\nKind regards your service team"
        end

        table(content_rect.padding(top: 150), fixed_row_height: 22) do
          row do
            text_cell "Position",
              align: Hpdf::TextAlignment::Center,
              font: Hpdf::Base14::HelveticaBold,
              bg_gray: 0.9
            text_cell "Description",
              align: Hpdf::TextAlignment::Center,
              font: Hpdf::Base14::HelveticaBold,
              span: 4,
              bg_gray: 0.9
            text_cell "Quantity",
              align: Hpdf::TextAlignment::Center,
              font: Hpdf::Base14::HelveticaBold,
              bg_gray: 0.9
            text_cell "Price",
              align: Hpdf::TextAlignment::Center,
              font: Hpdf::Base14::HelveticaBold,
              bg_gray: 0.9
            text_cell "Total",
              align: Hpdf::TextAlignment::Center,
              font: Hpdf::Base14::HelveticaBold,
              bg_gray: 0.9
          end
          row do
            text_cell "1"
            text_cell "iPhone 12",
              span: 4
            text_cell "2",
              align: Hpdf::TextAlignment::Right
            text_cell "899.00",
              align: Hpdf::TextAlignment::Right
            text_cell "1798.00",
              align: Hpdf::TextAlignment::Right
          end
          row do
            text_cell "2"
            text_cell "MacBookPro 14\"",
              span: 4
            text_cell "1",
              align: Hpdf::TextAlignment::Right
            text_cell "2499.00",
              align: Hpdf::TextAlignment::Right
            text_cell "2499.00",
              align: Hpdf::TextAlignment::Right
          end
          row do
            text_cell "3"
            text_cell "iPad",
              span: 4
            text_cell "1",
              align: Hpdf::TextAlignment::Right
            text_cell "499.00",
              align: Hpdf::TextAlignment::Right
            text_cell "499.00",
              align: Hpdf::TextAlignment::Right
          end
          row { }
          row do
            text_cell "Total EUR",
              span: 7,
              align: Hpdf::TextAlignment::Right
            text_cell "4796.00",
              font: Hpdf::Base14::HelveticaBold,
              align: Hpdf::TextAlignment::Right,
              bg_gray: 0.9
          end
          row do
            text_cell "incl. VAT 19%",
              span: 7,
              align: Hpdf::TextAlignment::Right
            text_cell "765.75",
              align: Hpdf::TextAlignment::Right,
              bg_gray: 0.9
          end
        end

        text Hpdf::Base14::Helvetica, page_info_rect.height do
          text_rect page_info_rect, "1 of 1 Pages",
            align: Hpdf::TextAlignment::Right
        end

        # Footer
        context do
          page.gray_stroke = 0.5
          page.gray_fill = 0.5
          text Hpdf::Base14::Helvetica, 9 do
            page.text_leading = 10
            text_rect footer_rect, "Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. "
          end
        end
      end
    end
  end
end
