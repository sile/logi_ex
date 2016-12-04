defmodule Logi.BuiltIn.Filter.Fun do
  @moduledoc """
  A built-in stateless filter which filters log messages by an arbitrary user defined function.

  Behaviours: `Logi.Filter`

  ## Note

  This module is mainly supposed to be used for ddebugging/testing purposes.

  If you want to set a particular filter to a lot of logger instances,
  it is recommended to define a specified filter for efficiency reasons.

  ## Examples

  ```elixir
  iex> sink = Logi.BuiltIn.Sink.Fun.new(:foo, fn (_, msg, _) -> IO.puts(msg) end)
  iex> {:ok, _} = Logi.Channel.install_sink(sink, :info)

  iex> filter_fun = fn (c) -> not Map.get(Logi.Context.get_metadata(c), :discard, false) end
  iex> logger = Logi.new([filter: Logi.BuiltIn.Filter.Fun.new(filter_fun)])
  iex> Logi.save_as_default logger

  iex> require Logi
  iex> Logi.info "hello world", [], [metadata: %{:discard => false}] # passed
  #OUTPUT# hello world

  iex> Logi.info "hello world", [], [metadata: %{:discard => true}] # discarded
  # No output: the log message was discarded by the filter
  ```
  """
  @behaviour Logi.Filter

  @typedoc "A log messages filter function."
  @type filter_fun :: (Logi.Context.context -> boolean)

  @doc """
  Creates a filter which filters log messages by `filter_fun`.
  """
  @spec new(filter_fun) :: Logi.Filter.filter
  def new(filter_fun) do
    :logi_builtin_filter_fun.new filter_fun
  end

  @doc false
  def filter(context, state) do
    :logi_builtin_filter_fun.filter context, state
  end
end
