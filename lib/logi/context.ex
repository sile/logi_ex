defmodule Logi.Context do
  @moduledoc "Log Message Context."

  @typedoc "A context."
  @opaque context :: :logi_context.context

  @doc "Returns `true` if `x` is a `t:context/0` value, `false` otherwise."
  @spec is_context(any) :: boolean
  def is_context(context) do
    :logi_context.is_context context
  end

  @doc "Gets the channel of `context`."
  @spec get_channel(context) :: Logi.Channel.id
  def get_channel(context) do
    :logi_context.get_channel context
  end

  @doc "Gets the location of `context`."
  @spec get_location(context) :: Logi.Location.location
  def get_location(context) do
    :logi_context.get_location context
  end

  @doc "Gets the headers of `context`."
  @spec get_headers(context) :: Logi.headers
  def get_headers(context) do
    :logi_context.get_headers context
  end

  @doc "Gets the metadata of `context`."
  @spec get_metadata(context) :: Logi.metadata
  def get_metadata(context) do
    :logi_context.get_metadata context
  end

  @doc "Gets the severity of `context`"
  @spec get_severity(context) :: Logi.severity
  def get_severity(context) do
    :logi_context.get_severity context
  end

  @doc "Gets the timestamp of `context`."
  @spec get_timestamp(context) :: :erlang.timestamp
  def get_timestamp(context) do
    :logi_context.get_timestamp context
  end
end
