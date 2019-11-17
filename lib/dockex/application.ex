defmodule Dockex.Application do
  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      Dockex.Docker.ImageList,
      Dockex.Docker.ContainerList,
      Dockex.WindowServer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dockex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
