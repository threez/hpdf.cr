module Hpdf
  # The table is the container for `Row`, which contain `Cell`.
  class Table
    property rows
    property rect

    # creates a new table using the given rect
    def initialize(@rect : Rectangle)
      @rows = [] of Row
    end

    # creates a new table with the given coordinates and dimensions
    def initialize(x : Number, y : Number, width : Number, height : Number)
      initialize(Rectangle.new(x, y, width, height))
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
    def render(page : Page, &block : (Table | Row | Cell, Rectangle) ->)
      row_index = 0

      # draw rows top down, this means an inverted order as tables,
      # are top down, while the pdf is bottom-top oriented
      (row_count - 1).to(0) do |i|
        column_offset = @rect.x
        row_rect = Rectangle.new(@rect.x,
          @rect.y + row_height * i,
          @rect.width,
          row_height)

        row = @rows[row_index]
        column_count = row.cells.reduce(0) { |sum, col| sum + col.span }

        row.cells.each do |cell|
          column_width = (@rect.width / column_count) * cell.span
          column_rect = Rectangle.new(column_offset,
            row_rect.y,
            column_width,
            row_height)
          cell.block.call(page, column_rect)
          block.call(cell, column_rect)

          column_offset += column_width
        end

        block.call(row, row_rect)
        row_index += 1
      end

      block.call(self, @rect)
    end

    # returns the number of rows
    def row_count
      rows.size
    end

    # returns the height of each row
    def row_height
      @rect.height / row_count
    end
  end

  # The row is part of a `Table` and hold multiple
  # `Cell` in the same vertical position.
  class Row
    property cells

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
