# Based of http://libharu.sourceforge.net/demo/text_demo2.rb

require "../src/hpdf"

samp_text = "The quick brown fox jumps over the lazy dog. "

f = Hpdf::Doc.build do |pdf|
  page do |page|
    set_size(Hpdf::PageSizes::A5, Hpdf::PageDirection::Portrait)

    font = pdf.font Hpdf::Base14::Helvetica
    page.text_leading = 20

    # HPDF_TALIGN_LEFT
    left = 25
    top = 545
    right = 200
    bottom = top - 40

    rectangle(left, bottom, right - left, top - bottom)
    stroke

    text do
      set_font_and_size(font, 10)
      text_out(left, top + 3, "HPDF_TALIGN_LEFT")

      set_font_and_size(font, 13)
      text_rect(left, top, right, bottom, samp_text)
    end

    # HPDF_TALIGN_RIGHT
    left = 220
    right = 395

    rectangle(left, bottom, right - left, top - bottom)
    stroke

    text do
      set_font_and_size(font, 10)
      text_out(left, top + 3, "HPDF_TALIGN_RIGHT")

      set_font_and_size(font, 13)
      text_rect(left, top, right, bottom, samp_text, align: Hpdf::TextAlignment::Right)
    end

    # HPDF_TALIGN_CENTER
    left = 25
    top = 475
    right = 200
    bottom = top - 40

    rectangle(left, bottom, right - left, top - bottom)
    stroke

    text do
      set_font_and_size(font, 10)
      text_out(left, top + 3, "HPDF_TALIGN_CENTER")

      set_font_and_size(font, 13)
      text_rect(left, top, right, bottom, samp_text, align: Hpdf::TextAlignment::Center)
    end

    # HPDF_TALIGN_JUSTIFY
    left = 220
    right = 395

    rectangle(left, bottom, right - left, top - bottom)
    stroke

    text do
      set_font_and_size(font, 10)
      text_out(left, top + 3, "HPDF_TALIGN_JUSTIFY")

      set_font_and_size(font, 13)
      text_rect(left, top, right, bottom, samp_text, align: Hpdf::TextAlignment::Justify)
    end

    # Skewed coordinate system

    angle1 = 5.0
    angle2 = 10.0
    rad1 = angle1 / 180 * 3.141592
    rad2 = angle2 / 180 * 3.141592

    context do
      concat(1, Math.tan(rad1), Math.tan(rad2), 1, 25, 350)
          left = 0
          top = 40
          right = 175
          bottom = 0

      rectangle(left, bottom, right - left,
                      top - bottom)
      stroke

      text do
        set_font_and_size(font, 10)
        text_out(left, top + 3, "Skewed coordinate system")

        set_font_and_size(font, 13)
        text_rect(left, top, right, bottom, samp_text)
      end
    end

    # Rotated coordinate system
    context do
      angle1 = 5.0
      rad1 = angle1 / 180 * 3.141592

      concat(Math.cos(rad1), Math.sin(rad1), -Math.sin(rad1), Math.cos(rad1), 220, 350)
      left = 0
      top = 40
      right = 175
      bottom = 0

      rectangle(left, bottom, right - left,
                      top - bottom)
      stroke

      text do
        set_font_and_size(font, 10)
        text_out(left, top + 3, "Rotated coordinate system")

        set_font_and_size(font, 13)
        text_rect(left, top, right, bottom, samp_text)
      end
    end


    # text along a circle
    page.gray_stroke = 0
    circle(210, 190, 145)
    circle(210, 190, 113)
    stroke

    angle1 = 360.0 / samp_text.size
    angle2 = 180.0

    text do
      font = pdf.font "Courier-Bold"
      set_font_and_size(font, 30)

      i = 0
      while i < samp_text.size
        rad1 = (angle2 - 90) / 180 * 3.141592
        rad2 = angle2 / 180 * 3.141592

        x = 210.0 + Math.cos(rad2) * 122
        y = 190.0 + Math.sin(rad2) * 122

        set_text_matrix(Math.cos(rad1), Math.sin(rad1), -Math.sin(rad1), Math.cos(rad1), x, y)

        show_text(samp_text[i, 1])
        angle2 -= angle1
        i = i + 1
      end
    end
  end
end

f.save_to_file("text.pdf")
