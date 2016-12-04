defmodule Logi.BuiltIn.Layout.Fun do
  @moduledoc """
  A built-in layout which formats log messages by an arbitrary user defined function.

  Behaviours: `Logi.Layout`.

  This layout formats log messages by `t:format_fun/0` which was specified by the argument of `new/1`.

  ## Note

  This module is provided for debuging/testing purposes only.


  A layout will be stored into a logi_channel's ETS.
  Then it will be loaded every time a log message is issued.
  Therefore if the format function (`t:format_fun/0`) of the layout is a huge size anonymous function,
  all log issuers which use the channel will have to pay a non negligible cost to load it.

  ## Examples

  ```elixir
  iex> layout0 = Logi.BuiltIn.Layout.Fun.new(fn (_, format, data) -> :io_lib.format("[LAYOUT_0] " <> format <> "\\n", data) end)
  iex> {:ok, _} = Logi.Channel.install_sink(Logi.BuiltIn.Sink.IoDevice.new(:foo, [layout: layout0]), :info)
  iex> Logi.info "hello world"
  #OUTPUT# [LAYOUT_0] hello world

  iex> layout1 = Logi.BuiltIn.Layout.Fun.new(fn (_, format, data) -> :io_lib.format("[LAYOUT_1] " <> format <> "\\n", data) end)
  iex> {:ok, _} = Logi.Channel.install_sink(Logi.BuiltIn.Sink.IoDevice.new(:bar, [layout: layout1]), :info)
  iex> Logi.info "hello world"
  #OUTPUT# [LAYOUT_1] hello world
  #OUTPUT# [LAYOUT_0] hello world
  ```
  """
  @behaviour Logi.Layout

  @typedoc "A log message formatting function."
  @type format_fun :: (Logi.Context.context, :io.format, Logi.Layout.data -> Logi.Layout.formatted_data)


  @doc "Creates a layout which formats log messages by `format_fun`."
  @spec new(format_fun) :: Logi.Layout.layout
  def new(format_fun) do
    :logi_builtin_layout_fun.new format_fun
  end

  @doc false
  def format(context, format, data, extra) do
    :logi_builtin_layout_fun.format context, format, data, extra
  end
end
