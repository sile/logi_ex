defmodule Logi.Condition do
  @moduledoc "Sink Applicable Condition."

  @typedoc "The condition to determine which messages to be consumed by a sink."
  @type condition :: severity_condition | location_condition

  @typedoc """
  Condition based on the specified severity pattern.

  ### min
  - The messages with `min` or higher severity will be consumed.

  ### {min, max}
  - The messages with severity between `min` and `max` will be consumed.

  ### severities
  - The messages with severity included in `severities` will be consumed.

  ## Examples

  ```elixir
  iex> [:emergency, :alert]       = Logi.Condition.normalize(:alert)                  # level
  iex> [:warning, :notice, :info] = Logi.Condition.normalize({:info, :warning})       # range
  iex> [:alert, :debug, :info]    = Logi.Condition.normalize([:debug, :info, :alert]) # list
  ```
  """
  @type severity_condition ::
  min :: Logi.severity |
  {min :: Logi.severity, max :: Logi.severity} |
  severities :: [Logi.severity]

  @typedoc """
  The messages which satisfy `severity` (default is `debug`) and are sent from the specified location will be consumed.

  The location is specified by `application` and `module` (OR condition).

  NOTE: The modules which does not belong to any application are forbidden.

  ## Examples

  ```elixir
  iex> Logi.Condition.is_condition(%{:application => :stdlib})                             # application
  iex> Logi.Condition.is_condition(%{:application => [:stdlib, :kernel]})                  # applications
  iex> Logi.Condition.is_condition(%{:module => :lists})                                   # module
  iex> Logi.Condition.is_condition(%{:module => [:lists, :dict]})                          # modules
  iex> Logi.Condition.is_condition(%{:application => :kernel, :module => [:lists, :dict]}) # application and modules
  iex> Logi.Condition.is_condition(%{:severity => [:info, :alert], :module => :lists})     # severity and module
  ```
  """
  @type location_condition :: %{
    :severity => severity_condition,
    :application => Logi.Location.application | [Logi.Location.application],
    :module => module | [module]
  }

  @typedoc """
  The normalized form of a `t:condition/0`.

  ## Examples

  ```elixir
  iex> normalize = fn (c) -> :lists.sort(Logi.Condition.normalize c) end

  iex> normalize.(:info)
  [:alert, :critical, :emergency, :error, :info, :notice, :warning]

  iex> normalize.({:info, :alert})
  [:alert, :critical, :error, :info, :notice, :warning]

  iex> normalize.(%{:severity => [:info], :application => [:kernel, :stdlib]})
  [info: :kernel, info: :stdlib]

  iex> normalize.(%{:severity => [:info], :module => [:lists, Logi]})
  [{:info, :logi_ex, Logi}, {:info, :stdlib, :lists}]

  iex> normalize.(%{:severity => [:info], :application => :kernel, :module => [:lists, Logi]})
  [{:info, :kernel}, {:info, :logi_ex, Logi}, {:info, :stdlib, :lists}]
  ```
  """
  @type normalized_condition :: [
    Logi.severity |
    {Logi.severity, Logi.Location.application} |
    {Logi.severity, Logi.Location.application, module}
  ]

  @doc "Returns `true` if `x` is a valid `t:condition/0` value, otherwise `false`."
  @spec condition?(any) :: boolean
  def condition?(x) do
    :logi_condition.is_condition x
  end

  @doc "Returns a normalized form of `condition`."
  @spec normalize(condition) :: normalized_condition
  def normalize(condition) do
    :logi_condition.normalize condition
  end
end
