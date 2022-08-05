module Hpdf
  # Grip is a helper to draw a fine grid on the page.
  # Use it in your custom `Doc#page` pages:
  #
  # ```
  # class MyPage < Hpdf::Page
  #   include Hpdf::Grid
  #   # ...
  # end
  #
  # Hpdf::Doc.build do |pdf|
  #   page(MyPage) do |page|
  #     # ...
  #   end
  # end
  # ```
  module Grid
    # draw the full grid
    def draw_grid
      font = @doc.font "Helvetica"

      set_font_and_size font, 5
      self.gray_fill = 0.5
      self.gray_stroke = 0.8

      draw_horizontal_lines
      draw_virtical_lines
      draw_horizontal_text
      draw_virtical_text

      self.gray_fill = 0
      self.gray_stroke = 0
    end

    def draw_horizontal_lines
      y = 0
      while y < height
        if y % 10 == 0
          self.line_width = 0.5
        elsif line_width != 0.25
          self.line_width = 0.25
        end

        move_to 0, y
        line_to width, y
        stroke

        if y % 10 == 0 && y > 0
          self.gray_stroke = 0.5

          move_to 0, y
          line_to 5, y
          stroke

          self.gray_stroke = 0.8
        end

        y += 5
      end
    end

    def draw_virtical_lines
      x = 0
      while x < width
        if x % 10 == 0
          self.line_width = 0.5
        elsif line_width != 0.25
          self.line_width = 0.25
        end

        move_to x, 0
        line_to x, height
        stroke

        if x % 50 == 0 && x > 0
          self.gray_stroke = 0.5

          move_to x, 0
          line_to x, 5
          stroke

          move_to x, height
          line_to x, height - 5
          stroke

          self.gray_stroke = 0.8
        end

        x += 5
      end
    end

    def draw_horizontal_text
      y = 0
      while y < height
        if y % 10 == 0 && y > 0
          text do
            move_text_pos 5, y - 2
            show_text y.to_s
          end
        end

        y += 5
      end
    end

    def draw_virtical_text
      x = 0
      while x < width
        if x % 50 == 0 && x > 0
          text do
            move_text_pos x, 5
            show_text x.to_s
          end

          text do
            move_text_pos x, height - 10
            show_text x.to_s
          end
        end

        x += 5
      end
    end
  end
end
