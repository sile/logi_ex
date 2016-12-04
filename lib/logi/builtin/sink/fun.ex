defmodule Logi.BuiltIn.Sink.Fun do
  def new(sink_id, fun) do
    :logi_builtin_sink_fun.new sink_id, fun
  end
end
