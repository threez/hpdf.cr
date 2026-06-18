require "../src/hpdf"

W = 400
H = 500

pdf = Hpdf::Doc.build do |doc|
  page do |page|
    page.width = W
    page.height = H

    # 1. Shading — Gouraud-shaded triangle mesh gradient background
    sh = doc.create_shading(
      Hpdf::ShadingType::FreeFormTriangleMesh,
      Hpdf::ColorSpace::DeviceRgb,
      0, W, 0, H
    )
    sh.add_vertex(edge: :no_connection, x: 0, y: 0, r: 30_u8, g: 50_u8, b: 200_u8)
    sh.add_vertex(edge: :no_connection, x: W, y: 0, r: 200_u8, g: 80_u8, b: 50_u8)
    sh.add_vertex(edge: :no_connection, x: W / 2, y: H, r: 120_u8, g: 30_u8, b: 180_u8)
    page.shading = sh

    # 2. Semi-transparent yellow circle (Screen blend)
    gs1 = doc.create_ext_g_state
    gs1.alpha_fill = 0.5
    gs1.blend_mode = Hpdf::BlendMode::Screen
    page.ext_g_state = gs1
    page.set_rgb_fill 1.0, 0.9, 0.1
    page.circle W / 2, H / 2, 100
    page.fill

    # 3. Semi-transparent green circle (Multiply blend)
    gs2 = doc.create_ext_g_state
    gs2.alpha_fill = 0.6
    gs2.blend_mode = Hpdf::BlendMode::Multiply
    page.ext_g_state = gs2
    page.set_rgb_fill 0.2, 0.85, 0.4
    page.circle W / 3, H / 3, 70
    page.fill

    # 4. Reset to fully opaque Normal for text label
    gs3 = doc.create_ext_g_state
    gs3.alpha_fill = 1.0
    gs3.blend_mode = Hpdf::BlendMode::Normal
    page.ext_g_state = gs3

    page.text Hpdf::Base14::HelveticaBold, 13 do
      page.set_rgb_fill 1.0, 1.0, 1.0
      page.text_out :center, 24, "shading · ext_g_state · blend_mode"
    end
  end
end

pdf.save_to_file("pdfs/examples-transparency-shading.pdf")
