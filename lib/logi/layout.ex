defmodule Logi.Layout do
  @moduledoc """
  Log Message Layout Behaviour.

  This module defines the standard interface to format log messages issued by the functions in `Logi` module.
  (e.g., `Logi.info/3`, `Logi.warning/3`, etc)

  A layout instance may be installed into a channel along with an associated sink.

  ## Examples

  ```elixir
  iex> format_fun = fn (_, format, data) -> :lists.flatten(:io_lib.format("EXAMPLE: " <> format <> "\\n", data)) end
  iex> layout = Logi.BuiltIn.Layout.Fun.new format_fun
  iex> {:ok, _} = Logi.Channel.install_sink(Logi.BuiltIn.Sink.IoDevice.new(:foo, [layout: layout]), :info)
  iex> Logi.info "hello world"
  #OUTPUT# EXAMPLE: hello world
  ```
  """

  @doc "Message formatting function."
  @callback format(Logi.Context.context, :io.format, data, extra_data) :: formatted_data

  @typedoc "An instance of `Logi.Layout` behaviour implementation module."
  @opaque layout :: :logi_layout.layout

  @typedoc "A module that implements the `Logi.Layout` behaviour."
  @type callback_module :: module

  @typedoc """
  The value of the fourth arguemnt of the `c:format/4` callback function.

  If the `layout()` does not have an explicit `extra_data()`, `nil` will be passed instead.
  """
  @type extra_data :: any

  @typedoc """
  A data which is subject to format.

  This type is an alias of the type of second arguemnt of the `:io_lib.format/2`.
  """
  @type data :: [any]

  @typedoc "Formatted Data."
  @type formatted_data :: any

  @doc "Creates a new layout instance."
  @spec new(callback_module, extra_data) :: layout
  def new(module, extra_data \\ nil) do
    :logi_layout.new module, extra_data
  end

  @doc "Returns `true` if `x` is a `t:layout/0`, `false` otherwise."
  @spec layout?(any) :: boolean
  def layout?(x) do
    :logi_layout.is_layout x
  end

  @doc "Gets the module of `layout`."
  @spec get_module(layout) :: callback_module
  def get_module(layout) do
    :logi_layout.get_module layout
  end

  @doc "Gets the extra data of `layout`."
  @spec get_extra_data(layout) :: extra_data
  def get_extra_data(layout) do
    :logi_layout.get_extra_data layout
  end

  @doc "Returns an `formatted_data()` which represents `data` formatted by `layout` in accordance with `format` and `context`."
  @spec format(Logi.Context.context, :io.format, data, layout) :: formatted_data
  def format(context, format, data, layout) do
    :logi_layout.format context, format, data, layout
  end
end
