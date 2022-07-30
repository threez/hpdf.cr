describe Hpdf::Image do
  it "has getters" do
    pdf = Hpdf::Doc.new
    pdf.page do

      # dash
      pattern, phase = dash
      pattern.should eq [] of Int32
      phase.should eq 0
    end
  end
end
