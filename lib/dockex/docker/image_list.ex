defmodule Dockex.Docker.ImageList do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, nil}
  end

  def data_changed() do
    GenServer.call(__MODULE__, :data_changed)
  end

  @impl true
  def handle_call(:data_changed, _, old_data) do
    case check_images_changed(old_data) do
      :current -> {:reply, :current, old_data}
      {:changed, new_data} -> {:reply, {:changed, new_data}, new_data}
    end
  end

  def check_images_changed(old_data) do
    data = list_images()
    case (old_data == data) do
      false -> {:changed, data}
      _ -> :current
    end
  end

  def list_images() do
    list_image_command()
    |> parse_data()
  end

  defp list_image_command() do
   {data, _} = System.cmd("docker", [
     "image", "ls",
     "--all", "--no-trunc",
     "--format", "table {{.Repository}}\\t{{.Tag}}\\t{{.ID}}\\t{{.CreatedAt}}\\t{{.Size}}"
     ])
   data
  end

  defp parse_data(data) do
    data
    |> split_rows()
    |> sort_rows()
  end

  defp split_rows(data)  do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn(row) ->
      parse_row_to_cells(row)
    end)
  end

  def parse_row_to_cells(data) do
    data
    |> String.split(~r{\s\s+}, trim: true)
  end

  defp sort_rows(data) do
    [cols|rest] = data
    sorted_rows = Enum.sort_by(
      rest, fn(row) ->
        [
          Enum.at(row, 3),
          Enum.at(row, 0),
          Enum.at(row, 2)
        ]
      end
    )
    [cols|Enum.reverse(sorted_rows)]
  end
end
