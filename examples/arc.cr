# Based of http://libharu.sourceforge.net/demo/arc_demo.rb

require "../src/hpdf"

pdf = Hpdf::Doc.build do
  # add a new page object.
  page do |page|
    page.height = 220
    page.width = 200

    # draw pie chart
    #
    #   A: 45% Red
    #   B: 25% Blue
    #   C: 15% green
    #   D: other yellow
    #

    # A #
    page.set_rgb_fill(1.0, 0, 0)
    page.move_to(100, 100)
    page.line_to(100, 180)
    page.arc(100, 100, 80, 0, 360 * 0.45)
    pos = page.current_pos
    page.line_to(100, 100)
    page.fill

    # B #
    page.set_rgb_fill(0, 0, 1.0)
    page.move_to(100, 100)
    page.line_to(pos)
    page.arc(100, 100, 80, 360 * 0.45, 360 * 0.7)
    pos = page.current_pos
    page.line_to(100, 100)
    page.fill

    # C #
    page.set_rgb_fill(0, 1.0, 0)
    page.move_to(100, 100)
    page.line_to(pos)
    page.arc(100, 100, 80, 360 * 0.7, 360 * 0.85)
    pos = page.current_pos
    page.line_to(100, 100)
    page.fill

    # D #
    page.set_rgb_fill(1.0, 1.0, 0)
    page.move_to(100, 100)
    page.line_to(pos)
    page.arc(100, 100, 80, 360 * 0.85, 360)
    page.line_to(100, 100)
    page.fill

    # draw center circle #
    page.gray_stroke = 0
    page.gray_fill = 1
    page.circle(100, 100, 30)
    page.fill
  end
end

pdf.save_to_file("pdfs/examples-arc.pdf")
