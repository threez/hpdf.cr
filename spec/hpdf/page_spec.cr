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
      reset_dash!
      set_dash [8, 7, 2, 7]
      pattern, phase = dash
      pattern.should eq [8, 7, 2, 7]
      phase.should eq 0
    end
  end

  it "can work with page modes" do
    testpage do
      text Hpdf::Base14::Helvetica, 10 do
        g_mode.should eq Hpdf::GMode::TextObject
        g_state_depth.should eq 1
      end

      # imperative
      g_save
      g_state_depth.should eq 2
      g_restore

      # DSL
      context do
        g_state_depth.should eq 2
      end

      g_mode.should eq Hpdf::GMode::PageDescription
    end
  end

  it "can draw" do
    testpage "shapes" do |page|
      context do
        set_rgb_stroke 0.7, 0.6, 0.3
        set_rgb_fill 0.6, 0.3, 0.7

        move_to 100, 100
        line_to 200, 200
        curve_to 250, 250, 350, 350, 100, 200
        curve_to2 400, 400, 200, 150
        curve_to3 500, 700, 100, 200
        close_path

        path 100, 300 do
          line_to 300, 100
          line_to 300, 300
        end

        rectangle 10, 500, 50, 80
        close_path_stroke

        rectangle 10, 100, 50, 80
        fill

        rectangle 100, 100, 50, 80
        eofill

        rectangle 200, 100, 50, 80
        fill_stroke

        rectangle 200, 200, 50, 80
        eofill_stroke

        move_to 300, 300
        line_to 200, 200
        close_path_fill_stroke

        move_to 400, 300
        line_to 70, 200
        close_path_fill_stroke
      end

      context do
        page.line_width = 30
        set_rgb_fill 0.6, 0.3, 0.7
        set_rgb_stroke 0.7, 0.6, 0.3

        circle width/2, height/2, 100
        fill_stroke
      end
    end
  end

  it "can render text" do
    testpage "render text" do |page|
      context do
        8.times do |i|
          text Hpdf::Base14::Helvetica, 20 do
            set_rgb_stroke 0.5, 0, 0
            set_rgb_fill 0, 0.5, 0

            page.text_rendering_mode = Hpdf::TextRenderingMode.new(i)
            text_out 100, height - 40*(i + 1), "ABCabc123!?$"
            text_rendering_mode.should eq Hpdf::TextRenderingMode.new(i)
          end
        end
      end

      text Hpdf::Base14::Helvetica, 12 do
        page.gray_fill = 0.5
        move_text_pos 100, height/2
        page.text_leading = 16

        show_text "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        move_to_next_line
        show_text "sed do eiusmod tempor incididunt ut labore et dolore magna"
        move_to_next_line
        show_text "aliqua. Ut enim ad minim veniam, quis nostrud exercitation"
        show_text_next_line "ullamco laboris nisi ut aliquip ex ea commodo consequat."
        show_text_next_line "Duis aute irure dolor in reprehenderit in voluptate velit"
        show_text_next_line "esse cillum dolore eu fugiat nulla pariatur. Excepteur sint"
        show_text_next_line "occaecat cupidatat non proident, sunt in culpa qui officia"
        show_text_next_line "deserunt mollit anim id est laborum."
      end

      text Hpdf::Base14::Helvetica, 22 do
        move_text_pos 100, 100

        page.gray_stroke = 0.5
        page.text_rendering_mode = Hpdf::TextRenderingMode::Stroke

        show_text_next_line "Stoked text"

        size = text_rect 500, 300, 600, 400, "deserunt mollit anim id est laborum"
        size.should eq 9
      end
    end
  end

  it "can handle transformations" do
    testpage do |page|
      tm = page.trans_matrix
      tm.a.should eq 1
      tm.b.should eq 0
      tm.c.should eq 0
      tm.d.should eq 1
      tm.x.should eq 0
      tm.y.should eq 0
    end

    testpage do |page|
      page.concat 1, 2, 3, 4, 5, 6

      tm = page.trans_matrix
      tm.a.should eq 1
      tm.b.should eq 2
      tm.c.should eq 3
      tm.d.should eq 4
      tm.x.should eq 5
      tm.y.should eq 6
    end
  end
end
