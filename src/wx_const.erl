-module(wx_const).
-compile(export_all).

-include_lib("wx/include/wx.hrl").

wx_horizontal() ->
    ?wxHORIZONTAL.

wx_vertical() ->
    ?wxVERTICAL.

wx_expand() ->
    ?wxEXPAND.

wx_all() ->
    ?wxALL.

wx_te_readonly() -> ?wxTE_READONLY.

wx_maximize_box() -> ?wxMAXIMIZE_BOX.