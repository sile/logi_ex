defmodule Logi.BuiltIn.Sink.Fun do
  @moduledoc """
  A built-in sink which consumes log messages by an arbitrary user defined function.

  Behaviours: `Logi.SinkWriter`

  The default layout is `Logi.BuiltIn.Layout.Default.new()`.

  ## Note

  This module is provided for debuging/testing purposes only.

  A sink is stored into a logi_channel's ETS.
  Then it will be loaded every time a log message is issued.
  Therefore if the write function (`t:write_fun/0`) of the sink is a huge size anonymous function,
  all log issuers which use the channel will have to pay a non negligible cost to load it.

  And there is no overload protection.

  ## Examples

  ```elixir
  iex> write_fun = fn (_, format, data) -> :io.format("[CONSUMED] " <> format <> "\\n", data) end
  iex> {:ok, _} = Logi.Channel.install_sink Logi.BuiltIn.Sink.Fun.new(:foo, write_fun), :info

  iex> require Logi
  iex> Logi.info "hello world"
  #OUTPUT# [CONSUMED] hello world
  :ok
  ```
  """
  @behaviour Logi.SinkWriter

  @typedoc "A function which is used to consume log messages issued by `logi`."
  @type write_fun :: (Logi.Context.context, :io.format, Logi.Layout.data -> Logi.SinkWriter.written_data)

  @doc "Creats a new sink instance."
  @spec new(Logi.Sink.id, write_fun) :: Logi.Sink.sink
  def new(sink_id, fun) do
    :logi_builtin_sink_fun.new sink_id, fun
  end

  @doc false
  def write(context, format, data, fun) do
    :logi_builtin_sink_fun.write context, format, data, fun
  end

  @doc false
  def get_writee(writer) do
    :logi_builtin_sink_fun.get_writee writer
  end
end
