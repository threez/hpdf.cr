module Hpdf
  # The table is the container for `Row`, which contain `Cell`.
  class Table
    property rows
    property rect
    property spacing

    # creates a new table using the given rect
    #
    # * *spacing* spacing between the cells, by default there is no spacing
    def initialize(@rect : Rectangle, *,
                   spacing : Number = 0,
                   @fixed_row_height : Number = 0)
      @rows = [] of Row
      @spacing = spacing.to_f32
    end

    # creates a new table with the given coordinates and dimensions
    #
    # * *spacing* spacing between the cells, by default there is no spacing
    # * *fixed_row_height* allows to specify the row height instead of calculation
    def initialize(x : Number, y : Number, width : Number, height : Number, *,
                   spacing : Number = 0,
                   fixed_row_height : Number = 0)
      initialize(Rectangle.new(x, y, width, height),
        spacing: spacing,
        fixed_row_height: fixed_row_height)
    end

    # creates a rows and yields the block with the newly created row
    # and adds it to the end (bottom) of the table
    def row(*, height = 0, allow_grow = false, &)
      row = Row.new(height: height, allow_grow: allow_grow)
      with row yield row
      add_row(row)
    end

    # adds the row to the end (bottom) of the table
    def add_row(row : Row)
      @rows << row
    end

    # render will call cell rendering for all cells. Then it will render
    # the rectangles for the cell, row and table using the passed function
    def render(page : Page, &block : (Table | Row | BaseCell, Symbol) ->)
      calc!

      block.call(self, :before)
      rows.each do |row|
        block.call(row, :before)
        row.cells.each do |cell|
          block.call(cell, :before)
          cell.render(page)
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
    def row_height(row)
      if row.height > 0
        row.height
      else
        if @fixed_row_height > 0
          if row.allow_grow?
            @fixed_row_height * row.grow_height
          else
            @fixed_row_height
          end
        else
          (@rect.height + @spacing) / row_count
        end
      end
    end

    # calculates the rectangles of all rows and cells respectively
    def calc!
      return if rows.empty?

      half_spacing = @spacing > 0 ? @spacing / 2 : 0

      # draw rows top down, this means an inverted order as tables,
      # are top down, while the pdf is bottom-top oriented
      top = 0
      rows.each do |row|
        column_offset = @rect.x - half_spacing
        top += row_height(row) - half_spacing

        row_rect = Rectangle.new(@rect.x,
          @rect.top - top,
          @rect.width + @spacing,
          row_height(row))

        row.rect = row_rect
        column_count = row.cells.reduce(0) { |sum, col| sum + col.span }

        row.cells.each do |cell|
          column_width = ((@rect.width + @spacing) / column_count) * cell.span
          column_rect = Rectangle.new(column_offset + half_spacing,
            row_rect.y + half_spacing,
            column_width - @spacing,
            row_height(row) - @spacing)
          cell.rect = column_rect
          column_offset += column_width
        end
      end
    end
  end

  # The row is part of a `Table` and hold multiple
  # `Cell` in the same vertical position.
  class Row
    property cells
    property rect : Rectangle?
    property height
    property? allow_grow : Bool

    # Create a new row
    def initialize(*, height = 0, allow_grow = false)
      @cells = [] of BaseCell
      @height = height
      @allow_grow = allow_grow
    end

    # creates a cell by capturing the block for the cell and
    # adding the cell to the end of the row
    def cell(*, span : Number = 1, &block : (Page, Rectangle) ->)
      add_cell Cell.new(span: span, allow_grow: @allow_grow, &block)
    end

    # creates a new text cell using the passed parameters
    def text_cell(text : String,
                  *,
                  span : Number = 1,
                  font : String = Hpdf::Base14::Helvetica,
                  font_size : Number = 11,
                  align : Hpdf::TextAlignment = Hpdf::TextAlignment::Left,
                  bg_gray : Float32 = 0)
      add_cell TextCell.new(text,
        span: span,
        allow_grow: @allow_grow,
        font: font,
        font_size: font_size,
        align: align,
        bg_gray: bg_gray)
    end

    # add the passed cell to the row (at the end)
    def add_cell(cell : BaseCell)
      @cells << cell
    end

    def grow_height : Float64
      if !allow_grow?
        1.to_f
      else
        @cells.max_of(&.grow_height)
      end
    end
  end

  # The cell is the smallest part of the `Table`. It is rendered before
  # all grids in the order it was inserted into the `Row` and `Table`.
  abstract class BaseCell
    property rect : Rectangle?
    property span
    property? allow_grow : Bool

    # Creates a cell with the provided block and stores the cell span.
    #
    # * *span* a cell can expand more then one cell (in the right direction)
    #          the default value `1` means no extend
    def initialize(*, span : Number = 1, @allow_grow = false)
      @span = span.to_f32
    end

    abstract def render(page : Page)

    # returns the factor by which the cell wants to grow in height
    abstract def grow_height : Float64
  end

  # The cell uses a simple captured block to render the cell content.
  class Cell < BaseCell
    property block

    # Creates a cell with the provided block to render. The block provides
    # a reference to the page and a rectange of the cell.
    #
    # * *span* a cell can expand more then one cell (in the right direction)
    #          the default value `1` means no extend
    def initialize(*, span : Number = 1, @allow_grow = false, &@block : (Page, Rectangle) ->)
      super(span: span, allow_grow: @allow_grow)
    end

    # renders the captured block
    def render(page : Page)
      @block.call(page, rect.as(Rectangle))
    end

    def grow_height : Float64
      1.to_f
    end
  end

  # The text cell renders the given text
  class TextCell < BaseCell
    property rect : Rectangle?

    def initialize(@text : String,
                   *,
                   span : Number = 1,
                   @allow_grow = false,
                   @font : String = Hpdf::Base14::Helvetica,
                   @font_size : Number = 11,
                   @align = Hpdf::TextAlignment::Center,
                   @bg_gray : Float32 = 0)
      super(span: span, allow_grow: @allow_grow)
    end

    # renders the captured block
    def render(page : Page)
      r = rect.as(Rectangle)
      if @bg_gray != 0
        page.context do
          page.gray_fill = @bg_gray
          page.rectangle r
          page.fill
        end
      end
      page.text @font, @font_size do
        # add left and right padding
        r = r.padding left: 2, right: 2
        if allow_grow?
          r.y -= @font_size.to_f32 / 2 - 1
        else
          # center text
          r.y -= (r.height.to_f32 / 2 - @font_size.to_f32 / 2) - 1
        end
        text_rect r, @text, align: @align
      end
    end

    def grow_height : Float64
      @text.count("\n").to_f + 1
    end
  end
end
