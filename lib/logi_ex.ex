defmodule Logi do
  @moduledoc """
  Logger Interface.

  This module mainly provides logger related functions.
  A logger has own headers, metadata, filter and can issue log messages to a destination channel.

  It is an Elixir interface of the Erlang [logi](https://github.com/sile/logi) library.

  ## Examples

  Basic usage:

  ```elixir
  iex> require Logi

  # Installs a sink to the default channel
  iex> Logi.Channel.install_sink(Logi.BuiltIn.Sink.IoDevice.new(:foo), :info)
  {:ok, :undefined}

  iex> Logi.info "hello world"
  #OUTPUT# 2016-12-04 20:04:44.308 [info] nonode@nohost <0.150.0> nil:nil:3 [] hello world
  :ok
  ```
  """

  @typedoc """
  Severity of a log message.

  It follwed the severities which are described in [RFC 5424](https://tools.ietf.org/html/rfc5424#section-6.2.1).
  """
  @type severity :: :debug | :info | :notice | :warning | :error | :critical | :alert | :emergency

  @typedoc """
  A logger.
  """
  @type logger :: logger_id | logger_instance

  @typedoc """
  The ID of a saved logger instance (see: `save/2`).

  If such a logger instance does not exist,
  the ID will be regarded as an alias of the expression `new([{:channel, logger_id}])`.
  """
  @type logger_id :: atom

  @typedoc """
  A logger instance.
  """
  @opaque logger_instance :: :logi_logger.logger

  @typedoc """
  The map representation of a logger.

  `filter` and `next` fields are optional
  (e.g. If a logger has no filter, the `filter` field is omitted from the corresponding map).
  """
  @type logger_map_form :: %{
    :channel  => Logi.Channel.id,
    :headers  => headers,
    :metadata => metadata,
    :filter   => Logi.Filter.filter,
    :next     => logger_instance
  }

  @typedoc """
  The headers of a log message.

  Headers are intended to be included in the outputs written by sinks.
  """
  @type headers :: %{}

  @typedoc """
  The metadata of a log message

  Metadata are not intended to be included directly in the outputs written by sinks.
  The main purpose of metadata is to provide means to convey information from the log issuer to filters or sinks.
  """
  @type metadata :: %{}

  @typedoc """
  Options for `new/1`.

  ### channel
   - The destination channel
   - The log messages issued by the created logger will (logically) send to the channel
   - Default: `Logi.Channel.default_channel`

  ### headers
  - The headers of the created logger
  - Default: `${}`

  ### metadata
  - The metadata of the created logger
  - Default: `%{}`

  ### filter
   - A log message filter
   - Default: none (optional)

  ### next
  - A next logger
  - An application of the some function (e.g. `log/4`) to the created logger is also applied to the next logger
  - Default: none (optional)
  """
  @type new_options :: [
    {:channel, Logi.Channel.id} |
    {:headers, headers} |
    {:metadata, metadata} |
    {:filter, Logi.Filter.filter} |
    {:next, logger_instance}
  ]

  @typedoc """
  Options for `log/4` and related macros.

  ### logger
  - The logger of interest
  - Default: `Logi.default_logger`

  ### location
  - The log message issued location
  - Default: `Logi.Location.current_location`

  ### headers
  - The headers of the log message
  - They are merged with the headers of the logger (the former has priority when key collisions occur)
  - Default: `%{}`

  ### metadata
  - The metadata of the log message
  - They are merged with the metadata of the logger (the former has priority when key collisions occur)
  - Default: `%{}`

  ### timestamp
  - The log message issued time
  - Default: `:os.timestamp`
  """
  @type log_options :: [
    {:logger, logger} |
    {:location, Logi.Location.location} |
    {:headers, headers} |
    {:metadata, metadata} |
    {:timestamp, :erlang.timestamp}
  ]

  @doc """
  Returns the default logger.

  The default channel `Logi.Channel.default_channel/0` which corresponds to the logger
  is started automatically when `logi_ex` application was started.
  """
  @spec default_logger :: logger_id
  def default_logger do
    :logi.default_logger
  end

  @doc """
  Returns the available severity list.

  The list are ordered by the their severity level (see: `severity_level/1`).
  """
  @spec severities :: [severity]
  def severities do
    :logi.severities
  end

  @doc """
  Returns the level of `severity`.

  The higher the severity is, the lower the level is.
  """
  @spec severity_level(severity) :: 1..8
  def severity_level(severity) do
    :logi.severity_level severity
  end

  @doc """
  Returns `true` if `x` is a severity, otherwise `false`.
  """
  @spec is_severity(any) :: boolean
  def is_severity(x) do
    :logi.is_severity x
  end

  @doc """
  Creates a new logger instance.
  """
  @spec new(new_options) :: logger_instance
  def new(options \\ []) do
    :logi.new options
  end

  @doc """
  Returns `true` if `x` is a logger, otherwise `false`.
  """
  @spec is_logger(any) :: boolean
  def is_logger(x) do
    :logi.is_logger x
  end

  @doc """
  Converts `logger` into a map form.

  The optional entries (i.e. `filter` and `next`) will be omitted from the resulting map if the value is not set.

  ## Examples

  ```elixir
  iex> Logi.to_map(Logi.new)
  %{channel: :logi_default_log, headers: %{}, metadata: %{}}

  iex> Logi.to_map(Logi.new([next: Logi.new]))
  %{channel: :logi_default_log, headers: %{}, metadata: %{},
  next: {:logi_logger, :logi_default_log, %{}, %{}, :undefined, :undefined}}
  ```
  """
  @spec to_map(logger) :: logger_map_form
  def to_map(logger) do
    :logi.to_map logger
  end

  @doc """
  Creates a new logger instance from `map`.

  ## Default Values
  - channel: `Logi.Channel.default_channel`
  - headers: `%{}`
  - metadata: `%{}`
  - filter: none (optional)
  - next: none (optional)

  ## Examples

  ```elixir
  iex> Logi.to_map(Logi.from_map(%{}))
  %{channel: :logi_default_log, headers: %{}, metadata: %{}}
  ```
  """
  @spec from_map(logger_map_form) :: logger_instance
  def from_map(map) do
    :logi.from_map map
  end

  @doc """
  Flattens the nested logger.

  The nested loggers are collected as a flat list.
  The `next` fields of the resulting loggers are removed.

  ## Examples

  ```elixir
  iex> logger0 = Logi.new
  iex> logger1 = Logi.new([next: logger0])
  iex> logger2 = Logi.new([next: logger1])
  iex> [^logger0] = Logi.to_list(logger0)
  iex> [^logger0, ^logger0] = Logi.to_list(logger1)
  iex> [^logger0, ^logger0, ^logger0] = Logi.to_list(logger2)
  ```
  """
  @spec to_list(logger) :: [logger_instance]
  def to_list(logger) do
    :logi.to_list logger
  end

  @doc """
  Aggregates `loggers` into a logger instance.

  The head logger in `loggers` becomes the root of the aggregation.
  e.g. `from_list([new, new, new])` is equivalent to `new([next: new([next: new])])`.
  """
  @spec from_list([logger]) :: logger_instance
  def from_list(loggers) do
    :logi.from_list loggers
  end

  @doc """
  Equivalent to `Logi.save(Logi.default_logger, logger)`.
  """
  @spec save_as_default(logger) :: logger_instance | :undefined
  def save_as_default(logger) do
    :logi.save_as_default logger
  end


  @doc """
  Saves `logger` with the ID `logger_id` to the process dictionary.

  If `logger_id` already exists, the old logger instance is deleted and replaced by `logger`
  and the function returns the old instance.
  Otherwise it returns `:undefined`.

  In the process, a saved logger instance can be referred by the ID.

  ## Examples

  ```elixir
  iex> require Logi

  iex> logger = Logi.new
  iex> Logi.save :sample_log, logger

  # The following two expression is equivalent.
  iex> Logi.info "hello world", [], [logger: logger]  # referred by instance
  iex> Logi.info "hello world", [], [logger: :sample_log] # referred by ID
  ```
  """
  @spec save(logger_id, logger) :: logger_instance | :undefined
  def save(logger_id, logger) do
    :logi.save logger_id, logger
  end

  @doc """
  Equivalent to `Logi.load(Logi.default_logger)`.
  """
  @spec load_default :: {:ok, logger_instance} | :error
  def load_default do
    :logi.load_default
  end

  @doc """
  Loads a logger which associated with the ID `logger_id` from the process dictionary.

  ## Examples

  ```elixir
  iex> :error = Logi.load :foo_log

  iex> Logi.save :foo_log, Logi.new
  iex> {:ok, _} = Logi.load :foo_log
  ```
  """
  @spec load(logger_id) :: {:ok, logger_instance} | :error
  def load(logger_id) do
    :logi.load logger_id
  end

  @doc """
  Returns the logger instance associated to `logger`.

  ## Examples

  ```elixir
  iex> Logi.ensure_to_be_instance :unsaved
  {:logi_logger, :unsaved, %{}, %{}, :undefined, :undefined}

  iex> Logi.save :saved, Logi.new([channel: :foo])
  iex> Logi.ensure_to_be_instance :foo
  {:logi_logger, :foo, %{}, %{}, :undefined, :undefined}

  iex> Logi.ensure_to_be_instance Logi.new([channel: :bar])
  {:logi_logger, :bar, %{}, %{}, :undefined, :undefined}
  ```
  """
  @spec ensure_to_be_instance(logger) :: logger_instance
  def ensure_to_be_instance(logger) do
    :logi.ensure_to_be_instance logger
  end

  @doc """
  Returns the saved loggers and deletes them from the process dictionary.

  ## Examples

  ```elixir
  iex> Logi.save :foo, Logi.new

  iex> Logi.erase
  [foo: {:logi_logger, :logi_default_log, %{}, %{}, :undefined, :undefined}]

  iex> Logi.erase
  []
  ```
  """
  @spec erase :: [{logger_id, logger_instance}]
  def erase do
    :logi.erase
  end

  @doc """
  Returns the logger associated with `logger_id` and deletes it from the process dictionary.

  Returns `:undefined` if no logger is associated with `logger_id`.

  ## Examples

  ```elixir
  iex> Logi.save :foo, Logi.new
  iex> Logi.erase :foo
  {:logi_logger, :logi_default_log, %{}, %{}, :undefined, :undefined}

  iex> Logi.erase :foo
  :undefined
  ```
  """
  @spec erase(logger_id) :: logger_instance | :undefined
  def erase(logger_id) do
    :logi.erase logger_id
  end

  @doc """
  Returns the ID list of the saved loggers.

  ## Examples

  ```elixir
  iex> Logi.save :foo, Logi.new
  iex> Logi.which_loggers
  [:foo]
  ```
  """
  @spec which_loggers :: [logger_id]
  def which_loggers do
    :logi.which_loggers
  end

  @doc """
  Sets headers of the logger.

  If the logger has nested loggers, the function is applied to them recursively.

  ## Options

  ### logger
  - The logger to which the operation applies.
  - Default: `Logi.default_logger`

  ### if_exists
  - If the value is `:supersede`, the existing headers are deleted and replaced by `headers`.
  - If the value is `:overwrite`, the existing headers and `headers` are merged and the rear has priority when a key collision occurs.
  - If the value is `:ignore`, the existing headers and `headers` are merged and the former has priority when a key collision occurs.
  - Default: `:overwrite`

  ## Examples

  ```elixir
  iex> logger = Logi.new([headers: %{:a => 10, :b => 20}])
  iex> set = fn (hs, ie) -> l = Logi.set_headers(hs, [logger: logger, if_exists: ie]); Logi.to_map(l)[:headers] end

  iex> true = %{:a => 0,            :c => 30} == set.(%{:a => 0, :c => 30}, :supersede)
  iex> true = %{:a => 0,  :b => 20, :c => 30} == set.(%{:a => 0, :c => 30}, :overwrite)
  iex> true = %{:a => 10, :b => 20, :c => 30} == set.(%{:a => 0, :c => 30}, :ignore)
  ```
  """
  @spec set_headers(headers, options) :: logger_instance when
  options: [
    {:logger, logger} |
    {:if_exists, :ignore | :overwrite | :supersede}
  ]
  def set_headers(headers, options \\ []) do
    :logi.set_headers headers, options
  end

  @doc """
  Sets metadata of the logger.

  If the logger has nested loggers, the function is applied to them recursively.

  ## Options

  See documentation for `set_headers/2`.
  """
  @spec set_metadata(metadata, options) :: logger_instance when
  options: [
    {:logger, logger} |
    {:if_exists, :ignore | :overwrite | :supersede}
  ]
  def set_metadata(metadata, options \\ []) do
    :logi.set_metadata metadata, options
  end

  @doc """
  Deletes headers which associated with `keys`.

  If the logger has nested loggers, the function is applied to them recursively.

  ## Examples

  ```elixir
  iex> logger = Logi.new [headers: %{:a => 1, :b => 2}]
  iex> Logi.to_map Logi.delete_headers([:a], [logger: logger])
  %{channel: :logi_default_log, headers: %{b: 2}, metadata: %{}}
  ```
  """
  @spec delete_headers([any], options) :: logger_instance when options: [{:logger, logger}]
  def delete_headers(keys, options \\ []) do
    :logi.delete_headers keys, options
  end

  @doc """
  Deletes metadata which associated with `keys`.

  If the logger has nested loggers, the function is applied to them recursively.

  ## Examples

  ```elixir
  iex> logger = Logi.new [metadata: %{:a => 1, :b => 2}]
  iex> Logi.to_map Logi.delete_metadata([:a], [logger: logger])
  %{channel: :logi_default_log, metadata: %{b: 2}, metadata: %{}}
  ```
  """
  @spec delete_metadata([any], options) :: logger_instance when options: [{:logger, logger}]
  def delete_metadata(keys, options \\ []) do
    :logi.delete_metadata keys, options
  end

  @doc """
  Issues a log message to the destination channel.

  If the logger has a filter, the message will be passed to it.
  And if the message has not been discarded by a filter,
  the logger will (logically) send it to the destination channel.
  Finally, the message will be consumed by the sinks which are installed to the channel.
  But the sinks which does not satisfy specified condition are ignored.

  ```elixir
  iex> require Logi

  # Installs a sink to the default channel
  iex> {:ok, _} = Logi.Channel.install_sink(Logi.BuiltIn.Sink.IoDevice.new(:sample), :info)

  iex> Logi.log :debug, "hello world", [], []  # There are no applicable sinks (the severity is too low)
  iex> Logi.log :info, "hello world", [], []   # The log message is consumed by the above sink
  #OUTPUT# 2016-12-04 23:04:17.028 [info] nonode@nohost <0.150.0> nil:nil:19 [] hello world
  :ok
  ```

  If the logger has nested loggers, the function is applied to them recursively.
  ```elixir
  # Installs a sink to the default channel
  iex> {:ok, _} = Logi.Channel.install_sink(Logi.BuiltIn.Sink.IoDevice.new(:sample), :info)
  iex> logger = Logi.from_list([Logi.new([headers: %{:id => :foo}]), Logi.new([headers: %{:id => :bar}])])
  iex> Logi.log :info, "hello world", [], [logger: logger]
  #OUTPUT# 2016-12-04 23:08:51.778 [info] nonode@nohost <0.150.0> nil:nil:24 [id=foo] hello world
  #OUTPUT# 2016-12-04 23:08:51.778 [info] nonode@nohost <0.150.0> nil:nil:24 [id=bar] hello world
  :ok
  ```
  """
  @spec log(severity, :io.format, [any], log_options) :: logger_instance
  defmacro log(severity, format, data \\ [], options \\ []) do
    quote do
      require Logi.Location
      case :logi._ready(unquote(severity), Logi.Location.current_location, unquote(options)) do
        {logger, []} -> logger
        {logger, sinks} -> :logi._write(sinks, unquote(format), unquote(data))
      end
    end
  end

  @doc "Equivalent to `Logi.log :debug, format, data, options`."
  @spec debug(:io.format, [any], log_options) :: logger_instance
  defmacro debug(format, data \\ [], options \\ []) do
    quote do: Logi.log :debug, unquote(format), unquote(data), unquote(options)
  end

  @doc "Equivalent to `Logi.log :info, format, data, options`."
  @spec info(:io.format, [any], log_options) :: logger_instance
  defmacro info(format, data \\ [], options \\ []) do
    quote do: Logi.log :info, unquote(format), unquote(data), unquote(options)
  end

  @doc "Equivalent to `Logi.log :notice, format, data, options`."
  @spec notice(:io.format, [any], log_options) :: logger_instance
  defmacro notice(format, data \\ [], options \\ []) do
    quote do: Logi.log :notice, unquote(format), unquote(data), unquote(options)
  end

  @doc "Equivalent to `Logi.log :warning, format, data, options`."
  @spec warning(:io.format, [any], log_options) :: logger_instance
  defmacro warning(format, data \\ [], options \\ []) do
    quote do: Logi.log :warning, unquote(format), unquote(data), unquote(options)
  end

  @doc "Equivalent to `Logi.log :error, format, data, options`."
  @spec error(:io.format, [any], log_options) :: logger_instance
  defmacro error(format, data \\ [], options \\ []) do
    quote do: Logi.log :error, unquote(format), unquote(data), unquote(options)
  end

  @doc "Equivalent to `Logi.log :critical, format, data, options`."
  @spec critical(:io.format, [any], log_options) :: logger_instance
  defmacro critical(format, data \\ [], options \\ []) do
    quote do: Logi.log :critical, unquote(format), unquote(data), unquote(options)
  end

  @doc "Equivalent to `Logi.log :alert, format, data, options`."
  @spec alert(:io.format, [any], log_options) :: logger_instance
  defmacro alert(format, data \\ [], options \\ []) do
    quote do: Logi.log :alert, unquote(format), unquote(data), unquote(options)
  end

  @doc "Equivalent to `Logi.log :emergency, format, data, options`."
  @spec emergency(:io.format, [any], log_options) :: logger_instance
  defmacro emergency(format, data \\ [], options \\ []) do
    quote do: Logi.log :emergency, unquote(format), unquote(data), unquote(options)
  end
end
