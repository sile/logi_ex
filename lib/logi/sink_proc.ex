defmodule Logi.SinkProc do
  def recv_writer_from_child(sink_sup, timeout) do
    :logi_sink_proc.recv_writer_from_child sink_sup, timeout
  end
  def send_writer_to_parent(writer) do
    :logi_sink_proc.send_writer_to_parent writer
  end
  def start_child(sink) do
    :logi_sink_proc.start_child sink
  end
  def stop_child(sink_sup) do
    :logi_sink_proc.stop_child sink_sup
  end
end
