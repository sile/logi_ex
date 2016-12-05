defmodule Logi.BuiltIn.Layout.Default do
  @moduledoc """
  A default layout for built-in sinks.

  Behaviours: `Logi.Layout`.

  This module layouts a log message by the following format:

  ```
  {yyyy}-{MM}-{dd} {HH}:{mm}:{ss}.{SSS} [{SEVERITY}] {NODE} {PID} {MODULE}:{FUNCTION}:{LINE} [{HEADER(KEY=VALUE)}*] {MESSAGE}\\n
  ```

  ## Note

  This module is provided for debuging/testing purposes only.
  The message format is not customizable.
  And no overload protection exists (e.g. if log message is too large, the caller process may hang).

  ## Examples

  ```elixir
  iex> layout = Logi.BuiltIn.Layout.Default.new
  iex> {:ok, _} = Logi.Channel.install_sink(Logi.BuiltIn.Sink.IoDevice.new(:foo, [layout: layout]), :info)
  iex> Logi.info "hello world"
  #OUTPUT# 2016-12-05 03:13:12.981 [info] nonode@nohost <0.150.0> nil:nil:132 [] hello world
  ```
  """
  @behaviour Logi.Layout

  @doc "Creates a layout."
  @spec new :: Logi.Layout.layout
  def new do
    :logi_builtin_layout_default.new
  end

  @doc false
  def format(context, format, data, extra) do
    :logi_builtin_layout_default.format context, format, data, extra
  end
end
