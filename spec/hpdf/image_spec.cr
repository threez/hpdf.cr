describe Hpdf::Image do
  it "has getters" do
    pdf = Hpdf::Doc.new
    image = pdf.load_png_image_from_file("spec/data/screenshot.png")

    s = image.get_size
    s.width.should eq 645
    s.height.should eq 534
    image.width.should eq 645
    image.height.should eq 534
    image.bits_per_component.should eq 8
    image.color_space.should eq "DeviceRGB"
  end

  it "can set a color mask" do
    pdf = Hpdf::Doc.new
    image = pdf.load_png_image_from_file("spec/data/screenshot.png")
    image.set_color_mask

    mask = pdf.load_png_image_from_file("spec/data/mask.png")
    image.mask_image = mask
  end
end
