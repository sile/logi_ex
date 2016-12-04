defmodule Logi.BuiltIn.Sink.IoDevice do
  def new(id, options \\ []) do
    :logi_builtin_sink_io_device.new id, options
  end
end
