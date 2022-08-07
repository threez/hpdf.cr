describe Hpdf::Doc do
  it "can create a stream" do
    testdoc do |pdf|
      pdf.creator = "test"
      pdf.add_page
      stream = pdf.to_io
      stream.size.should eq 601
      stream.to_s[0..10].should eq "%PDF-1.3\n%\xB7"
    end
  end

  it "can set document properties" do
    testdoc do |pdf|
      pdf.pages_configuration = 899

      pdf.page_layout.should eq Hpdf::PageLayout::Default
      pdf.page_layout = Hpdf::PageLayout::TwoColumnLeft
      pdf.page_layout.should eq Hpdf::PageLayout::TwoColumnLeft

      pdf.page_mode.should eq Hpdf::PageMode::UseNone
      pdf.page_mode = Hpdf::PageMode::FullScreen
      pdf.page_mode.should eq Hpdf::PageMode::FullScreen
    end
  end

  it "can handle pages" do
    testdoc do |pdf|
      pdf.current_page.should eq nil

      last = pdf.add_page
      pdf.current_page.should eq last

      pdf.insert_page last
      pdf.current_page.should eq last
    end
  end

  it "can handle base14 fonts" do
    testdoc do |pdf|
      Hpdf::Base14::All.each do |font_name|
        pdf.font font_name
      end
    end
  end

  it "can load afm fonts" do
    testdoc do |pdf|
      name = pdf.load_type1_font_from_file "spec/data/fonts/a010013l.afm",
        "spec/data/fonts/a010013l.pfb"
      name.should eq "URWGothicL-Book"
      pdf.font name
    end
  end

  it "can load ttf fonts" do
    testdoc do |pdf|
      name = pdf.load_tt_font_from_file "spec/data/fonts/Roboto-Black.ttf"
      name.should eq "Roboto-Black"
      pdf.font name
    end
  end

  it "can add a page label" do
    testdoc do |pdf|
      pdf.add_page_label(1, Hpdf::PageNumStyle::Decimal)
    end
  end

  # requires fonts only available on win32
  {% if flag?(:windows) %}
    it "can handle japanese fonts" do
      testdoc do |pdf|
        pdf.use_jp_fonts
      end

      Hpdf::JapaneseFonts::All.each do |font_name|
        pdf.font font_name
      end
    end
  {% end %}

  it "can get/set document attributes" do
    testdoc "doc-attributes" do |pdf|
      pdf.creation_date.should eq nil
      pdf.mod_date.should eq nil
      pdf.author.should eq nil
      # The library version installed is different
      # from OS to OS.
      ire = /Haru Free PDF Library 2./i
      ire.matches?(pdf.creator.not_nil!).should eq true
      pdf.title.should eq nil
      pdf.subject.should eq nil
      pdf.keywords.should eq nil

      pdf.creation_date = Time.local
      pdf.mod_date = Time.utc
      pdf.author = "Vincent"
      pdf.creator = "hpdf.cr"
      pdf.title = "About Hpdf"
      pdf.subject = "Programming"
      pdf.keywords = "Crystal,LibHaru"

      pdf.add_page
      pdf.creation_date.should_not eq nil
      pdf.mod_date.should_not eq nil
      pdf.author.should eq "Vincent"
      pdf.creator.should eq "hpdf.cr"
      pdf.title.should eq "About Hpdf"
      pdf.subject.should eq "Programming"
      pdf.keywords.should eq "Crystal,LibHaru"
    end
  end

  it "can encrypt documents" do
    testdoc "doc-password" do |pdf|
      page = pdf.add_page
      page.text Hpdf::Base14::Helvetica, 30 do
        page.text_out :center, :center, "Secret Document"
      end

      pdf.set_password_and_permission "test1234"
    end
  end
end
