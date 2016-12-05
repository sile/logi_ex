defmodule Logi.Filter do
  @moduledoc """
  Log Message Filter Behaviour.

  A filter decides whether to allow a message be sent to the target channel.

  ## Note

  A filter should not raise exceptions when it's `c:filter/2` is called.

  If any exception is raised, the invocation of the log function will be aborted and
  the exception will be propagated to the caller process.

  ## Examples

  ```elixir
  iex> require Logi

  iex> write = fn (_, format, data) -> :io.format format <> "\\n", data end
  iex> {:ok, _} = Logi.Channel.install_sink(Logi.BuiltIn.Sink.Fun.new(:foo, write), :info)

  iex> filter = fn (context) -> not Map.get(Logi.Context.get_metadata(context), :discard, false) end
  iex> logger = Logi.new([filter: Logi.BuiltIn.Filter.Fun.new(filter)])
  iex> Logi.save_as_default logger

  iex> Logi.info "hello world"
  #OUTPUT# hello world

  iex> Logi.info "hello world", [], [metadata: %{:discard => true}]
  # No output: the log message was discarded by the filter
  ```
  """

  @typedoc """
  An instance of `Logi.Filter` behaviour implementation module.
  """
  @opaque filter :: {callback_module, state} | callback_module


  @typedoc """
  A module that implements the `Logi.Filter` behaviour.
  """
  @type callback_module :: module

  @typedoc """
  The value of the second arguemnt of the `c:filter/2` callback function.

  If a `filter()` does not have an explicit `state()`, `nil` will be passed instead.
  """
  @type state :: any

  @doc """
  Log messages filtering function.

  This function decides whether to allow a message be sent to the target channel.
  If it returns `false` (or `{false, state}`), the message will be dropped.
  """
  @callback filter(Logi.Context.context, state) :: boolean | {boolean, state}

  @doc """
  Creates a new filter instance.
  """
  @spec new(callback_module, state) :: filter
  def new(callback_module, state \\ nil) do
    :logi_filter.new callback_module, state
  end

  @doc """
  Returns `true` if `x` is a `t:filter/0` value, `false` otherwise.
  """
  @spec filter?(any) :: boolean
  def filter?(x) do
    :logi_filter.is_filter x
  end

  @doc "Gets the module of `filter`."
  @spec get_module(filter) :: callback_module()
  def get_module(filter) do
    :logi_filter.get_module filter
  end

  @doc "Gets the state of `filter`."
  @spec get_state(filter) :: state()
  def get_state(filter) do
    :logi_filter.get_state filter
  end

  @doc """
  Applies `filter`.

  This function returns `do_allow` if the state of `filter` is not changed, `{do_allow, new_filter}` otherwise.
  """
  @spec apply(Logi.Context.context, filter) :: do_allow | {do_allow, new_filter} when
  do_allow: boolean,
  new_filter: filter
  def apply(context, filter) do
    :logi_filter.apply context, filter
  end
end
