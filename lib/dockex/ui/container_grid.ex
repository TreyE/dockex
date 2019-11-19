defmodule Dockex.UI.ContainerGrid do

  def create_grid(parent, sizer) do
    Dockex.UI.Grids.create_grid(parent, sizer, __MODULE__)
  end

  def min_size() do
    {800, 240}
  end

  def sizer_flags() do
    :wxSizerFlags.new()
    |> :wxSizerFlags.expand()
    |> :wxSizerFlags.proportion(1)
  end

  def update_if_needed(ctl) do
    case Dockex.Docker.ContainerList.data_changed() do
      {:changed, new_data} -> Dockex.UI.Grids.update_list_as_cells(ctl, new_data, auto_size_columns())
      _ -> :ok
    end
  end

  def auto_size_columns() do
    [
      1,3,4
    ]
  end

  def register_left_click(grid) do
    :wxGrid.connect(
      grid,
      :grid_cell_left_click,
      [{:callback, fn(_evt, obj) ->
        row = :wxGridEvent.getRow(obj)
        col = :wxGridEvent.getCol(obj)
        selected_rows = :wxGrid.getSelectedRows(grid)
        selected_col = :wxGrid.getGridCursorCol(grid)
        :wxGrid.clearSelection(grid)
        case {Enum.member?(selected_rows, row), selected_col == col} do
          {true, true} -> :ok
          _ -> :wxGrid.selectRow(grid, row)
        end
        :wxGrid.setGridCursor(grid, row, col)
      end}]
    )
  end

  def register_left_doubleclick(grid) do
    :wxGrid.connect(
      grid,
      :grid_cell_left_dclick,
      [{:callback, fn(_evt, obj) ->
        row = :wxGridEvent.getRow(obj)
        col = :wxGridEvent.getCol(obj)
        :wxGrid.clearSelection(grid)
        :wxGrid.selectRow(grid, row)
        :wxGrid.setGridCursor(grid, row, col)
      end}]
    )
  end

  def register_grid_events(grid) do
    register_left_click(grid)
    register_left_doubleclick(grid)
    register_right_click(grid)
  end

  def register_right_click(grid) do
    :wxGrid.connect(
      grid,
      :grid_cell_right_click,
      [{:callback, fn(_evt, obj) ->
        row = :wxGridEvent.getRow(obj)
        col = :wxGridEvent.getCol(obj)
        {x, y} = :wxGridEvent.getPosition(obj)
        :wxGrid.clearSelection(grid)
        :wxGrid.selectRow(grid, row)
        :wxGrid.setGridCursor(grid, row, col)
        container_id = :wxGrid.getCellValue(grid, row, 0)
        spawn( fn ->  Dockex.WindowServer.show_container_menu(x, y, container_id) end)
      end}]
    )
  end
end
