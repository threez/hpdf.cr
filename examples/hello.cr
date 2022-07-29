require "../src/hpdf"

pdf = Hpdf::Doc.new

pdf.page do
  draw_rectangle 50, 50, width - 100, height - 110

  text Hpdf::Base14::Helvetica, 70 do
    text_out :center, :center, "Hello World"
  end
end

pdf.save_to_file "hello.pdf"
