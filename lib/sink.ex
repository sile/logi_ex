defmodule Logi.Sink do
  def from_writer(sink_id, writer) do
    :logi_sink.from_writer sink_id, writer
  end
  def get_id(sink) do
    :logi_sink.get_id sink
  end
  def get_spec(sink) do
    :logi_sink.get_spec sink
  end
  def get_sup_flags(sink) do
    :logi_sink.get_sup_flags sink
  end
  def is_sink(x) do
    :logi_sink.is_sink x
  end
  def new(spec, flags \\ %{}) do
    :logi_sink.new spec, flags
  end
end
