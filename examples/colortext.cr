# Based on http://libharu.sourceforge.net/demo/text_demo.c

require "../src/hpdf"

class MyPage < Hpdf::Page
  include Hpdf::Grid

  def show_stripe_pattern(x, y)
    iy = 0

    while iy < 50
      set_rgb_stroke 0.0, 0.0, 0.5
      self.line_width = 1
      move_to x, y + iy
      line_to x + text_width("ABCabc123"), y + iy
      stroke
      iy += 3
    end

    self.line_width = 2.5
  end

  def show_description(x, y, str)
    fsize = current_font_size
    font = current_font
    c = rgb_fill

    text do
      set_rgb_fill 0, 0, 0
      self.text_rendering_mode = Hpdf::TextRenderingMode::Fill
      set_font_and_size font.not_nil!, 10
      text_out x, y - 12, str
    end

    set_font_and_size font.not_nil!, fsize
    set_rgb_fill c.r, c.g, c.b
  end
end

f = Hpdf::Doc.build do |pdf|
  page_title = "Text Demo"
  samp_text = "abcdefgABCDEFG123!# $%&+-@?"
  samp_text2 = "The quick brown fox jumps over the lazy dog."

  # set compression mode
  pdf.compression_mode = Hpdf::CompressionMode::AllStreams

  # create default-font
  font = pdf.font "Helvetica"

  # add a new page object.
  page(MyPage) do |page|
    # draw grid to the page
    draw_grid

    # print the title of the page (with positioning center).
    set_font_and_size font, 24
    tw = text_width page_title
    text do
      text_out (width- tw) / 2, height - 50, page_title
    end

    text do
      move_text_pos 60, height - 60

      # font size
      fsize = 8
      while fsize < 60
        # set style and size of font.
        set_font_and_size font, fsize

        # set the position of the text.
        move_text_pos 0, -5 - fsize

        # measure the number of characters which included in the page.
        len = measure_text samp_text, width: width - 120, word_wrap: false
        show_text samp_text

        # print the description.
        move_text_pos 0, -10
        set_font_and_size font, 8
        show_text "Fontsize=#{fsize}"

        fsize *= 1.5
      end

      # font color
      set_font_and_size font, 8
      move_text_pos 0, -30
      show_text "Font color"

      set_font_and_size font, 18
      move_text_pos 0, -20
      len = samp_text.size
      len.times do |i|
        r = i / len
        g = 1 - (i / len)

        set_rgb_fill r, g, 0.0
        show_text samp_text[i..i]
      end
      move_text_pos 0, -25

      len.times do |i|
        r = i / len
        b = 1 - (i / len)

        set_rgb_fill r, 0.0, b
        show_text samp_text[i..i]
      end
      move_text_pos 0, -25

      len.times do |i|
        b = i / len
        g = 1 - (i / len)

        set_rgb_fill 0.0, g, b
        show_text samp_text[i..i]
      end
    end

    ypos = 450

    # Font rendering mode
    set_font_and_size font, 32
    set_rgb_fill 0.5, 0.5, 0.0
    page.line_width = 1.5

    # PDF_FILL
    show_description 60, ypos, "TextRenderingMode=Fill"
    page.text_rendering_mode = Hpdf::TextRenderingMode::Fill
    text do
      text_out 60, ypos, "ABCabc123"
    end

    # PDF_STROKE
    show_description 60, ypos - 50,  "TextRenderingMode=Stroke"
    page.text_rendering_mode = Hpdf::TextRenderingMode::Stroke
    text do
      text_out 60, ypos - 50, "ABCabc123"
    end

    # PDF_FILL_THEN_STROKE
    show_description 60, ypos - 100, "TextRenderingMode=FillThenStroke"
    page.text_rendering_mode = Hpdf::TextRenderingMode::Stroke
    text do
      text_out 60, ypos - 100, "ABCabc123"
    end

    # PDF_FILL_CLIPPING
    show_description 60, ypos - 150, "TextRenderingMode=FillClipping"
    context do
      page.text_rendering_mode = Hpdf::TextRenderingMode::FillClipping
      text do
        text_out 60, ypos - 150, "ABCabc123"
      end
      show_stripe_pattern 60, ypos - 150
    end

    # PDF_STROKE_CLIPPING
    show_description 60, ypos - 200, "TextRenderingMode=StrokeClipping"
    context do
      page.text_rendering_mode = Hpdf::TextRenderingMode::StrokeClipping
      text do
        text_out 60, ypos - 200, "ABCabc123"
      end
      show_stripe_pattern 60, ypos - 200
    end

    # PDF_FILL_STROKE_CLIPPING
    show_description 60, ypos - 250, "TextRenderingMode=FillStrokeClipping"
    context do
      page.text_rendering_mode = Hpdf::TextRenderingMode::FillStrokeClipping
      text do
        text_out 60, ypos - 250, "ABCabc123"
      end
      show_stripe_pattern 60, ypos - 250
    end

    # Reset text attributes
    page.text_rendering_mode =  Hpdf::TextRenderingMode::Fill
    set_rgb_fill 0, 0, 0
    set_font_and_size font, 30

    # Rotating text
    angle1 = 30                   # A rotation of 30 degrees.
    rad1 = angle1 / 180 * 3.141592 # Calcurate the radian value.

    show_description 320, ypos - 60, "Rotating text"
    text do
      set_text_matrix Math.cos(rad1), Math.sin(rad1), -Math.sin(rad1), Math.cos(rad1),
                      330, ypos - 60
      show_text "ABCabc123"
    end

    # Skewing text.
    show_description 320, ypos - 120, "Skewing text"
    text do
      angle1 = 10
      angle2 = 20
      rad1 = angle1 / 180 * 3.141592
      rad2 = angle2 / 180 * 3.141592

      set_text_matrix 1, Math.tan(rad1), Math.tan(rad2), 1, 320, ypos - 120
      show_text "ABCabc123"
    end

    # scaling text (X direction)
    show_description 320, ypos - 175, "Scaling text (X direction)"
    text do
      set_text_matrix 1.5, 0, 0, 1, 320, ypos - 175
      show_text "ABCabc12"
    end

    # scaling text (Y direction)
    show_description 320, ypos - 250, "Scaling text (Y direction)"
    text do
      set_text_matrix 1, 0, 0, 2, 320, ypos - 250
      show_text "ABCabc123"
    end

    # char spacing, word spacing
    show_description 60, 140, "char-spacing 0"
    show_description 60, 100, "char-spacing 1.5"
    show_description 60, 60, "char-spacing 1.5, word-spacing 2.5"

    set_font_and_size font, 20
    set_rgb_fill 0.1, 0.3, 0.1

    # char-spacing 0
    text do
      text_out 60, 140, samp_text2
    end

    # char-spacing 1.5
    page.char_space = 1.5
    text do
      text_out 60, 100, samp_text2
    end

    # char-spacing 1.5, word-spacing 3.5
    page.word_space = 2.5
    text do
      text_out 60, 60, samp_text2
    end
  end
end

# save the document to a file
f.save_to_file "colortext.pdf"
