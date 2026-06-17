require "../src/hpdf"

# Demonstrates use_utf_encodings with a TTF font to render
# text from several scripts in a single document.

SAMPLES = [
  {"Latin", "The quick brown fox jumps over the lazy dog."},
  {"Greek", "Ο γρήγορος καφέ αλεπού πηδά πάνω από τον τεμπέλη σκύλο."},
  {"Cyrillic", "Быстрая коричневая лиса прыгает через ленивую собаку."},
  {"Arabic", "الثعلب البني السريع يقفز فوق الكلب الكسول."},
  {"Hebrew", "השועל החום המהיר קופץ מעל הכלב העצלן."},
  {"Japanese", "素早い茶色の狐が怠惰な犬を飛び越えた。"},
  {"Korean", "빠른 갈색 여우가 게으른 개를 뛰어넘었다."},
  {"Chinese", "敏捷的棕色狐狸跳过了懒狗。"},
  {"Emoji", "🦊 jumps over 🐶 — fast!"},
]

DOC_W   = 595
DOC_H   = 842
MARGIN  =  50
LINE_H  =  38
LABEL_W =  90
FSIZE   =  14

doc = Hpdf::Doc.build do |pdf|
  # Enable UTF-8 encoding support — required before loading a Unicode font
  pdf.use_utf_encodings

  # Load a TTF that covers many scripts (Roboto covers Latin/Cyrillic/Greek)
  font_name = pdf.load_tt_font_from_file("spec/data/fonts/Roboto-Black.ttf",
    embedding: true)

  page do |page|
    page.width = DOC_W
    page.height = DOC_H

    # Header
    text Hpdf::Base14::HelveticaBold, 20 do
      page.gray_fill = 0.1
      text_out :center, DOC_H - MARGIN - 10, "UTF-8 Encoding Demo"
    end

    # Subtitle
    text Hpdf::Base14::Helvetica, 10 do
      page.gray_fill = 0.4
      text_out :center, DOC_H - MARGIN - 32,
        "use_utf_encodings + embedded TTF — rendered with hpdf.cr"
    end

    # Divider line
    page.line_width = 0.5
    page.gray_stroke = 0.6
    move_to MARGIN, DOC_H - MARGIN - 48
    line_to DOC_W - MARGIN, DOC_H - MARGIN - 48
    stroke

    # One row per script
    SAMPLES.each_with_index do |pair, i|
      label = pair[0]
      sample = pair[1]
      y = DOC_H - MARGIN - 75 - i * LINE_H

      # Script label in Helvetica
      text Hpdf::Base14::Helvetica, 9 do
        page.gray_fill = 0.5
        text_out MARGIN, y + 4, label
      end

      # Sample text in the TTF font with UTF-8 encoding
      use_encoding("UTF-8") do
        text font_name, FSIZE do
          page.gray_fill = 0.05
          text_out MARGIN + LABEL_W, y, sample
        end
      end

      # Thin separator
      page.line_width = 0.3
      page.gray_stroke = 0.85
      move_to MARGIN, y - 8
      line_to DOC_W - MARGIN, y - 8
      stroke
    end
  end
end

doc.save_to_file("pdfs/examples-utf.pdf")
