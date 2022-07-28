require "../src/hpdf"

pdf = Hpdf::Doc.new
page = pdf.add_page

page.draw_rectangle(50, 50, page.width - 100, page.height - 110)

page.text Hpdf::Base14::Helvetica, 70 do
  page.text_out(:center, :center, "Hello World")
end

pdf.save_to_file("hello.pdf")
