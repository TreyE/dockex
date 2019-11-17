defmodule Dockex.Docker.ContainerList do
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
    case check_containers_changed(old_data) do
      :current -> {:reply, :current, old_data}
      {:changed, new_data} -> {:reply, {:changed, new_data}, new_data}
    end
  end

  def check_containers_changed(old_data) do
    data = list_containers()
    case (old_data == data) do
      false -> {:changed, data}
      _ -> :current
    end
  end

  def list_containers() do
    list_container_command()
    |> parse_data()
  end

  defp list_container_command() do
   {data, _} = System.cmd("docker", ["container", "ps", "--all", "--no-trunc"])
   String.trim(data)
  end

  defp parse_data(data) do
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
end
