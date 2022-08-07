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
    # draws a gray grid on the current page.
    #
    # * *font_name* the text for the grid axes
    # * *step* the step size in points that should be used by
    #   the grid
    # * *vertical_fat_line_every* how often a fat line should be
    #   drawn vertically, every fat line has a text marker
    # * *horizontal_fat_line_every* how often a fat line shoild
    #   be drawn horizontally, every fat line has a text marker
    def draw_grid(*, font_name = Base14::Helvetica,
                     step = 5,
                     vertical_fat_line_every vfle = 10,
                     horizontal_fat_line_every hfle = 2)
      context do
        font = @doc.font(font_name)
        set_font_and_size font, 5

        self.gray_fill = 0.5
        self.gray_stroke = 0.8
        self.text_rendering_mode = TextRenderingMode::FillThenStroke

        draw_horizontal_lines step: step, fat_line_every: hfle
        draw_vertical_lines step: step, fat_line_every: vfle
        draw_horizontal_text step: step, fat_line_every: hfle
        draw_vertical_text step: step, fat_line_every: vfle
      end
    end

    # part of `draw_grid`.
    def draw_horizontal_lines(*, step = 5,
                                 fat_line_every = 2)
      y = 0
      while y < height
        if y % (step * fat_line_every) == 0
          self.line_width = 0.5
        elsif line_width != 0.25
          self.line_width = 0.25
        end

        move_to 0, y
        line_to width, y
        stroke

        if y % (step * fat_line_every) == 0 && y > 0
          self.gray_stroke = 0.5

          move_to 0, y
          line_to 5, y
          stroke

          self.gray_stroke = 0.8
        end

        y += step
      end
    end

    # part of `draw_grid`.
    def draw_vertical_lines(*, step = 5,
                               fat_line_every = 2)
      x = 0
      while x < width
        if x % (step * fat_line_every) == 0
          self.line_width = 0.5
        elsif line_width != 0.25
          self.line_width = 0.25
        end

        move_to x, 0
        line_to x, height
        stroke

        if x % (step * fat_line_every) == 0 && x > 0
          self.gray_stroke = 0.5

          move_to x, 0
          line_to x, 5
          stroke

          move_to x, height
          line_to x, height - 5
          stroke

          self.gray_stroke = 0.8
        end

        x += step
      end
    end

    # part of `draw_grid`.
    def draw_horizontal_text(*, step = 5,
                                fat_line_every = 2)

      context do
        self.gray_fill = 0.8
        self.gray_stroke = 0.5

        y = 0
        while y < height
          if y % (step * fat_line_every) == 0 && y > 0
            text do
              move_text_pos 5, y - 2
              show_text y.to_s
            end
          end

          y += step
        end
      end
    end

    # part of `draw_grid`.
    def draw_vertical_text(*, step = 5,
                              fat_line_every = 2)
      context do
        self.gray_fill = 0.8
        self.gray_stroke = 0.5

        x = 0
        while x < width
          if x % (step * fat_line_every) == 0 && x > 0
            text do
              move_text_pos x + 1, 1
              show_text x.to_s
            end

            text do
              move_text_pos x + 1, height - 4
              show_text x.to_s
            end
          end

          x += step
        end
      end
    end
  end
end
