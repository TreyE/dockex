defmodule Dockex.UI.ImageGrid do
  def create_grid(parent, sizer) do
    Dockex.UI.Grids.create_grid(parent, sizer, __MODULE__)
  end

  def min_size() do
    {800, 240}
  end

  def autosize_indexes() do
    [
      0,1,3,4
    ]
  end

  def sizer_flags() do
    :wxSizerFlags.new()
    |> :wxSizerFlags.expand()
    |> :wxSizerFlags.proportion(1)
  end

  def update_if_needed(ctl) do
    case Dockex.Docker.ImageList.data_changed() do
      {:changed, new_data} -> Dockex.UI.Grids.update_list_as_cells(ctl, new_data, autosize_indexes())
      _ -> :ok
    end
  end
end
