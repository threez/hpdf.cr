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

  it "can be loaded from mem if raw" do
    pdf = Hpdf::Doc.new

    buf = Array(UInt8).new(256) { |i| i.to_u8 }
    img = pdf.load_raw_image_from_mem buf, 16, 16, Hpdf::ColorSpace::DeviceGray, 8

    page = pdf.add_page
    page.draw_image img, 100, 100, 100, 100
    pdf.save_to_file "spec-raw-array.pdf"
  end

  it "can be loaded from InMemoryGrayImage" do
    pdf = Hpdf::Doc.new

    gi = Hpdf::InMemoryGrayImage.new(4, 4)
    gi[0, 1] = 0x7f
    gi[3, 1] = 0x7f
    gi[1, 2] = 0xff
    gi[2, 2] = 0xff
    img = pdf.load_raw_image_from_mem gi

    page = pdf.add_page
    page.draw_image img, 100, 100, 100, 100
    pdf.save_to_file "spec-raw-gray-img.pdf"
  end

  it "can be loaded from InMemoryRgbImage" do
    pdf = Hpdf::Doc.new

    gi = Hpdf::InMemoryRgbImage.new(4, 4)
    gi[0, 1] = Hpdf::RGB.new(0xff, 0, 0)
    gi[3, 1] = Hpdf::RGB.new(0, 0xff, 0)
    gi[1, 2] = Hpdf::RGB.new(0, 0, 0xff)
    gi[2, 2] = Hpdf::RGB.new(0, 0, 0xff)
    img = pdf.load_raw_image_from_mem gi

    page = pdf.add_page
    page.draw_image img, 100, 100, 100, 100
    pdf.save_to_file "spec-raw-rgb-img.pdf"
  end

  it "can be loaded from InMemoryCmykImage" do
    pdf = Hpdf::Doc.new

    gi = Hpdf::InMemoryCmykImage.new(4, 4)
    gi[0, 1] = Hpdf::CMYK.new(0xff, 0, 0, 0)
    gi[3, 1] = Hpdf::CMYK.new(0, 0xff, 0, 0)
    gi[1, 2] = Hpdf::CMYK.new(0, 0, 0xff, 0)
    gi[2, 2] = Hpdf::CMYK.new(0, 0, 0, 0xff)
    img = pdf.load_raw_image_from_mem gi

    page = pdf.add_page
    page.draw_image img, 100, 100, 100, 100
    pdf.save_to_file "spec-raw-cmyk-img.pdf"
  end
end
