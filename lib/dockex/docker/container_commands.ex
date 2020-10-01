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
end
