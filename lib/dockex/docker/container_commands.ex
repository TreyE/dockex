defmodule Dockex.Docker.ContainerCommands do
  def stop_container(container_id) do
    {data, _} = System.cmd("docker", [
      "container",
      "stop",
      to_string(container_id)
      ],
      stderr_to_stdout: true)
      IO.inspect(data)
    data
  end
end
