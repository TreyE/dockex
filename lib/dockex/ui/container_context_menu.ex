defmodule Dockex.UI.ContainerContextMenu do
  def setup(wx, parent) do
     menu = :wxMenu.new()
     stop_menu_item = :wxMenuItem.new([
       {:parentMenu, menu},
       {:id, 1},
       {:text, "Stop"}
     ])
     :wxMenu.append(menu, stop_menu_item)
     menu
  end

  def show(frame, grid, cm, x, y, data) do
    :wxMenu.connect(
      cm,
      :command_menu_selected,
      [{:callback, fn(_evt, obj) ->
        event_id = :wxCommandEvent.getId(obj)
        case event_id do
          1 -> execute_stop_command(data)
          _ -> :ok
        end
        :wxMenu.disconnect(cm, :command_menu_selected)
      end}]
    )
    :wxWindow.popupMenu(grid, cm, x, y)
  end

  def execute_stop_command(container_id) do
    command_output = Dockex.Docker.ContainerCommands.stop_container(container_id)
    dialog = :wxMessageDialog.new(
      :wx.null(),
      to_string(command_output),
      [
        {:caption, "Command Results"},
        {:style, :wx_const.wx_ok()}
      ]
    )
    :wxMessageDialog.showModal(dialog)
  end
end
