defmodule Dockex.UI.Grids do
  def create_grid(parent, sizer, mod) do
    grid = :wxGrid.new(
      parent,
      :wx_misc.newId(),
      [
        {:style, :wx_const.wx_te_readonly()},
        {:style, :wx_const.wx_maximize_box()}
      ]
    )
    :wxGrid.createGrid(grid, 0, 0)
    :wxSizer.add(
      sizer,
      grid,
      mod.sizer_flags()
    )
    :wxSizer.setItemMinSize(sizer, grid, mod.min_size())
    :wxGrid.connect(
      grid,
      :grid_cell_left_click,
      [{:callback, fn(_evt, obj) ->
        row = :wxGridEvent.getRow(obj)
        col = :wxGridEvent.getCol(obj)
        selected_rows = :wxGrid.getSelectedRows(grid)
        :wxGrid.clearSelection(grid)
        case Enum.member?(selected_rows, row) do
          false -> :wxGrid.selectRow(grid, row)
          _ -> :ok
        end
        :wxGrid.setGridCursor(grid, row, col)
        #:wxEvent.skip(obj)
      end}]
    )
    grid
  end

  def update_list_as_cells(ctl, image_data, autosize_indexes \\ []) do
    :wxGrid.beginBatch(ctl)
    rows = :wxGrid.getNumberRows(ctl)
    cols = :wxGrid.getNumberCols(ctl)
    case rows > 0 do
      false -> :ok
      _ -> :wxGrid.deleteRows(ctl, [{:numRows, rows}])
    end
    case cols > 0 do
      false -> :ok
      _ ->  :wxGrid.deleteCols(ctl, [{:numCols, cols}])
    end
    [first_row|rest_image_data] = image_data
    Enum.reduce(first_row, 0, fn(col, c_idx) ->
      :wxGrid.appendCols(ctl)
      :wxGrid.setColLabelValue(ctl, c_idx, col)
      c_idx + 1
    end)
    Enum.reduce(rest_image_data, 0, fn(r, y_idx) ->
      :wxGrid.appendRows(ctl)
      Enum.reduce(r, 0, fn(v, x_idx) ->
        :wxGrid.setCellValue(ctl, y_idx, x_idx, v)
        :wxGrid.setReadOnly(ctl, y_idx, x_idx, [{:isReadOnly, true}])
        x_idx + 1
      end)
      y_idx + 1
    end)
    Enum.reduce(first_row, 0, fn(_col, c_idx) ->
      case Enum.member?(autosize_indexes, c_idx) do
        false -> :ok
        _ -> :wxGrid.autoSizeColumn(ctl, c_idx)
      end
      c_idx + 1
    end)
    :wxGrid.endBatch(ctl)
  end
end
