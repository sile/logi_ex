defmodule Logi.Filter do
  @type state :: any
#  @type filter :: :logi_filter.filter

  @callback filter(Logi.Context, state) :: boolean | {boolean, state}

  def apply(context, filter) do
    :logi_filter.apply context, filter
  end
end
