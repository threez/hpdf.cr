# Based of http://libharu.sourceforge.net/demo/font_demo.c

require "../src/hpdf"

font_list = [
  "Courier",
  "Courier-Bold",
  "Courier-Oblique",
  "Courier-BoldOblique",
  "Helvetica",
  "Helvetica-Bold",
  "Helvetica-Oblique",
  "Helvetica-BoldOblique",
  "Times-Roman",
  "Times-Bold",
  "Times-Italic",
  "Times-BoldItalic",
  "Symbol",
  "ZapfDingbats",
]

pdf = Hpdf::Doc.new
page = pdf.add_page

# Add a new page object.
height = page.height
width = page.width

# Print the lines of the page.
page.draw_rectangle(50, 50, width - 100, height - 110)

# Print the title of the page (with positioning center).
page.text "Helvetica", 24 do
  page.text_out(:center, height - 50, "Font Demo")
end

# output subtitle.
page.text "Helvetica", 16 do
  page.text_out(60, height - 80, "<Standerd Type1 fonts samples>")
end

page.text do
  page.move_text_pos(60, height - 105)

  font_list.each do |font_name|
    # print a label of text
    page.use_font("Helvetica", 9)
    page.show_text(font_name)
    page.move_text_pos(0, -18)

    # print a sample text.
    page.use_font(font_name, 20)
    page.show_text("abcdefgABCDEFG12345!#$%&+-@?")
    page.move_text_pos(0, -20)
  end
end

pdf.save_to_file("font.pdf")
