defmodule Logi.Sink do
  @moduledoc """
  Sinks.

  A sink has the specification of a sink process (see `Logi.SinkProc`).
  A sink process manages a sink writer (See `Logi.SinkWriter`).

  See the documentations of `Logi.BuiltIn.Sink.*` modules for usage examples.
  """

  @typedoc "A sink"
  @opaque sink :: :logi_sink.sink

  @typedoc """
  The identifier of a sink.

  The scope of an identifier is limited in siblings with the same parent.
  """
  @type id :: any

  @typedoc """
  The specification of a sink process.

  See Erlang official documents of `:supervisor` for more information.

  NOTE: `:restart` field is ignored (always regarded as `:permanent`).
  """
  @type spec :: :supervisor.child_spec

  @typedoc """
  The supervise flags of a sink process.

  See Erlang official documents of `:supervisor` for more information.

  NOTE: `:strategy` field is ignored.
  """
  @type sup_flags :: :supervisor.sup_flags

  @doc "Creates a new sink."
  @spec new(spec, sup_flags) :: sink
  def new(spec, flags \\ %{}) do
    :logi_sink.new spec, flags
  end

  @doc """
  Creates a sink from standalone a writer instance.

  No specific sink process is needed by `writer` to write log messages.
  """
  @spec from_writer(Logi.Sink.id, Logi.SinkWriter.writer) :: sink
  def from_writer(sink_id, writer) do
    :logi_sink.from_writer sink_id, writer
  end

  @doc "Returns `true` if `x` is a `t:sink/0` value, `false` otherwise."
  @spec sink?(any) :: boolean
  def sink?(x) do
    :logi_sink.is_sink x
  end

  @doc "Equivalent to `Logi.Sink.get_spec(sink)[:id]`."
  @spec get_id(sink) :: id
  def get_id(sink) do
    :logi_sink.get_id sink
  end

  @doc """
  Gets the process specification of `sink`.

  The type of the return value is always map.
  """
  @spec get_spec(sink) :: spec
  def get_spec(sink) do
    :logi_sink.get_spec sink
  end

  @doc """
  Gets the supervise flags of `sink`.

  The type of the return value is always map.
  """
  @spec get_sup_flags(sink) :: sup_flags
  def get_sup_flags(sink) do
    :logi_sink.get_sup_flags sink
  end
end
