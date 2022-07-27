
describe Hpdf::Font do
  it "has getters" do
    font = create_font

    font.name.should eq "Helvetica"
    font.encoding_name.should eq "StandardEncoding"
    font.ascent.should eq 718
    font.descent.should eq -207
    font.x_height.should eq 523
    font.cap_height.should eq 523

    bb = font.b_box
    bb.left.should eq -166.0
    bb.bottom.should eq -225.0
    bb.right.should eq 1000.0
    bb.top.should eq 931.0
  end

  it "can calculate the width" do
    font = create_font
    text = "some longish text, repeat some longish text"

    tw = font.text_width(text)
    tw.numchars.should eq 43
    tw.numwords.should eq 7
    tw.width.should eq 19231
    tw.numspace.should eq 6

    m = font.measure_text(text, width: 100,
                                font_size: 16,
                                char_space: 1,
                                word_space: 1)
    m.len_included.should eq 5
    m.real_width.should eq 42.12.to_f32
  end
end

