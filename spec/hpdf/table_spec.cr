describe Hpdf::Table do
  it "can create a table" do
    testdoc "table" do
      page do
        sudoku = [
          [9, 0, 4, 0, 8, 0, 0, 0, 0],
          [0, 0, 0, 7, 0, 0, 0, 9, 0],
          [2, 8, 0, 0, 0, 0, 4, 0, 1],
          [0, 0, 0, 5, 1, 0, 0, 4, 6],
          [0, 2, 0, 0, 4, 0, 0, 0, 0],
          [0, 0, 5, 8, 0, 0, 9, 0, 7],
          [4, 0, 6, 0, 5, 8, 7, 1, 3],
          [5, 7, 2, 0, 3, 9, 0, 8, 4],
          [0, 1, 0, 0, 7, 6, 0, 0, 0],
        ]

        text Hpdf::Base14::Helvetica, 20 do
          move_text_pos 100, 450
          show_text "Sudoku"
        end

        table(x: 100, y: 100, width: 300, height: 300) do
          sudoku.each do |row_data|
            row do
              row_data.each do |val|
                cell do |p, rect|
                  if val != 0
                    # gray background for prefilled numbers
                    p.context do
                      p.gray_fill = 0.9
                      rectangle rect
                      fill
                    end

                    p.text Hpdf::Base14::Helvetica, 16 do
                      # center text
                      rect.x += 12
                      rect.y -= 7

                      # draw text
                      text_rect rect, val.to_s
                    end
                  end
                end
              end
            end
          end
        end

        text Hpdf::Base14::Helvetica, 20 do
          move_text_pos 100, 650
          show_text "Cell span"
        end

        table(x: 100, y: 500, width: 300, height: 120, line_width: 3) do
          row do
            cell span: 2 { }
            cell span: 4 { }
          end
          row do
            cell span: 2 { }
            cell span: 2 { }
            cell span: 2 { }
          end
          row do
            cell { }
            cell { }
            cell { }
            cell { }
            cell { }
            cell { }
          end
          row do
            cell span: 6 { }
          end
        end
      end
    end
  end
end
