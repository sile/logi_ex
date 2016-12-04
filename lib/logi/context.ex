defmodule Logi.Context do
  def from_map(map) do
    :logi_context.from_map map
  end
  def to_map(context) do
    :logi_context.to_map context
  end
  def get_channel(context) do
    :logi_context.get_channel context
  end
  def get_headers(context) do
    :logi_context.get_headers context
  end
  def get_location(context) do
    :logi_context.get_location context
  end
  def get_metadata(context) do
    :logi_context.get_metadata context
  end
  def get_severity(context) do
    :logi_context.get_severity context
  end
  def get_timestamp(context) do
    :logi_context.get_timestamp context
  end
  def is_context(context) do
    :logi_context.is_context context
  end
  def new(channel, timestamp, severity, location, headers, metadatas) do
    :logi_context.new channel, timestamp, severity, location, headers, metadatas
  end
end
