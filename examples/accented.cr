require "../src/hpdf"

pdf = Hpdf::Doc.build do
  page do
    use_encoding Hpdf::Encodings::ISO8859_2 do
      text Hpdf::Base14::Helvetica, 20 do
        text_out :center, height - 50, "Können wir mit Umlauten umgehen? Ja von Kopf bis Fuß."
      end
    end
  end
end

pdf.save_to_file("pdfs/examples-accented.pdf")
