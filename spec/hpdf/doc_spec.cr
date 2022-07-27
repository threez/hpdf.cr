describe Hpdf::Font do
  it "can create a stream" do
    pdf = Hpdf::Doc.new
    pdf.add_page
    stream = pdf.to_io
    stream.size.should eq 624
    stream.to_s[0..10].should eq "%PDF-1.3\n%\xB7"
  end

  it "can set document properties" do
    pdf = Hpdf::Doc.new
    pdf.pages_configuration = 899

    pdf.page_layout.should eq Hpdf::PageLayout::Default
    pdf.page_layout = Hpdf::PageLayout::TwoColumnLeft
    pdf.page_layout.should eq Hpdf::PageLayout::TwoColumnLeft

    pdf.page_mode.should eq Hpdf::PageMode::UseNone
    pdf.page_mode = Hpdf::PageMode::FullScreen
    pdf.page_mode.should eq Hpdf::PageMode::FullScreen
  end

  it "can handle pages" do
    pdf = Hpdf::Doc.new
    pdf.current_page.should eq nil

    page = pdf.add_page
    pdf.current_page.should eq page
  end
end
