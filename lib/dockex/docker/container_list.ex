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
    |> add_headers()
  end

  defp list_container_command() do
   {data, _} = System.cmd(
     "docker",
     [
       "container",
       "ps",
       "--all",
       "--no-trunc",
       "--format={{json .}}"
     ]
    )
   String.trim(data)
  end

  defp parse_data(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn(row) ->
      parse_row_to_cells(row)
    end)
  end

  defp parse_row_to_cells(data) do
    Jason.decode!(data)
    |> extract_json
  end

  defp extract_json(data) do
    [
      Map.get(data, "ID", ""),
      Map.get(data, "Image", ""),
      Map.get(data, "Command", ""),
      Map.get(data, "CreatedAt", ""),
      get_status(data),
      Map.get(data,"Ports", ""),
      Map.get(data, "Names", "")
    ]
  end

  defp get_status(data) do
    data
    |> Map.get("Status", "")
    |> String.split(" ")
    |> Enum.at(0, "")
  end

  defp add_headers(data) do
    [
      [
        "Container ID",
        "Image",
        "Command",
        "Created",
        "Status",
        "Ports",
        "Names"
      ]|data
    ]
  end
end
