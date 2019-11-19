defmodule Dockex.Docker.ImageDetails do
  def image_details(image_id) do
    image_id
    |> image_history_command()
    |> split_rows()
    |> add_headers()
  end

  def image_history_command(image_id) do
    {data, _} = System.cmd("docker", [
      "image", "history",
      "--no-trunc",
      "--human=true",
      "--format={{json .}}",
      image_id
      ])
    data
  end

  defp split_rows(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn(row) ->
      parse_row_to_cells(row)
    end)
  end

  def parse_row_to_cells(data) do
    data
    |> Jason.decode!()
    |> row_from_json()
  end

  defp add_headers(rows) do
    [[
      "ID",
      "Created",
      "Created By",
      "Size",
      "Comment"
    ]|rows]
  end

  defp format_created_by(json) do
    json
    |> Map.get("CreatedBy", "")
    |> String.replace(" && ", " && \n  ", global: true)
  end

  defp row_from_json(json) do
    [
      Map.get(json, "ID", ""),
      Map.get(json, "CreatedSince", ""),
      format_created_by(json),
      Map.get(json, "Size", ""),
      Map.get(json, "Comment")
    ]
  end
end
