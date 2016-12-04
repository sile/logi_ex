defmodule Logi.Condition do
  def is_condition(x) do
    :logi_condition.is_condition x
  end
  def normalize(condition) do
    :logi_condition.normalize condition
  end
end
