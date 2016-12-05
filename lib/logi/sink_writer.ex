defmodule Logi.SinkWriter do
  @moduledoc """
  Sink Writer Behaviour.

  A sink writer will write log messages to a destination sink process.

  The main purpose of writers is to write messages to some output devices (e.g., tty, file, socket).
  """

  @doc "Writes a log message to somewhere."
  @callback write(Logi.Context.context, :io.format, Logi.Layout.data, state) :: written_data

  @doc "Gets the writee process of log messages."
  @callback get_writee(state) :: pid | :undefined

  @typedoc "A writer instance."
  @opaque writer :: {callback_module, state}

  @typedoc "A module that implements the `Logi.SinkWriter` behaviour."
  @type callback_module :: module

  @typedoc """
  The value of the fourth arguemnt of the `c:write/4` callback function.

  ## Note

  This value might be loaded from ETS every time when a log message is issued.
  Therefore, very huge state can cause a performance problem.
  """
  @type state :: any

  @typedoc "The data written to a sink."
  @type written_data :: Logi.Layout.formatted_data

  @doc "Creates a new writer instance."
  @spec new(callback_module, state) :: writer
  def new(module, state) do
    :logi_sink_writer.new module, state
  end

  @doc "Returns `true` if `x` is a `t:writer/0` instance, otherwise `false`."
  @spec writer?(any) :: boolean
  def writer?(x) do
    :logi_sink_writer.is_writer x
  end

  @doc "Returns `true` if `x` is a module which implements this behaviour, otherwise `false`."
  @spec callback_module?(any) :: boolean
  def callback_module?(x) do
    :logi_sink_writer.is_callback_module x
  end

  @doc "Gets the module of `writer`."
  @spec get_module(writer) :: callback_module
  def get_module(writer) do
    :logi_sink_writer.get_module writer
  end

  @doc "Gets the state of `writer`."
  @spec get_state(writer) :: state
  def get_state(writer) do
    :logi_sink_writer.get_state writer
  end

  @doc """
  Writes a log message.

  If it fails to write, an exception will be raised.
  """
  @spec write(Logi.Context.context, :io.format, Logi.Layout.data, writer) :: written_data
  def write(context, format, data, writer) do
    :logi_sink_writer.write context, format, data, writer
  end

  @doc """
  Gets the writee process of log messages.

  "writee" is the destination process of `t:written_data/0` of `write/4`.
  If such process is dead or unknown, the function returns `:undefined`.

  The result value might change on every call.
  """
  @spec get_writee(writer) :: pid | :undefined
  def get_writee(writer) do
    :logi_sink_writer.get_writee writer
  end
end
