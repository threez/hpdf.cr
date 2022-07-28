describe Hpdf::Doc do
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

    last = pdf.add_page
    pdf.current_page.should eq last

    first = pdf.insert_page last
    pdf.current_page.should eq last
  end

  it "can handle base14 fonts" do
    pdf = Hpdf::Doc.new

    Hpdf::Base14::All.each do |font_name|
      pdf.font font_name
    end
  end

  it "can load afm fonts" do
    pdf = Hpdf::Doc.new
    name = pdf.load_type1_font_from_file "fonts/a010013l.afm"
    name.should eq "URWGothicL-Book"
    pdf.font name
  end

  it "can load ttf fonts" do
    pdf = Hpdf::Doc.new
    name = pdf.load_tt_font_from_file "fonts/Roboto-Black.ttf"
    name.should eq "Roboto-Black"
    pdf.font name
  end

  it "can add a page label" do
    pdf = Hpdf::Doc.new
    pdf.add_page_label(1, Hpdf::PageNumStyle::Decimal)
  end

  it "can handle japanese fonts" do
    pdf = Hpdf::Doc.new
    pdf.use_jp_fonts

    #TODO find out why fonts are not found
    #Hpdf::JapaneseFonts::All.each do |font_name|
    #  pdf.font font_name
    #end
  end
end