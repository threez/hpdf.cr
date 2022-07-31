# Based on http://libharu.sourceforge.net/demo/line_demo.c

require "../src/hpdf"

class MyPage < Hpdf::Page
  def my_draw_line(x, y, label)
    text do
      move_text_pos x, y - 10
      show_text label
    end

    move_to x, y - 15
    line_to x + 220, y - 15
    stroke
  end

  def my_draw_line2(x, y, label)
    text do
      move_text_pos x, y
      show_text label
    end

    move_to x + 30, y - 25
    line_to x + 160, y - 25
    stroke
  end

  def my_draw_rect(x, y, label)
    text do
      move_text_pos x, y - 10
      show_text label
    end

    rectangle x, y - 40, 220, 25
  end
end

pdf = Hpdf::Doc.build do
  # add a new page object.
  page(MyPage) do |page|
    # print the lines of the page.
    page.line_width = 1
    rectangle 50, 50, width - 100, height - 110
    stroke

    # print the title of the page (with positioning center).
    text Hpdf::Base14::Helvetica, 24 do
      text_out :center, height - 50, "Line Example"
    end

    use_font Hpdf::Base14::Helvetica, 10

    # Draw verious widths of lines.
    page.line_width = 0
    my_draw_line(60, 770, "line width = 0")

    page.line_width = 1.0
    my_draw_line(60, 740, "line width = 1.0")

    page.line_width = 2.0
    my_draw_line(60, 710, "line width = 2.0")

    # Line dash pattern
    page.line_width = 1.0

    set_dash [3], phase: 1
    my_draw_line(60, 680, "dash_ptn=[3], phase=1 -- 2 on, 3 off, 3 on...")

    set_dash [3, 7], phase: 2
    my_draw_line(60, 650, "dash_ptn=[7, 3], phase=2 -- 5 on 3 off, 7 on,...")

    set_dash [8, 7, 2, 7]
    my_draw_line(60, 620, "dash_ptn=[8, 7, 2, 7], phase=0")

    reset_dash

    page.line_width = 30
    set_rgb_stroke 0.0, 0.5, 0.0

    # Line Cap Style
    page.line_cap = Hpdf::LineCap::ButtEnd
    my_draw_line2 60, 570, "PDF_BUTT_END"

    page.line_cap = Hpdf::LineCap::RoundEnd
    my_draw_line2 60, 505, "PDF_ROUND_END"

    page.line_cap = Hpdf::LineCap::ProjectingScuareEnd
    my_draw_line2 60, 440, "PDF_PROJECTING_SCUARE_END"

    # Line Join Style
    page.line_width = 30
    set_rgb_stroke 0.0, 0.0, 0.5

    page.line_join = Hpdf::LineJoin::MiterJoin
    move_to 120, 300
    line_to 160, 340
    line_to 200, 300
    stroke

    text do
        text_out 60, 360, "PDF_MITER_JOIN"
    end

    page.line_join = Hpdf::LineJoin::RoundJoin
    move_to 120, 195
    line_to 160, 235
    line_to 200, 195
    stroke

    text do
      text_out 60, 255, "PDF_ROUND_JOIN"
    end

    page.line_join = Hpdf::LineJoin::BevelJoin
    move_to 120, 90
    line_to 160, 130
    line_to 200, 90
    stroke

    text do
      text_out 60, 150, "PDF_BEVEL_JOIN"
    end

    # Draw Rectangle
    page.line_width = 2
    set_rgb_stroke 0, 0, 0
    set_rgb_fill 0.75, 0.0, 0.0

    my_draw_rect 300, 770, "Stroke"
    stroke

    my_draw_rect 300, 720, "Fill"
    fill

    my_draw_rect 300, 670, "Fill then Stroke"
    fill_stroke

    # Clip Rect
    graphics do
      my_draw_rect 300, 620, "Clip Rectangle"
      clip
      stroke
      use_font Hpdf::Base14::Helvetica, 13

      text do
        move_text_pos 290, 600
        set_text_leading 12
        show_text "Clip Clip Clip Clip Clip Clipi Clip Clip Clip"
        show_text_next_line "Clip Clip Clip Clip Clip Clip Clip Clip Clip"
        show_text_next_line "Clip Clip Clip Clip Clip Clip Clip Clip Clip"
      end
    end

    # Curve Example(CurveTo2)
    x = 330
    y = 440
    x1 = 430
    y1 = 530
    x2 = 480
    y2 = 470
    x3 = 480
    y3 = 90

    set_rgb_fill 0, 0, 0

    text do
      move_text_pos 300, 540
      show_text "CurveTo2(x1, y1, x2. y2)"
    end

    text do
      move_text_pos x + 5, y - 5
      show_text "Current point"
      move_text_pos x1 - x, y1 - y
      show_text "(x1, y1)"
      move_text_pos x2 - x1, y2 - y1
      show_text "(x2, y2)"
    end

    set_dash [3]

    page.line_width = 0.5
    move_to x1, y1
    line_to x2, y2
    stroke

    reset_dash

    page.line_width = 1.5

    move_to x, y
    curve_to2 x1, y1, x2, y2
    stroke

    # Curve Example(CurveTo3)
    y -= 150
    y1 -= 150
    y2 -= 150

    text do
      move_text_pos 300, 390
      show_text "CurveTo3(x1, y1, x2. y2)"
    end

    text do
      move_text_pos x + 5, y - 5
      show_text "Current point"
      move_text_pos x1 - x, y1 - y
      show_text "(x1, y1)"
      move_text_pos x2 - x1, y2 - y1
      show_text "(x2, y2)"
    end

    set_dash [3]

    page.line_width = 0.5
    move_to x, y
    line_to x1, y1
    stroke

    reset_dash

    page.line_width = 1.5
    move_to x, y
    curve_to3 x1, y1, x2, y2
    stroke

    # Curve Example(CurveTo)
    y -= 150
    y1 -= 160
    y2 -= 130
    x2 += 10

    text do
      move_text_pos 300, 240
      show_text "CurveTo(x1, y1, x2. y2, x3, y3)"
    end

    text do
      move_text_pos x + 5, y - 5
      show_text "Current point"
      move_text_pos x1 - x, y1 - y
      show_text "(x1, y1)"
      move_text_pos x2 - x1, y2 - y1
      show_text "(x2, y2)"
      move_text_pos x3 - x2, y3 - y2
      show_text "(x3, y3)"
    end

    set_dash [3]

    page.line_width = 0.5
    move_to x, y
    line_to x1, y1
    stroke
    move_to x2, y2
    line_to x3, y3
    stroke

    reset_dash

    page.line_width = 1.5
    move_to x, y
    curve_to x1, y1, x2, y2, x3, y3
    stroke
  end
end

# save the document to a file
pdf.save_to_file "line.pdf"
