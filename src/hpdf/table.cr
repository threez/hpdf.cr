module Hpdf
  # The table is the container for `Row`, which contain `Cell`.
  class Table
    property rows
    property rect
    property spacing

    # creates a new table using the given rect
    #
    # * *spacing* spacing between the cells, by default there is no spacing
    def initialize(@rect : Rectangle, *, spacing : Number = 0)
      @rows = [] of Row
      @spacing = spacing.to_f32
    end

    # creates a new table with the given coordinates and dimensions
    #
    # * *spacing* spacing between the cells, by default there is no spacing
    def initialize(x : Number, y : Number, width : Number, height : Number, *,
                   spacing : Number = 0)
      initialize(Rectangle.new(x, y, width, height), spacing: spacing)
    end

    # creates a rows and yields the block with the newly created row
    # and adds it to the end (bottom) of the table
    def row(&block)
      row = Row.new
      with row yield row
      add_row(row)
    end

    # adds the row to the end (bottom) of the table
    def add_row(row : Row)
      @rows << row
    end

    # render will call cell rendering for all cells. Then it will render
    # the rectangles for the cell, row and table using the passed function
    def render(page : Page, &block : (Table | Row | Cell, Symbol) ->)
      calc!

      block.call(self, :before)
      rows.each do |row|
        block.call(row, :before)
        row.cells.each do |cell|
          block.call(cell, :before)
          cell.block.call(page, cell.rect.as(Rectangle))
          block.call(cell, :after)
        end
        block.call(row, :after)
      end
      block.call(self, :after)
    end

    # returns the number of rows
    def row_count
      rows.size
    end

    # returns the height of each row
    def row_height
      (@rect.height + @spacing) / row_count
    end

    # calculates the rectangles of all rows and cells respectively
    def calc!
      row_index = 0
      half_spacing = @spacing > 0 ? @spacing / 2 : 0

      # draw rows top down, this means an inverted order as tables,
      # are top down, while the pdf is bottom-top oriented
      (row_count - 1).to(0) do |i|
        column_offset = @rect.x - half_spacing
        row_rect = Rectangle.new(@rect.x,
          @rect.y + row_height * i - half_spacing,
          @rect.width + @spacing,
          row_height)

        row = @rows[row_index]
        row.rect = row_rect
        column_count = row.cells.reduce(0) { |sum, col| sum + col.span }

        row.cells.each do |cell|
          column_width = ((@rect.width + @spacing) / column_count) * cell.span
          column_rect = Rectangle.new(column_offset + half_spacing,
            row_rect.y + half_spacing,
            column_width - @spacing,
            row_height - @spacing)
          cell.rect = column_rect
          column_offset += column_width
        end

        row_index += 1
      end
    end
  end

  # The row is part of a `Table` and hold multiple
  # `Cell` in the same vertical position.
  class Row
    property cells
    property rect : Rectangle?

    # Create a new row
    def initialize
      @cells = [] of Cell
    end

    # creates a cell by capturing the block for the cell and
    # adding the cell to the end of the row
    def cell(*, span : Number = 1, &block : (Page, Rectangle) ->)
      add_cell Cell.new(span: span, &block)
    end

    # add the passed cell to the row (at the end)
    def add_cell(cell : Cell)
      @cells << cell
    end
  end

  # The cell is the smallest part of the `Table`. It is rendered before
  # all grids in the order it was inserted into the `Row` and `Table`.
  class Cell
    property block
    property span
    property rect : Rectangle?

    # Creates a cell with the provided block to render. The block provides
    # a reference to the page and a rectange of the cell.
    #
    # * *span* a cell can expand more then one cell (in the right direction)
    #          the default value `1` means no extend
    def initialize(*, span : Number = 1, &@block : (Page, Rectangle) ->)
      @span = span.to_f32
    end
  end
end
