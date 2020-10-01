defmodule Dockex.UI.ContainerContextMenu do
  def setup(_wx, _parent) do
     menu = :wxMenu.new("Container", [])
     start_menu_item = create_menu_item(menu, 1, "Start", "wxART_TICK_MARK")
     stop_menu_item = create_menu_item(menu, 2, "Stop", "wxART_CROSS_MARK")
     remove_menu_item = create_menu_item(menu, 3, "Remove", "wxART_CROSS_MARK")
     copy_menu_item = create_menu_item(menu, 4, "Copy")
     :wxMenu.append(menu, start_menu_item)
     :wxMenu.append(menu, stop_menu_item)
     :wxMenu.append(menu, remove_menu_item)
     :wxMenu.append(menu, copy_menu_item)
     menu
  end

  def show(grid, cm, x, y, {data, c_status}) do
    case to_string(c_status) do
      "Up" ->
        toggle_menu_item(cm, 1, false)
        toggle_menu_item(cm, 2, true)
        toggle_menu_item(cm, 3, false)
        toggle_menu_item(cm, 4, true)
      _ ->
        toggle_menu_item(cm, 1, true)
        toggle_menu_item(cm, 2, false)
        toggle_menu_item(cm, 3, true)
        toggle_menu_item(cm, 4, true)
    end
    :wxMenu.connect(
      cm,
      :command_menu_selected,
      [{:callback, fn(_evt, obj) ->
        event_id = :wxCommandEvent.getId(obj)
        case event_id do
          4 -> execute_copy_command(data)
          3 -> execute_remove_command(data)
          2 -> execute_stop_command(data)
          1 -> execute_start_command(data)
          _ -> :ok
        end
        :wxMenu.disconnect(cm, :command_menu_selected)
      end}]
    )
    :wxWindow.popupMenu(grid, cm, x, y)
  end

  def execute_stop_command(container_id) do
    {status, command_output} = Dockex.Docker.ContainerCommands.stop_container(container_id)
    command_dialog(status, command_output)
  end

  def execute_copy_command(container_id) do
    Dockex.Docker.ContainerCommands.copy_container_id(container_id)
  end

  def execute_start_command(container_id) do
    {status, command_output} = Dockex.Docker.ContainerCommands.start_container(container_id)
    command_dialog(status, command_output)
  end

  def execute_remove_command(container_id) do
    {status, command_output} = Dockex.Docker.ContainerCommands.remove_container(container_id)
    command_dialog(status, command_output)
  end

  defp create_menu_item(menu, id, label, bitmap \\ nil) do
    menu_item = :wxMenuItem.new([
      {:parentMenu, menu},
      {:id, id},
      {:text, label}
    ])
    case bitmap do
      nil -> :ok
      _ ->
        icon = :wxArtProvider.getBitmap(bitmap)
        :wxMenuItem.setBitmap(menu_item, icon)
    end
    menu_item
  end

  defp command_dialog(status, command_output) do
    dialog = :wxMessageDialog.new(
      :wx.null(),
      to_string(command_output),
      [
        {:caption, "Command Results: #{status}"},
        {:style, :wx_const.wx_ok()}
      ]
    )
    :wxMessageDialog.showModal(dialog)
  end

  defp toggle_menu_item(c_menu, item_index, enabled) do
    :wxMenu.enable(c_menu, item_index, enabled)
  end
end
