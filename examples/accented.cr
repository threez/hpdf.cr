require "../src/hpdf"

k = "Können wir mit Umlauten umgehen? Ja von Kopf bis Fuß.".encode("ISO8859-2")

pdf = Hpdf::Doc.build do
  page do
    text Hpdf::Base14::Helvetica, 20, encoding: "ISO8859-2" do
      text_out :center, height - 50, k
    end
  end
end

pdf.save_to_file("pdfs/examples-accented.pdf")
