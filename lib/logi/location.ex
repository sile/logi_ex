defmodule Logi.Location do
  defmacro current_location do
    quote do
      :logi_location.unsafe_new(
        self,
        unquote(Application.get_application(__CALLER__.module)),
        unquote(__CALLER__.module),
        unquote(case __CALLER__.function do
          {f, _} -> f
          _ -> nil
        end),
        unquote(__CALLER__.line))
    end
  end

  def from_map(map) do
    :logi_location.from_map map
  end
  def to_map(location) do
    :logi_location.to_map location
  end
  def get_application(location) do
    :logi_location.get_application location
  end
  def get_function(location) do
    :logi_location.get_function location
  end
  def get_line(location) do
    :logi_location.get_line location
  end
  def get_module(location) do
    :logi_location.get_module location
  end
  def get_process(location) do
    :logi_location.get_process location
  end
  def is_location(location) do
    :logi_location.is_location location
  end
end
