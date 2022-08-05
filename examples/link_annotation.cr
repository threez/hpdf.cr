# Based of http://libharu.sourceforge.net/demo/link_annotation.c

require "../src/hpdf"

class MyPage < Hpdf::Page
  def print_page(font, page_num)
    self.width = 200
    self.height = 200

    set_font_and_size font, 20

    text do
      move_text_pos 50, 150
      show_text "Page:#{page_num}"
    end
  end
end

f = Hpdf::Doc.build do |pdf|
  uri = "http://sourceforge.net/projects/libharu"

  # create default-font
  font = pdf.font "Helvetica"

  # create index page
  index_page = pdf.add_custom_page(MyPage)
  index_page.width = 300
  index_page.height = 220

  # Add 7 pages to the document.
  page = Array(MyPage).new(7) do |i|
    p = pdf.add_custom_page(MyPage)
    p.print_page(font, i + 1)
    p
  end

  index_page.text do
    index_page.set_font_and_size font, 10
    index_page.move_text_pos 15, 200
    index_page.show_text "Link Annotation Demo"
  end

  # Create Link-Annotation object on index page.
  index_page.text do
    rect = Hpdf::Rectangle.new
    index_page.set_font_and_size font, 8
    index_page.move_text_pos 20, 180
    index_page.text_leading = 23

    # page1 (HPDF_ANNOT_NO_HIGHTLIGHT)
    tp = index_page.current_text_pos

    index_page.show_text "Jump to Page1 (HilightMode=HPDF_ANNOT_NO_HIGHTLIGHT)"
    rect.left = tp.x - 4
    rect.bottom = tp.y - 4
    rect.right = index_page.current_text_pos.x + 4
    rect.top = tp.y + 10

    index_page.move_to_next_line

    dst = page[0].create_destination
    annot = index_page.create_link_annotation rect, dst
    annot.highlight_mode = Hpdf::AnnotationHighlightMode::NoHightlight


    # page2 (HPDF_ANNOT_INVERT_BOX)
    tp = index_page.current_text_pos

    index_page.show_text "Jump to Page2 (HilightMode=HPDF_ANNOT_INVERT_BOX)"
    rect.left = tp.x - 4
    rect.bottom = tp.y - 4
    rect.right = index_page.current_text_pos.x + 4
    rect.top = tp.y + 10

    index_page.move_to_next_line

    dst = page[1].create_destination

    annot = index_page.create_link_annotation rect, dst
    annot.highlight_mode = Hpdf::AnnotationHighlightMode::InvertBox


    # page3 (HPDF_ANNOT_INVERT_BORDER)
    tp = index_page.current_text_pos

    index_page.show_text "Jump to Page3 (HilightMode=HPDF_ANNOT_INVERT_BORDER)"
    rect.left = tp.x - 4
    rect.bottom = tp.y - 4
    rect.right = index_page.current_text_pos.x + 4
    rect.top = tp.y + 10

    index_page.move_to_next_line

    dst = page[2].create_destination

    annot = index_page.create_link_annotation rect, dst
    annot.highlight_mode = Hpdf::AnnotationHighlightMode::InvertBorder


    # page4 (HPDF_ANNOT_DOWN_APPEARANCE)
    tp = index_page.current_text_pos

    index_page.show_text "Jump to Page4 (HilightMode=HPDF_ANNOT_DOWN_APPEARANCE)"
    rect.left = tp.x - 4
    rect.bottom = tp.y - 4
    rect.right = index_page.current_text_pos.x + 4
    rect.top = tp.y + 10

    index_page.move_to_next_line

    dst = page[3].create_destination

    annot = index_page.create_link_annotation rect, dst
    annot.highlight_mode = Hpdf::AnnotationHighlightMode::DownAppearance


    # page5 (dash border)
    tp = index_page.current_text_pos

    index_page.show_text "Jump to Page5 (dash border)"
    rect.left = tp.x - 4
    rect.bottom = tp.y - 4
    rect.right = index_page.current_text_pos.x + 4
    rect.top = tp.y + 10

    index_page.move_to_next_line

    dst = page[4].create_destination

    annot = index_page.create_link_annotation rect, dst
    annot.set_border_style 1, 3, 2


    # page6 (no border)
    tp = index_page.current_text_pos

    index_page.show_text "Jump to Page6 (no border)"
    rect.left = tp.x - 4
    rect.bottom = tp.y - 4
    rect.right = index_page.current_text_pos.x + 4
    rect.top = tp.y + 10

    index_page.move_to_next_line

    dst = page[5].create_destination

    annot = index_page.create_link_annotation rect, dst
    annot.set_border_style 0, 0, 0


    # page7 (bold border)
    tp = index_page.current_text_pos

    index_page.show_text "Jump to Page7 (bold border)"
    rect.left = tp.x - 4
    rect.bottom = tp.y - 4
    rect.right = index_page.current_text_pos.x + 4
    rect.top = tp.y + 10

    index_page.move_to_next_line

    dst = page[6].create_destination

    annot = index_page.create_link_annotation rect, dst
    annot.set_border_style 2, 0, 0


    # URI link
    tp = index_page.current_text_pos

    index_page.show_text "URI ("
    index_page.show_text uri
    index_page.show_text ")"

    rect.left = tp.x - 4
    rect.bottom = tp.y - 4
    rect.right = index_page.current_text_pos.x + 4
    rect.top = tp.y + 10

    index_page.create_uri_link_annotation rect, uri
  end
end

# save the document to a file
f.save_to_file "link_annotation.pdf"
