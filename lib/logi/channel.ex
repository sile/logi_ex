defmodule Logi.Channel do
  def create(channel) do
    :logi_channel.create channel
  end

  def delete(channel) do
    :logi_channel.delete channel
  end

  def find_sink(sink_id) do
    :logi_channel.find_sink sink_id
  end

  def find_sink(channel_id, sink_id) do
    :logi_channel.find_sink channel_id, sink_id
  end

  def default_channel do
    :logi_channel.default_channel
  end

  def which_channels do
    :logi_channel.which_channels
  end

  def which_sinks(channel \\ Logi.Channel.default_channel) do
    :logi_channel.which_sinks channel
  end

  def install_sink(sink, condition) do
    :logi_channel.install_sink sink, condition
  end

  def install_sink(channel, sink, condition) do
    :logi_channel.install_sink channel, sink, condition
  end

  def install_sink_opt(sink, condition, options) do
    :logi_channel.install_sink_opt sink, condition, options
  end

  def install_sink_opt(channel, sink, condition, options) do
    :logi_channel.install_sink_opt channel, sink, condition, options
  end

  def set_sink_condition(sink_id, condition) do
    :logi_channel.set_sink_condition sink_id, condition
  end

  def set_sink_condition(channel, sink_id, condition) do
    :logi_channel.set_sink_condition channel, sink_id, condition
  end

  def uninstall_sink(sink_id) do
    :logi_channel.uninstall_sink sink_id
  end

  def uninstall_sink(channel, sink_id) do
    :logi_channel.uninstall_sink channel, sink_id
  end

  def whereis_sink_proc(path) do
    :logi_channel.whereis_sink_proc path
  end

  def whereis_sink_proc(channel, path) do
    :logi_channel.whereis_sink_proc channel, path
  end
end
