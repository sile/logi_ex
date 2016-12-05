defmodule Logi.SinkProc do
  @moduledoc """
  Functions for sink processes.

  A sink process manages the lifetime of a sink and a sink writer instance(`Logi.SinkWriter`).

  Sink process is spawned at time a sink is installed in a channel (`Logi.Channel.install_sink/2`).

  After spawned, the process should call `send_writer_to_parent/1` to
  notify available writer instance to the parent.

  If the root sink process exits, the associated sink is uninstalled from the channel.
  """

  @typedoc "The supervisor of a sink process."
  @type sink_sup :: pid

  @doc """
  Starts a new child sink process.

  NOTICE: This function can only be invoked in a sink process.
  """
  @spec start_child(Logi.Sink.sink) :: {:ok, sink_sup} | {:error, any}
  def start_child(sink) do
    :logi_sink_proc.start_child sink
  end

  @doc """
  Stops the sink process.

  NOTICE: This function can only be invoked in a sink process.
  """
  @spec stop_child(sink_sup) :: :ok
  def stop_child(sink_sup) do
    :logi_sink_proc.stop_child sink_sup
  end

  @doc """
  Sends `writer` to the parent sink process.

  The message `{:sink_writer, sink_sup, Logi.SinkWriter.writer}` is sent to the parent.

  NOTICE: This function can only be invoked in a sink process.
  """
  @spec send_writer_to_parent(Sink.SinkWriter.writer | :undefined) :: :ok
  def send_writer_to_parent(writer) do
    :logi_sink_proc.send_writer_to_parent writer
  end

  @doc """
  Receives a sink writer instance from the child sink process `sink_sup`.
  """
  @spec recv_writer_from_child(sink_sup, timeout) :: Logi.SinkWriter.writer | :undefined
  def recv_writer_from_child(sink_sup, timeout) do
    :logi_sink_proc.recv_writer_from_child sink_sup, timeout
  end
end
