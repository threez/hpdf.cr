require "../src/hpdf"

W = 400
H = 500

pdf = Hpdf::Doc.build do
  page do |page|
    page.width = W
    page.height = H

    # Initial zoom and a trim box
    page.zoom = 1.25
    page.set_boundary Hpdf::PageBoundary::TrimBox, 10, 10, W - 10, H - 10

    # --- Background gradient suggestion: concentric ellipses ---
    10.times do |i|
      t = i / 10.0
      page.set_rgb_stroke t * 0.3, 0.4 + t * 0.4, 0.9 - t * 0.5
      page.line_width = 1.5
      page.ellipse W / 2, H * 0.62, 160 - i * 14, 100 - i * 8
      page.stroke
    end

    # --- Filled ellipse (sun-like) ---
    page.set_rgb_fill 1.0, 0.85, 0.1
    page.set_rgb_stroke 0.9, 0.6, 0.0
    page.line_width = 3
    page.ellipse W / 2, H * 0.62, 70, 45
    page.fill_stroke

    # --- Ground: fat filled ellipse at the bottom ---
    page.set_rgb_fill 0.25, 0.55, 0.2
    page.set_rgb_stroke 0.15, 0.35, 0.1
    page.line_width = 2
    page.ellipse W / 2, 55, 180, 40
    page.fill_stroke

    # --- Trees: trunk (narrow ellipse) + foliage (circles) ---
    [{cx: 100, trunk_h: 90}, {cx: 200, trunk_h: 110}, {cx: 300, trunk_h: 85}].each do |tree|
      cx = tree[:cx]
      trunk_h = tree[:trunk_h]

      page.set_rgb_fill 0.45, 0.28, 0.1
      page.ellipse cx, 95 + trunk_h / 2, 12, trunk_h / 2
      page.fill

      foliage_y = 95 + trunk_h + 20
      page.set_rgb_fill 0.15, 0.6, 0.1
      page.circle cx, foliage_y, 35
      page.fill
      page.set_rgb_fill 0.2, 0.65, 0.15
      page.circle cx - 12, foliage_y - 10, 25
      page.fill
      page.circle cx + 12, foliage_y - 10, 25
      page.fill
    end

    # --- Arc rainbow above the sun ---
    # Center at same point as sun; innermost arc clears the sun (radius 90 > 70+stroke).
    # Arcs span 20°–160° (symmetric about 90° = straight up).
    rainbow = [
      {1.0, 0.1, 0.1},
      {1.0, 0.55, 0.0},
      {1.0, 0.95, 0.0},
      {0.1, 0.75, 0.1},
      {0.1, 0.4, 1.0},
      {0.55, 0.0, 0.85},
    ]
    rainbow.each_with_index do |(r, g, b), i|
      page.set_rgb_stroke r, g, b
      page.line_width = 7
      page.arc W / 2, H * 0.62, 90 + i * 7, 20, 160
      page.stroke
    end

    # --- Title ---
    page.text Hpdf::Base14::HelveticaBold, 14 do
      page.gray_fill = 0.15
      page.text_out :center, H - 32, "ellipse · circle · arc · boundary · zoom"
    end
  end
end

pdf.save_to_file("pdfs/examples-shapes.pdf")
