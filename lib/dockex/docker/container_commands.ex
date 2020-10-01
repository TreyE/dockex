defmodule Dockex.Docker.ContainerCommands do
  def stop_container(container_id) do
    {data, status} = System.cmd("docker", [
      "container",
      "stop",
      to_string(container_id)
      ],
      stderr_to_stdout: true)
    {status, data}
  end

  def start_container(container_id) do
    {data, status} = System.cmd("docker", [
      "container",
      "start",
      to_string(container_id)
      ],
      stderr_to_stdout: true)
    {status, data}
  end

  def remove_container(container_id) do
    {data, status} = System.cmd("docker", [
      "container",
      "rm",
      to_string(container_id)
      ],
      stderr_to_stdout: true)
    {status, data}
  end

  def copy_container_id(container_id) do
    {_data, _status} = System.cmd("bash", [
      "-c",
      "echo \"" <>
        to_string(container_id) <> "\" | " <>
        "pbcopy"
      ],
      stderr_to_stdout: true)
  end
end
