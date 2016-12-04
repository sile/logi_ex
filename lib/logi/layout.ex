defmodule Logi.Layout do
  # TODO
  @callback format(Logi.Context, :io.format, any, any) :: any

  def format(context, format, data, layout) do
    :logi_layout.format context, format, data, layout
  end

  def get_extra_data(layout) do
    :logi_layout.get_extra_data layout
  end
  def get_module(layout) do
    :logi_layout.get_module layout
  end
  def is_layout(layout) do
    :logi_layout.is_layout layout
  end
  def new(module, state \\ nil) do
    :logi_layout.new module, state
  end
end
