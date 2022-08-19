describe Hpdf::Image do
  it "has getters" do
    testdoc do |pdf|
      image = pdf.load_png_image_from_file("spec/data/screenshot.png")

      s = image.size
      s.width.should eq 645
      s.height.should eq 534
      image.width.should eq 645
      image.height.should eq 534
      image.bits_per_component.should eq 8
      image.color_space.should eq "DeviceRGB"
    end
  end

  it "can set a color mask" do
    testdoc do |pdf|
      image = pdf.load_png_image_from_file("spec/data/screenshot.png")
      image.set_color_mask

      mask = pdf.load_png_image_from_file("spec/data/mask.png")
      image.mask_image = mask
    end
  end

  it "can be loaded from mem if raw" do
    testdoc "raw-array" do |pdf|
      buf = Array(UInt8).new(256, &.to_u8)
      img = pdf.load_raw_image_from_mem buf, 16, 16, Hpdf::ColorSpace::DeviceGray, 8

      page = pdf.add_page
      page.draw_image img, 100, 100, 100, 100
    end
  end

  it "can be loaded from InMemoryGrayImage" do
    testdoc "raw-gray-img" do |pdf|
      gi = Hpdf::Raw::GrayImage.new(4, 4)
      gi[0, 1] = 0x7f
      gi[3, 1] = 0x7f
      gi[1, 2] = 0xff
      gi[2, 2] = 0xff
      img = pdf.load_raw_image_from_mem gi

      page = pdf.add_page
      page.draw_image img, 100, 100, 100, 100
    end
  end

  it "can be loaded from InMemoryRgbImage" do
    testdoc "raw-rgb-img" do |pdf|
      gi = Hpdf::Raw::RgbImage.new(4, 4)
      gi[0, 1] = Hpdf::Raw::RgbColor.new(0xff, 0, 0)
      gi[3, 1] = Hpdf::Raw::RgbColor.new(0, 0xff, 0)
      gi[1, 2] = Hpdf::Raw::RgbColor.new(0, 0, 0xff)
      gi[2, 2] = Hpdf::Raw::RgbColor.new(0, 0, 0xff)
      img = pdf.load_raw_image_from_mem gi

      page = pdf.add_page
      page.draw_image img, 100, 100, 100, 100
    end
  end

  it "can be loaded from InMemoryCmykImage" do
    testdoc "raw-cmyk-img" do |pdf|
      gi = Hpdf::Raw::CmykImage.new(4, 4)
      gi[0, 1] = Hpdf::Raw::CmykColor.new(0xff, 0, 0, 0)
      gi[3, 1] = Hpdf::Raw::CmykColor.new(0, 0xff, 0, 0)
      gi[1, 2] = Hpdf::Raw::CmykColor.new(0, 0, 0xff, 0)
      gi[2, 2] = Hpdf::Raw::CmykColor.new(0, 0, 0, 0xff)
      img = pdf.load_raw_image_from_mem gi

      page = pdf.add_page
      page.draw_image img, 100, 100, 100, 100
    end
  end

  it "can load jpeg images" do
    testdoc do |pdf|
      pdf.load_jpeg_image_from_file("spec/data/screenshot.jpeg")
    end
  end
end
