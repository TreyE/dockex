defmodule Dockex.UI.ImageDetailsFrame do

  @title "Image Details"

  def setup(wx) do
    f = :wxFrame.new(wx, -1, @title, [{:size, {640, 320}}])
    first_row = :wxBoxSizer.new(:wx_const.wx_vertical())
    detailsSizer = :wxFlexGridSizer.new(2)
    historyGrid = :wxGrid.new(
      f,
      :wx_misc.newId(),
      [
        {:style, :wx_const.wx_te_readonly()},
        {:style, :wx_const.wx_maximize_box()}
      ]
    )
    :wxGrid.createGrid(historyGrid, 0, 0)
    repoValue = label_and_value(f, detailsSizer, "Repository:")
    tagValue = label_and_value(f, detailsSizer, "Tag:")
    imageIDValue = label_and_value(f, detailsSizer, "Image ID:")
    createdAtValue = label_and_value(f, detailsSizer, "Created At:")
    sizeValue = label_and_value(f, detailsSizer, "Image ID:")
    :wxPanel.setSizer(f, first_row)
    :wxSizer.add(first_row, detailsSizer, details_sizer_flags())
    :wxSizer.add(first_row, historyGrid, text_box_sizer_flags())
    :wxFrame.connect(f, :close_window, [{:callback, fn(_evt, _obj) ->
       :wxFrame.hide(f)
    end}])
    {f, historyGrid, repoValue, tagValue, imageIDValue, createdAtValue, sizeValue}
  end

  def label_and_value(frame, details_sizer, label_name) do
    label = :wxStaticText.new(
      frame,
      :wx_misc.newId(),
      label_name,
      [
        {:style, :wx_const.wx_align_right()}
      ])
    value = :wxStaticText.new(
        frame,
        :wx_misc.newId(),
        "",
        [
          {:style, :wx_const.wx_align_left()}
        ])
    :wxSizer.add(details_sizer, label, form_label_sizer_flags())
    :wxSizer.add(details_sizer, value, form_value_sizer_flags())
    value
  end

  def form_label_sizer_flags() do
    :wxSizerFlags.new()
    |> :wxSizerFlags.proportion(1)
  end

  def form_value_sizer_flags() do
    :wxSizerFlags.new()
    |> :wxSizerFlags.expand()
    |> :wxSizerFlags.proportion(2)
  end

  def text_box_sizer_flags() do
    :wxSizerFlags.new()
    |> :wxSizerFlags.expand()
    |> :wxSizerFlags.proportion(1)
  end

  def details_sizer_flags() do
    :wxSizerFlags.new()
  end

  def show({frame, dc, rv, tv, iidv, cav, sv}, grid, row, _col) do
    rval = :wxGrid.getCellValue(grid, row, 0)
    tval = :wxGrid.getCellValue(grid, row, 1)
    iidval = :wxGrid.getCellValue(grid, row, 2)
    caval = :wxGrid.getCellValue(grid, row, 3)
    sval = :wxGrid.getCellValue(grid, row, 4)
    :wxStaticText.setLabel(rv, rval)
    :wxStaticText.setLabel(tv, tval)
    :wxStaticText.setLabel(iidv, iidval)
    :wxStaticText.setLabel(cav, caval)
    :wxStaticText.setLabel(sv, sval)
    :wxFrame.setTitle(frame, rval)
    img_data = Dockex.Docker.ImageDetails.image_details(to_string(iidval))
    Dockex.UI.Grids.update_list_as_cells(dc, img_data, [1,3])
    :wxGrid.setColSize(dc, 2, 200)
    :wxFrame.show(frame)
  end
end
