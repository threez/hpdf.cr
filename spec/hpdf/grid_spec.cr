require "../../src/hpdf"

class TestPage < Hpdf::Page
  include Hpdf::Grid
end

describe Hpdf::Grid do
  it "can set page size" do
    testdoc "grids" do
      page TestPage do
        draw_grid
      end
      page TestPage do
        draw_grid vertical_fat_line_every: 2,
                  horizontal_fat_line_every: 2,
                  step: 50
      end
      page TestPage do
        draw_grid vertical_fat_line_every: 1,
                  horizontal_fat_line_every: 2,
                  step: 100
      end
    end
  end
end
