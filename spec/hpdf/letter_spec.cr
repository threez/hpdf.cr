describe Hpdf::Letter do
  it "creates letters with ease" do
    testdoc "letter-5008" do |doc|
      [Hpdf::LetterDIN5008A, Hpdf::LetterDIN5008B].each do |klass|
        page klass do |page|
          draw_markers
          # debug_draw_boxes

          img = doc.load_png_image_from_file("spec/data/header-letter.png")
          draw_image img, 0, height - mm(40), width, mm(40)

          # Header
          draw_address company: "Evil Corp",
            salutation: "Mr.",
            name: "Robot",
            street: "Street 1",
            place: "New York",
            country: "USA"

          draw_remark_area first: "Good Corp | Awesomestr. 20 | 12345 Place",
            second: "second",
            third: "third",
            fourth: "fourth",
            fifth: "fifth"

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
            show_text "Important Notice Form A"
          end

          text Hpdf::Base14::Helvetica, 12 do
            page.text_leading = 12 + 12/3
            text_rect content_rect, "\n\n\nLorem ipsum dolor sit amet," +
                                    "\n\n     consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua." +
                                    "\n\n     Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. " +
                                    "\n\n     Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. " +
                                    "\n\nKind regards"
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
end
