defmodule Logi.Channel do
  @moduledoc """
  Log Message Channels.

  A channel (logically) receives log messages from loggers and delivers the messages to installed sinks.

  ## Examples

  ```elixir
  # CREATE CHANNEL
  iex> :ok = Logi.Channel.create :sample_log
  iex> Logi.Channel.which_channels
  [:sample_log, :logi_default_log] # 'logi_default_log' is created automatically when 'logi' application was started

  # INSTALL SINK
  iex> write_fun = fn (_, format, data) -> :io.format("[my_sink] " <> format <> "\\n", data) end
  iex> sink = Logi.BuiltIn.Sink.Fun.new :sample_sink, write_fun
  iex> {:ok, _} = Logi.Channel.install_sink :sample_log, sink, :info  # Installs `sink` with `:info` level
  iex> Logi.Channel.which_sinks :sample_log
  [:sample_sink]

  # OUTPUT LOG MESSAGE
  iex> require Logi
  iex> Logi.debug "hello world", [], [logger: :sample_log]
  # The message is not emitted (the severity is too low).

  iex> Logi.info "hello world", [], [logger: :sample_log]
  #OUTPUT# [my_sink] hello world

  iex> Logi.alert "hello world", [], [logger: :sample_log]
  #OUTPUT# [my_sink] hello world

  iex> Logi.info "hello world"  # If `logger` option is omitted, the default channel will be used
  # The message is not emitted (no sinks are installed to the default channel).
  ```
  """

  @typedoc "The identifier of a channel"
  @type id :: atom


  @typedoc """
  Options for `install_sink_opt/3`.

  ## if_exists
  - The confliction handling policy.
  - If a sink with the same identifier already exists,
      - `:error`: the function returns an error `{:error, {:already_installed, existing_sink}}`.
      - `:ignore`: the new sink is ignored. Then the function returns `{:ok, existing_sink}`.
      - `:supersede`: the new sink supersedes it. Then the function returns `{:ok, old_sink}`.
  - Default: `:supersede`
  """
  @type install_sink_options :: [
    {:if_exists, :error | :ignore | :supersede}
  ]

  @typedoc "The information of an installed sink."
  @type installed_sink :: %{
    :sink => Logi.Sink.sink,
    :condition => Logi.Confliction.condition,
    :sink_sup => Logi.SinkProc.sink_sup,
    :writer => Logi.SinkWriter.writer | :undefined
  }

  @doc """
  The default channel.

  This channel is created automatically when `logi_ex` application was started.

  NOTE: The default channel ID is the same as the default logger ID (`Logi.default_logger/0`).
  """
  @spec default_channel :: id
  def default_channel do
    :logi_channel.default_channel
  end

  @doc """
  Creates a new channel.

  If the channel already exists, nothing happens.

  If there exists a process or a ETS table with the same name as `channel`, the function crashes.
  """
  @spec create(id) :: :ok
  def create(channel) do
    :logi_channel.create channel
  end

  @doc """
  Deletes a channel.

  If the channel does not exists, it is silently ignored.
  """
  @spec delete(id) :: :ok
  def delete(channel) do
    :logi_channel.delete channel
  end

  @doc "Returns a list of all existing channels."
  @spec which_channels :: [id]
  def which_channels do
    :logi_channel.which_channels
  end

  @doc "Equivalent to `Logi.Channel.install_sink Logi.Channel.default_channel, sink, condition`."
  @spec install_sink(Logi.Sink.sink, Logi.Condition.condition) :: {:ok, old} | {:error, reason} when
  old: :undefined | installed_sink,
  reason: {:cannot_start, any}
  def install_sink(sink, condition) do
    :logi_channel.install_sink sink, condition
  end

  @doc "Equivalent to `Logi.Channel.install_sink_opt channel, sink, condition, []`."
  @spec install_sink(id, Logi.Sink.sink, Logi.Condition.condition) :: {:ok, old} | {:error, reason} when
  old: :undefined | installed_sink,
  reason: {:cannot_start, any}
  def install_sink(channel, sink, condition) do
    :logi_channel.install_sink channel, sink, condition
  end

  @doc "Equivalent to `Logi.Channel.install_sink_opt Logi.Channel.default_channel, sink, condition, options`."
  @spec install_sink_opt(Logi.Sink.sink, Logi.Condition.condition, install_sink_options) :: {:ok, old} | {:error, reason} when
  old: :undefined | installed_sink,
  reason: {:cannot_start, any} | {:already_installed, installed_sink}
  def install_sink_opt(sink, condition, options) do
    :logi_channel.install_sink_opt sink, condition, options
  end

  @doc """
  Installs `sink`.

  If failed to start a sink process specified by `logi_sink:get_spec(sink)`,
  the function returns `{:cannot_start, failure_reason}`.

  If there does not exist a sink which has the same identifier with a new one,
  the function returns `{:ok, :undefined}`.

  Otherwise the result value depends on the value of the `:if_exists` option
  (see the description of `t:install_sink_options/0` for details).
  """
  @spec install_sink_opt(id, Logi.Sink.sink, Logi.Condition.condition, install_sink_options) :: {:ok, old} | {:error, reason} when
  old: :undefined | installed_sink,
  reason: {:cannot_start, any} | {:already_installed, installed_sink}
  def install_sink_opt(channel, sink, condition, options) do
    :logi_channel.install_sink_opt channel, sink, condition, options
  end

  @doc "Equivalent to `Logi.Channel.uninstall_sink Logi.Channel.default_channel, sink_id`."
  @spec uninstall_sink(Logi.Sink.id) :: {:ok, installed_sink} | :error
  def uninstall_sink(sink_id) do
    :logi_channel.uninstall_sink sink_id
  end

  @doc """
  Uninstalls the sink which has the identifier `sink_id` from `channel`.

  The function returns `{:ok, sink}` if the specified sink exists in the channel, `:error` otherwise.
  """
  @spec uninstall_sink(id, Logi.Sink.id) :: {:ok, installed_sink} | :error
  def uninstall_sink(channel, sink_id) do
    :logi_channel.uninstall_sink channel, sink_id
  end

  @doc "Equivalent to `Logi.Channel.set_sink_condition Logi.Channel.default_channel, sink_id, condition`."
  @spec set_sink_condition(Logi.Sink.id, Logi.Condition.condition) :: {:ok, old} | :error when
  old: Logi.Condition.condition
  def set_sink_condition(sink_id, condition) do
    :logi_channel.set_sink_condition sink_id, condition
  end

  @doc """
  Sets the applicable condition of the `sink_id`.

  The function returns `{:ok, old}` if the specified sink exists in the channel, `:error` otherwise.
  """
  @spec set_sink_condition(id, Logi.Sink.id, Logi.Condition.condition) :: {:ok, old} | :error when
  old: Logi.Condition.condition
  def set_sink_condition(channel, sink_id, condition) do
    :logi_channel.set_sink_condition channel, sink_id, condition
  end

  @doc "Equivalent to `Logi.Channel.find_sink Logi.Channel.id, sink_id`."
  @spec find_sink(Logi.Sink.id) :: {:ok, installed_sink} | :error
  def find_sink(sink_id) do
    :logi_channel.find_sink sink_id
  end

  @doc """
  Searches for `sink_id` in `channel`.

  The function returns `{:ok, sink}`, or `:error` if `sink_id` is not present.
  """
  @spec find_sink(id, Logi.Sink.id) :: {:ok, installed_sink} | :error
  def find_sink(channel_id, sink_id) do
    :logi_channel.find_sink channel_id, sink_id
  end

  @doc "Returns a list of installed sinks."
  @spec which_sinks(id) :: [Logi.Sink.id]
  def which_sinks(channel \\ Logi.Channel.default_channel) do
    :logi_channel.which_sinks channel
  end

  @doc "Equivalent to `Logi.Channel.whereis_sink_proc Logi.Channel.default_channel, path`."
  @spec whereis_sink_proc([Logi.Sink.id]) :: pid | :undefined
  def whereis_sink_proc(path) do
    :logi_channel.whereis_sink_proc path
  end

  @doc "Returns the pid associated with `path`."
  @spec whereis_sink_proc(id, [Logi.Sink.id]) :: pid | :undefined
  def whereis_sink_proc(channel, path) do
    :logi_channel.whereis_sink_proc channel, path
  end
end
