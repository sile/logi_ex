defmodule Logi.BuiltIn.Sink.Composite do
  def new(sink_id, children) do
    :logi_builtin_sink_composite.new sink_id, children
  end
  def get_children(pid) do
    :logi_builtin_sink_composite.get_children pid
  end
  def set_active_writer(pid, nth) do
    :logi_builtin_sink_composite.set_active_writer pid, nth
  end
  def unset_active_writer(pid) do
    :logi_builtin_sink_composite.unset_active_writer pid
  end
end
