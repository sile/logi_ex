defmodule Logi.SinkWriter do
  @callback write(Logi.Context, any, any, any) :: any
  @callback get_writee(any) :: pid | :undefined

  def get_module(writer) do
    :logi_sink_writer.get_module writer
  end
  def get_state(writer) do
    :logi_sink_writer.get_state writer
  end
  def get_writee(writer) do
    :logi_sink_writer.get_writee writer
  end
  def is_callback_module(x) do
    :logi_sink_writer.is_callback_module x
  end
  def is_writer(x) do
    :logi_sink_writer.is_writer x
  end
  def new(module, state) do
    :logi_sink_writer.new module, state
  end
  def write(context, format, data, writer) do
    :logi_sink_writer.write context, format, data, writer
  end
end
