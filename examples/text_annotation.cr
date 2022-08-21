# Based of http://libharu.sourceforge.net/demo/text_annotation.c

require "../src/hpdf"

f = Hpdf::Doc.build do |pdf|
  rect1 = Hpdf::Rectangle.new 50, 350, 150, 400
  rect2 = Hpdf::Rectangle.new 210, 350, 350, 400
  rect3 = Hpdf::Rectangle.new 50, 250, 150, 300
  rect4 = Hpdf::Rectangle.new 210, 250, 350, 300
  rect5 = Hpdf::Rectangle.new 50, 150, 150, 200
  rect6 = Hpdf::Rectangle.new 210, 150, 350, 200
  rect7 = Hpdf::Rectangle.new 50, 50, 150, 100
  rect8 = Hpdf::Rectangle.new 210, 50, 350, 100

  page do |page|
    # use Times-Roman font.
    font = pdf.font "Times-Roman", "WinAnsiEncoding"

    page.width = 400
    page.height = 500

    text do
      set_font_and_size font, 16
      move_text_pos 130, 450
      show_text "Annotation Demo"
    end

    annot = create_text_annotation rect1, "Annotation with Comment Icon. \n This annotation set to be opened initially."
    annot.icon = Hpdf::AnnotationIcon::Comment
    annot.opened = true

    annot = create_text_annotation rect2, "Annotation with Key Icon"
    annot.icon = Hpdf::AnnotationIcon::Paragraph

    annot = create_text_annotation rect3, "Annotation with Note Icon"
    annot.icon = Hpdf::AnnotationIcon::Note

    annot = create_text_annotation rect4, "Annotation with Help Icon"
    annot.icon = Hpdf::AnnotationIcon::Help

    annot = create_text_annotation rect5, "Annotation with NewParagraph Icon"
    annot.icon = Hpdf::AnnotationIcon::NewParagraph

    annot = create_text_annotation rect6, "Annotation with Paragraph Icon"
    annot.icon = Hpdf::AnnotationIcon::Paragraph

    annot = create_text_annotation rect7, "Annotation with Insert Icon"
    annot.icon = Hpdf::AnnotationIcon::Insert

    encoding = pdf.find_encoder "ISO8859-2"

    create_text_annotation rect8, "Annotation with ISO8859 text стужвьы", encoding

    set_font_and_size font, 11

    text do
      move_text_pos rect1.left + 35, rect1.top - 20
      show_text "Comment Icon."
    end

    text do
      move_text_pos rect2.left + 35, rect2.top - 20
      show_text "Key Icon"
    end

    text do
      move_text_pos rect3.left + 35, rect3.top - 20
      show_text "Note Icon."
    end

    text do
      move_text_pos rect4.left + 35, rect4.top - 20
      show_text "Help Icon"
    end

    text do
      move_text_pos rect5.left + 35, rect5.top - 20
      show_text "NewParagraph Icon"
    end

    text do
      move_text_pos rect6.left + 35, rect6.top - 20
      show_text "Paragraph Icon"
    end

    text do
      move_text_pos rect7.left + 35, rect7.top - 20
      show_text "Insert Icon"
    end

    text do
      move_text_pos rect8.left + 35, rect8.top - 20
      show_text "Text Icon(ISO8859-2 text)"
    end
  end
end

f.save_to_file("pdfs/examples-text_annotation.pdf")
