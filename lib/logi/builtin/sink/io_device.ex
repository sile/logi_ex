defmodule Logi.BuiltIn.Sink.IoDevice do
  @moduledoc """
  A built-in IO device sink.

  Behaviours: `Logi.SinkWriter`.

  This sink writes log messages to an IO device (e.g. standard output, file, etc).

  The default layout is `Logi.BuiltIn.Layout.Default.new`.

  ## Note

  This module is provided for debugging/testing purposes only.
  (e.g. Overload protection is missing)

  ## Examples

  The default IO device is `:standard_io`:

  ```elixir
  iex> require Logi
  iex> {:ok, _} = Logi.Channel.install_sink Logi.BuiltIn.Sink.IoDevice.new(:foo), :info
  iex> Logi.info "hello world"
  #OUTPUT# 2016-12-05 09:55:25.213 [info] nonode@nohost <0.142.0> nil:nil:28 [] hello world
  :ok
  ```

  Outputs to a file:

  ```elixir
  iex> {:ok, fd} = :file.open("foo.tmp", [:write])
  iex> sink = Logi.BuiltIn.Sink.IoDevice.new(:foo, [io_device: fd])
  iex> {:ok, _} = Logi.Channel.install_sink sink, :info
  iex> Logi.info "hello world"
  iex> :file.read_file "foo.tmp"
  {:ok, "2016-12-05 09:57:25.879 [info] nonode@nohost <0.142.0> nil:nil:32 [] hello world\\n"}
  ```

  Customizes message layout:

  ```elixir
  iex> layout = Logi.BuiltIn.Layout.Fun.new fn(_, format, data) -> :io_lib.format("[may_layout] " <> format <> "\\n", data) end
  iex> sink = Logi.BuiltIn.Sink.IoDevice.new :foo, [layout: layout]
  iex> {:ok, _} = Logi.Channel.install_sink sink, :info
  iex> Logi.info "hello world"
  #OUTPUT# [may_layout] hello world
  :ok
  ```
  """
  @behaviour Logi.SinkWriter

  @doc """
  Creates a new sink instance.

  ## Default Values
  - `:io_device`: `:standard_io`
  - `:layout`: `Logi.BuiltIn.Layout.Default.new`
  """
  @spec new(Logi.Sink.id, options) :: Logi.Sink.sink when
  options: [
    {:io_device, :io.device} |
    {:layout, Logi.Layout.layout}
  ]
  def new(id, options \\ []) do
    :logi_builtin_sink_io_device.new id, options
  end

  @doc false
  def write(context, format, data, state) do
    :logi_builtin_sink_io_device.write context, format, data, state
  end

  @doc false
  def get_writee(state) do
    :logi_builtin_sink_io_device.get_writee state
  end
end
