# Based of http://libharu.sourceforge.net/demo/encoding_list.c

require "../src/hpdf"

PAGE_WIDTH  = 420
PAGE_HEIGHT = 400
CELL_WIDTH  =  20
CELL_HEIGHT =  20
CELL_HEADER =  10

class MyPage < Hpdf::Page
  # Draw 16 X 15 cells
  def draw_graph
    self.line_width = 0.5

    # Draw vertical lines.
    17.times do |i|
      x = i * CELL_WIDTH + 40

      move_to x, PAGE_HEIGHT - 60
      line_to x, 40
      stroke

      if i > 0 && i <= 16
        text do
          move_text_pos x + 5, PAGE_HEIGHT - 75
          show_text "%X" % (i - 1)
        end
      end
    end

    # Draw horizontal lines.
    15.times do |i|
      y = i * CELL_HEIGHT + 40

      move_to 40, y
      line_to PAGE_WIDTH - 40, y
      stroke

      if i < 14
        text do
          move_text_pos 45, y + 5
          show_text "%X" % (15 - i)
        end
      end
    end
  end

  # Draw all character from 0x20 to 0xFF to the canvas.
  def draw_fonts
    text do
      17.times do |i|
        17.times do |j|
          buf = Bytes.new(2)
          y = PAGE_HEIGHT - 55 - ((i - 1) * CELL_HEIGHT)
          x = j * CELL_WIDTH + 50

          buf[1] = 0x00_u8
          calc = ((i - 1) * 16 + (j - 1))

          if calc >= 32
            buf[0] = calc.to_u8
            s = String.new(buf)
            d = x - text_width(s) / 2
            text_out d, y, s
          end
        end
      end
    end
  end
end

f = Hpdf::Doc.build do |pdf|
  # set compression mode
  pdf.compression_mode = Hpdf::CompressionMode::AllStreams

  # Set page mode to use outlines.
  pdf.page_mode = Hpdf::PageMode::UseOutline

  # get default font
  font = font(Hpdf::Base14::Helvetica)

  # load font object
  font_name = pdf.load_type1_font_from_file("spec/data/fonts/a010013l.afm",
    "spec/data/fonts/a010013l.pfb")

  # create outline root.
  root = create_outline "Encoding list"
  root.opened = true

  # add a new page object.
  encodings = Hpdf::Encodings::All

  encodings.each do |encoding|
    page(MyPage) do |page|
      page.width = PAGE_WIDTH
      page.height = PAGE_HEIGHT

      outline = pdf.create_outline encoding, parent: root
      dst = create_destination
      dst.xyz! 0, page.height, 1
      # dst.fit_b!
      outline.destination = dst

      set_font_and_size font, 15
      draw_graph

      text do
        set_font_and_size font, 20
        move_text_pos 40, PAGE_HEIGHT - 50
        show_text "#{encoding} Encoding"
      end

      font2 = case encoding
              when "Symbol-Set"
                pdf.font "Symbol"
              when "ZapfDingbats-Set"
                pdf.font "ZapfDingbats"
              else
                pdf.font font_name, encoding
              end

      set_font_and_size font2, 14
      draw_fonts
    end
  end
end

# save the document to a file
f.save_to_file "encodings.pdf"
