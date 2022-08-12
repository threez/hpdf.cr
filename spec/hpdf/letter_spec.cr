describe Hpdf::Letter do
  it "creates letters with ease" do
    testdoc "letter-5008-a" do
      page Hpdf::LetterDIN5008A do |page|
        draw_markers
        draw_boxes

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

                         page.gray_stroke = 0
                         page.gray_fill = 0

        # draw_infobox [
        #   infobox_kv(""),
        #   infobox_empty_line,
        # ]

        # Content
        text Hpdf::Base14::HelveticaBold, 12 do
          move_text_pos content_rect.y, content_rect.top - 12
          show_text "Important Notice"
        end

        text Hpdf::Base14::Helvetica, 12 do
          page.text_leading  = 12 + 12/3
          text_rect content_rect, "\n\n\nLorem ipsum dolor sit amet,"+
          "\n\n     consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua." +
          "\n\n     Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. " +
          "\n\n     Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. " +
          "\n\nKind regards"
        end
      end
    end
  end
end
