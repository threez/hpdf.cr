# Based on http://libharu.sourceforge.net/demo/jpfont_demo.rb

require "../src/hpdf"

{% unless flag?(:windows) %}
  puts "requires fonts only available on win32"
  exit 0
{% end %}

SAMP_TEXT1 = "abcdefgABCDEFG123!#$%&+-@?"
SAMP_TEXT2 = "アメンボ赤いなあいうえお。浮き藻に小エビもおよいでる。"

f = Hpdf::Doc.build do |pdf|
  # set compression mode
  pdf.compression_mode = Hpdf::CompressionMode::AllStreams
  pdf.use_jp_fonts
  pdf.use_jp_encodings

  title_font = pdf.font "Helvetica"

  fonts = Array(Hpdf::Font).new(16)
  fonts[0] = pdf.font "MS-Mincyo", "90ms-RKSJ-H"
  fonts[1] = pdf.font "MS-Mincyo,Bold", "90ms-RKSJ-H"
  fonts[2] = pdf.font "MS-Mincyo,Italic", "90ms-RKSJ-H"
  fonts[3] = pdf.font "MS-Mincyo,BoldItalic", "90ms-RKSJ-H"
  fonts[4] = pdf.font "MS-PMincyo", "90msp-RKSJ-H"
  fonts[5] = pdf.font "MS-PMincyo,Bold", "90msp-RKSJ-H"
  fonts[6] = pdf.font "MS-PMincyo,Italic", "90msp-RKSJ-H"
  fonts[7] = pdf.font "MS-PMincyo,BoldItalic", "90msp-RKSJ-H"
  fonts[8] = pdf.font "MS-Gothic", "90ms-RKSJ-H"
  fonts[9] = pdf.font "MS-Gothic,Bold", "90ms-RKSJ-H"
  fonts[10] = pdf.font "MS-Gothic,Italic", "90ms-RKSJ-H"
  fonts[11] = pdf.font "MS-Gothic,BoldItalic", "90ms-RKSJ-H"
  fonts[12] = pdf.font "MS-PGothic", "90msp-RKSJ-H"
  fonts[13] = pdf.font "MS-PGothic,Bold", "90msp-RKSJ-H"
  fonts[14] = pdf.font "MS-PGothic,Italic", "90msp-RKSJ-H"
  fonts[15] = pdf.font "MS-PGothic,BoldItalic", "90msp-RKSJ-H"

  # set page mode to use outlines.
  pdf.page_mode = Hpdf::PageMode::UseOutline

  encoder = pdf.find_encoder("90ms-RKSJ-H")

  # create outline root.
  root = pdf.create_outline "日本語フォント", encoder: encoder

  fonts.each do |font|
    print font.name, "\n"
    page do |page|
      outline = pdf.create_outline(font.name, parent: root)
      dst = page.create_destination
      outline.destination = dst

      page.set_font_and_size(title_font, 10.0)

      text do
        page.move_text_pos(10.0, 190.0)
        page.show_text(font.name)

        page.set_font_and_size(font, 15.0)
        page.move_text_pos(10.0, -20.0)
        page.show_text("abcdefghijklmnopqrstuvwxyz")
        page.move_text_pos(0.0, -20.0)
        page.show_text("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        page.move_text_pos(0.0, -20.0)
        page.show_text("1234567890")
        page.move_text_pos(0.0, -20.0)

        page.set_font_and_size(font, 10.0)
        page.show_text(SAMP_TEXT2)
        page.move_text_pos(0.0, -18.0)

        page.set_font_and_size(font, 16.0)
        page.show_text(SAMP_TEXT2)
        page.move_text_pos(0.0, -27.0)

        page.set_font_and_size(font, 23.0)
        page.show_text(SAMP_TEXT2)
        page.move_text_pos(0.0, -36.0)

        page.set_font_and_size(font, 30.0)
        page.show_text(SAMP_TEXT2)

        p = page.current_text_pos
        page.width = p.x + 20
        page.height = 210.0

        page.line_width = 0.5

        page.move_to(10.0, 185.0)
        page.line_to(p.x + 10.0, 185.0)
        page.stroke

        page.move_to(10.0, 125.0)
        page.line_to(p.x + 10.0, 125.0)
        page.stroke

        page.move_to(10.0, p.y - 12.0)
        page.line_to(p.x + 10.0, p.y - 12)
        page.stroke
      end
    end
  end
end

f.save_to_file("pdfs/examples-jpfont.pdf")
