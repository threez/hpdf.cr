describe Hpdf::Image do
  it "can set page size" do
    testpage do |page|
      width.should eq 595
      height.should eq 841

      page.width = 300
      page.height = 300

      width.should eq 300
      height.should eq 300
    end

    testpage do
      set_size Hpdf::PageSizes::A3, Hpdf::PageDirection::Landscape

      width.should eq 1190
      height.should eq 841
    end
  end

  it "can rotate" do
    testpage do |page|
      page.rotate = 180
    end
  end

  it "creates a destination" do
    testpage do
      # create_destination
      create_destination.should_not eq nil
    end
  end

  it "has getters on empty page" do
    testpage do
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

      # flat
      flat.should eq 1

      # char_space
      char_space.should eq 0

      # char_space
      word_space.should eq 0

      # horizontal_scaling
      horizontal_scaling.should eq 100

      # text_rise
      text_rise.should eq 0

      # fill_rgb
      color = rgb_fill
      color.r.should eq 0
      color.g.should eq 0
      color.b.should eq 0

      # rgb_stroke
      color = rgb_stroke
      color.r.should eq 0
      color.g.should eq 0
      color.b.should eq 0

      # cmyk_fill
      color = cmyk_fill
      color.c.should eq 0
      color.m.should eq 0
      color.y.should eq 0
      color.k.should eq 0

      # cmyk_stroke
      color = cmyk_stroke
      color.c.should eq 0
      color.m.should eq 0
      color.y.should eq 0
      color.k.should eq 0

      # gray_fill
      gray_fill.should eq 0

      # gray_stroke
      gray_stroke.should eq 0

      # stroking_color_space
      stroking_color_space.should eq Hpdf::ColorSpace::DeviceGray

      # filling_color_space
      filling_color_space.should eq Hpdf::ColorSpace::DeviceGray

      # g_state_depth
      g_state_depth.should eq 1
    end
  end

  it "can work with text" do
    testpage do
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

  it "can set slideshows on pages" do
    testpage do
      set_slide_show Hpdf::TransitionStyle::BoxOut,
                     1, 2.0
    end
  end

  it "can set line data" do
    testpage do |page|
      # line_width
      page.line_width = 30
      line_width.should eq 30

      # line_cap
      page.line_cap = Hpdf::LineCap::RoundEnd
      line_cap.should eq Hpdf::LineCap::RoundEnd

      # line_cap
      page.line_join = Hpdf::LineJoin::RoundJoin
      line_join.should eq Hpdf::LineJoin::RoundJoin

      # miter_limit
      page.miter_limit = 50
      miter_limit.should eq 50

      # set_dash
      set_dash [8,7,2,7]
      pattern, phase = dash
      pattern.should eq [8,7,2,7]
      phase.should eq 0
    end
  end
end
