defmodule Logi.Location do
  @moduledoc "The location where log message issued."

  @typedoc "A log message issued location."
  @opaque location :: :logi_location.location

  @typedoc "An application name."
  @type application :: atom

  @typedoc """
  A line number.

  `0` means "Unknonw Line".
  """
  @type line :: non_neg_integer

  @doc "Returns the current location of the caller."
  @spec current_location :: location
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

  @doc "Returns `true` if `x` is a `t:location/0` value, `false` otherwise."
  @spec is_location(any) :: boolean
  def is_location(x) do
    :logi_location.is_location x
  end

  @doc "Gets the application of `location`."
  @spec get_application(location) :: application
  def get_application(location) do
    :logi_location.get_application location
  end

  @doc "Gets the function of `location`."
  @spec get_function(location) :: atom
  def get_function(location) do
    :logi_location.get_function location
  end

  @doc "Gets the line of `location`."
  @spec get_line(location) :: line
  def get_line(location) do
    :logi_location.get_line location
  end

  @doc "Gets the module of `location`."
  @spec get_module(location) :: module
  def get_module(location) do
    :logi_location.get_module location
  end

  @doc "Gets the PID of `location`."
  @spec get_process(location) :: pid
  def get_process(location) do
    :logi_location.get_process location
  end
end
