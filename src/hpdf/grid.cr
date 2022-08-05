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
    # * *vertical_text_every* how often the verical text should
    #   appear in the grid as an indicator
    # * *vertical_fat_line_every* how often a fat line should be
    #   drawn vertically
    # * *horizontal_text_every* how often the horizontal text
    #   should be drawn
    # * *horizontal_fat_line_every* how often a fat line shoild
    #   be drawn horizontally
    def draw_grid(*, font_name = Base14::Helvetica,
                     step = 5,
                     vertical_text_every vte = 2,
                     vertical_fat_line_every vfle = 2,
                     horizontal_text_every hte = 10,
                     horizontal_fat_line_every hfle = 2)
      font = @doc.font(font_name)
      set_font_and_size font, 5

      self.gray_fill = 0.5
      self.gray_stroke = 0.8

      draw_horizontal_lines step: step, text_every: hte,
                            fat_line_every: hfle
      draw_horizontal_text step: step, text_every: hte,
                           fat_line_every: hfle
      draw_vertical_lines step: step, text_every: vte,
                          fat_line_every: vfle
      draw_vertical_text step: step, text_every: vte,
                         fat_line_every: vfle

      self.gray_fill = 0
      self.gray_stroke = 0
    end

    # part of `draw_grid`.
    def draw_horizontal_lines(*, step = 5,
                                 text_every = 2,
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

        if y % (step * text_every) == 0 && y > 0
          self.gray_stroke = 0.5

          move_to 0, y
          line_to step, y
          stroke

          self.gray_stroke = 0.8
        end

        y += step
      end
    end

    # part of `draw_grid`.
    def draw_vertical_lines(*, step = 5,
                               text_every = 10,
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

        if x % (step * text_every) == 0 && x > 0
          self.gray_stroke = 0.5

          move_to x, 0
          line_to x, step
          stroke

          move_to x, height
          line_to x, height - step
          stroke

          self.gray_stroke = 0.8
        end

        x += step
      end
    end

    # part of `draw_grid`.
    def draw_horizontal_text(*, step = 5,
                                text_every = 10,
                                fat_line_every = 2)
      y = 0
      while y < height
        if y % (step * fat_line_every) == 0 && y > 0
          text do
            move_text_pos step, y - 2
            show_text y.to_s
          end
        end

        y += step
      end
    end

    # part of `draw_grid`.
    def draw_vertical_text(*, step = 5,
                              text_every = 10,
                              fat_line_every = 2)
      x = 0
      while x < width
        if x % (step * text_every) == 0 && x > 0
          text do
            move_text_pos x, step
            show_text x.to_s
          end

          text do
            move_text_pos x, height - (step * text_every)
            show_text x.to_s
          end
        end

        x += step
      end
    end
  end
end
