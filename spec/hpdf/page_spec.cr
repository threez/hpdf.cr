describe Hpdf::Image do
  it "can set page size" do
    pdf = Hpdf::Doc.new
    pdf.page do
      width.should eq 595
      height.should eq 841

      width = 300
      height = 300

      width.should eq 300
      height.should eq 300
    end

    pdf.page do
      set_size Hpdf::PageSizes::A3, Hpdf::PageDirection::Landscape

      width.should eq 1190
      height.should eq 841
    end
  end

  it "can rotate" do
    pdf = Hpdf::Doc.new
    pdf.page do
      rotate = 180
    end
  end

  it "creates a destination" do
    pdf = Hpdf::Doc.new
    pdf.page do
      # create_destination
      create_destination.should_not eq nil
    end
  end

  it "has getters on empty page" do
    pdf = Hpdf::Doc.new
    pdf.page do
      # g_mode
      g_mode.should eq Hpdf::GMode::PageDescription

      # current_pos
      p = current_pos
      p.x.should eq 0
      p.y.should eq 0

      # current_text_pos
      p = current_text_pos
      p.x.should eq 0
      p.y.should eq 0

      # current_font
      current_font.should eq nil

      # line_width
      line_width.should eq 1

      # line_cap
      line_cap.should eq Hpdf::LineCap::ButtEnd

      # line_cap
      line_join.should eq Hpdf::LineJoin::MiterJoin

      # miter_limit
      miter_limit.should eq 10

      # dash
      pattern, phase = dash
      pattern.should eq [] of Int32
      phase.should eq 0
    end
  end

  it "can work with text" do
    pdf = Hpdf::Doc.new
    pdf.page do
      text Hpdf::Base14::Helvetica, 16 do
        # text_width
        text_width("Hello World").should eq 82.672_f32

        # measure_text
        mt = measure_text("Hello World", width: 40)
        mt.len_included.should eq 6
        mt.real_width.should eq 36.447998_f32

        # current_font
        current_font.not_nil!.name.should eq "Helvetica"

        # current_font_size
        current_font_size.should eq 16
      end
    end
  end
end
