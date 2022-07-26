# Based on http://libharu.sourceforge.net/demo/line_demo.c

require "../src/hpdf"

def draw_line(page, x, y, label)
  page.text do
    page.move_text_pos x, y - 10
    page.show_text label
  end

  page.move_to x, y - 15
  page.line_to x + 220, y - 15
  page.stroke
end

def draw_line2(page, x, y, label)
  page.text do
    page.move_text_pos x, y
    page.show_text label
  end

  page.move_to x + 30, y - 25
  page.line_to x + 160, y - 25
  page.stroke
end

def draw_rect (page, x, y, label)
  page.text do
    page.move_text_pos x, y - 10
    page.show_text label
  end

  page.rectangle x, y - 40, 220, 25
end

pdf = Hpdf::Doc.new

# add a new page object.
page = pdf.add_page

# print the lines of the page.
page.line_width = 1
page.rectangle 50, 50, page.width - 100, page.height - 110
page.stroke

# print the title of the page (with positioning center).
page.text "Helvetica", 24 do
  page.text_out :center, page.height - 50, "Line Example"
end

page.use_font "Helvetica", 10

# Draw verious widths of lines.
page.line_width = 0
draw_line(page, 60, 770, "line width = 0")

page.line_width = 1.0
draw_line(page, 60, 740, "line width = 1.0")

page.line_width = 2.0
draw_line(page, 60, 710, "line width = 2.0")

# Line dash pattern
page.line_width = 1.0

page.set_dash [3], phase: 1
draw_line(page, 60, 680, "dash_ptn=[3], phase=1 -- 2 on, 3 off, 3 on...")

page.set_dash [3, 7], phase: 2
draw_line(page, 60, 650, "dash_ptn=[7, 3], phase=2 -- 5 on 3 off, 7 on,...")

page.set_dash [8, 7, 2, 7]
draw_line(page, 60, 620, "dash_ptn=[8, 7, 2, 7], phase=0")

page.reset_dash

page.line_width = 30
page.set_rgb_stroke 0.0, 0.5, 0.0

# Line Cap Style
page.set_line_cap Hpdf::LineCap::ButtEnd
draw_line2 page, 60, 570, "PDF_BUTT_END"

page.set_line_cap Hpdf::LineCap::RoundEnd
draw_line2 page, 60, 505, "PDF_ROUND_END"

page.set_line_cap Hpdf::LineCap::ProjectingScuareEnd
draw_line2 page, 60, 440, "PDF_PROJECTING_SCUARE_END"

# Line Join Style
page.line_width = 30
page.set_rgb_stroke 0.0, 0.0, 0.5

page.set_line_join Hpdf::LineJoin::MiterJoin
page.move_to 120, 300
page.line_to 160, 340
page.line_to 200, 300
page.stroke

page.text do
    page.text_out 60, 360, "PDF_MITER_JOIN"
end

page.set_line_join Hpdf::LineJoin::RoundJoin
page.move_to 120, 195
page.line_to 160, 235
page.line_to 200, 195
page.stroke

page.text do
  page.text_out 60, 255, "PDF_ROUND_JOIN"
end

page.set_line_join Hpdf::LineJoin::BevelJoin
page.move_to 120, 90
page.line_to 160, 130
page.line_to 200, 90
page.stroke

page.text do
  page.text_out 60, 150, "PDF_BEVEL_JOIN"
end

# Draw Rectangle
page.line_width = 2
page.set_rgb_stroke 0, 0, 0
page.set_rgb_fill 0.75, 0.0, 0.0

draw_rect page, 300, 770, "Stroke"
page.stroke

draw_rect page, 300, 720, "Fill"
page.fill

draw_rect page, 300, 670, "Fill then Stroke"
page.fill_stroke

# Clip Rect
page.with_graphic_state do
  draw_rect page, 300, 620, "Clip Rectangle"
  page.clip
  page.stroke
  page.use_font "Helvetica", 13

  page.text do
    page.move_text_pos 290, 600
    page.set_text_leading 12
    page.show_text "Clip Clip Clip Clip Clip Clipi Clip Clip Clip"
    page.show_text_next_line "Clip Clip Clip Clip Clip Clip Clip Clip Clip"
    page.show_text_next_line "Clip Clip Clip Clip Clip Clip Clip Clip Clip"
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

page.set_rgb_fill 0, 0, 0

page.text do
  page.move_text_pos 300, 540
  page.show_text "CurveTo2(x1, y1, x2. y2)"
end

page.text do
  page.move_text_pos x + 5, y - 5
  page.show_text "Current point"
  page.move_text_pos x1 - x, y1 - y
  page.show_text "(x1, y1)"
  page.move_text_pos x2 - x1, y2 - y1
  page.show_text "(x2, y2)"
end

page.set_dash [3]

page.line_width = 0.5
page.move_to x1, y1
page.line_to x2, y2
page.stroke

page.reset_dash

page.line_width = 1.5

page.move_to x, y
page.curve_to2 x1, y1, x2, y2
page.stroke

# Curve Example(CurveTo3)
y -= 150
y1 -= 150
y2 -= 150

page.text do
  page.move_text_pos 300, 390
  page.show_text "CurveTo3(x1, y1, x2. y2)"
end

page.text do
  page.move_text_pos x + 5, y - 5
  page.show_text "Current point"
  page.move_text_pos x1 - x, y1 - y
  page.show_text "(x1, y1)"
  page.move_text_pos x2 - x1, y2 - y1
  page.show_text "(x2, y2)"
end

page.set_dash [3]

page.line_width = 0.5
page.move_to x, y
page.line_to x1, y1
page.stroke

page.reset_dash

page.line_width = 1.5
page.move_to x, y
page.curve_to3 x1, y1, x2, y2
page.stroke

# Curve Example(CurveTo)
y -= 150
y1 -= 160
y2 -= 130
x2 += 10

page.text do
  page.move_text_pos 300, 240
  page.show_text "CurveTo(x1, y1, x2. y2, x3, y3)"
end

page.text do
  page.move_text_pos x + 5, y - 5
  page.show_text "Current point"
  page.move_text_pos x1 - x, y1 - y
  page.show_text "(x1, y1)"
  page.move_text_pos x2 - x1, y2 - y1
  page.show_text "(x2, y2)"
  page.move_text_pos x3 - x2, y3 - y2
  page.show_text "(x3, y3)"
end

page.set_dash [3]

page.line_width = 0.5
page.move_to x, y
page.line_to x1, y1
page.stroke
page.move_to x2, y2
page.line_to x3, y3
page.stroke

page.reset_dash

page.line_width = 1.5
page.move_to x, y
page.curve_to x1, y1, x2, y2, x3, y3
page.stroke

# save the document to a file
pdf.save_to_file "line.pdf"
