defmodule Dockex.WindowServer do
  use GenServer

  @title "Dockex"

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def handle_info(:check_container_grid_changed, {_, _, cg, _, _} = state) do
    Dockex.UI.ContainerGrid.update_if_needed(cg)
    Process.send_after(__MODULE__, :check_container_grid_changed, 1000)
    {:noreply, state}
  end

  @impl true
  def handle_info(:check_image_grid_changed, {_, _, _, ig, _} = state) do
    Dockex.UI.ImageGrid.update_if_needed(ig)
    Process.send_after(__MODULE__, :check_image_grid_changed, 1000)
    {:noreply, state}
  end

  @impl true
  def handle_call({:show_image_details, row, col}, _from,  {_, _, _, ig, idf} = state) do
    Dockex.UI.ImageDetailsFrame.show(idf, ig, row, col)
    {:reply, :ok, state}
  end

  @impl true
  def init(_) do
    wx = :wx.new
    f = :wxFrame.new(wx, -1, @title, [{:size, {960, 480}}])
    first_row = :wxBoxSizer.new(:wx_const.wx_vertical())
    cg = Dockex.UI.ContainerGrid.create_grid(f, first_row)
    ig = Dockex.UI.ImageGrid.create_grid(f, first_row)
    :wxPanel.setSizer(f, first_row)
    Dockex.UI.ContainerGrid.update_if_needed(cg)
    Dockex.UI.ImageGrid.update_if_needed(ig)
    :wxSizer.fit(first_row, f)
    :wxFrame.show(f)
    :wxFrame.connect(f, :close_window, [{:callback, fn(_, _) ->
      spawn(fn -> System.stop() end)
    end}])
    idf = Dockex.UI.ImageDetailsFrame.setup(wx)
    Process.send_after(__MODULE__, :check_container_grid_changed, 2000)
    Process.send_after(__MODULE__, :check_image_grid_changed, 2500)
    {:ok, {wx, f, cg, ig, idf}}
  end

  def show_image_details(row, col) do
    GenServer.call(__MODULE__, {:show_image_details, row, col})
  end
end
