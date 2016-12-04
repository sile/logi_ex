defmodule Logi.BuiltIn.Filter.Fun do
  @behaviour Logi.Filter

  def new(fun) do
    :logi_builtin_filter_fun.new fun
  end

  def filter(context, state) do
    :logi_builtin_filter_fun.filter context, state
  end
end
