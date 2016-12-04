defmodule Logi do
  defmacro log(severity, format, data \\ [], options \\ []) do
    quote do
      require Logi.Location
      case :logi._ready(unquote(severity), Logi.Location.current_location, unquote(options)) do
        {logger, []} -> logger
        {logger, sinks} -> :logi._write(sinks, unquote(format), unquote(data))
      end
    end
  end

  defmacro debug(format, data \\ [], options \\ []) do
    quote do: Logi.log :debug, unquote(format), unquote(data), unquote(options)
  end

  defmacro info(format, data \\ [], options \\ []) do
    quote do: Logi.log :info, unquote(format), unquote(data), unquote(options)
  end

  defmacro notice(format, data \\ [], options \\ []) do
    quote do: Logi.log :notice, unquote(format), unquote(data), unquote(options)
  end

  defmacro warning(format, data \\ [], options \\ []) do
    quote do: Logi.log :warning, unquote(format), unquote(data), unquote(options)
  end

  defmacro error(format, data \\ [], options \\ []) do
    quote do: Logi.log :error, unquote(format), unquote(data), unquote(options)
  end

  defmacro critical(format, data \\ [], options \\ []) do
    quote do: Logi.log :critical, unquote(format), unquote(data), unquote(options)
  end

  defmacro alert(format, data \\ [], options \\ []) do
    quote do: Logi.log :alert, unquote(format), unquote(data), unquote(options)
  end

  defmacro emergency(format, data \\ [], options \\ []) do
    quote do: Logi.log :emergency, unquote(format), unquote(data), unquote(options)
  end

  def default_logger() do
    :logi.default_logger
  end

  def set_headers(headers, options \\ []) do
    :logi.set_headers headers, options
  end
  def delete_headers(keys, options \\ []) do
    :logi.delete_headers keys, options
  end

  def set_metadata(metadata, options \\ []) do
    :logi.set_metadata metadata, options
  end

  def delete_metadata(keys, options \\ []) do
    :logi.delete_metadata keys, options
  end

  def ensure_to_be_instance(logger) do
    :logi.ensure_to_be_instance logger
  end

  def erase(logger_id \\ Logi.default_logger) do
    :logi.erase logger_id
  end

  def from_list(loggers) do
    :logi.from_list loggers
  end

  def to_list(logger) do
    :logi.to_list logger
  end

  def from_map(map) do
    :logi.from_map map
  end

  def to_map(logger) do
    :logi.to_map logger
  end

  def is_logger(x) do
    :logi.is_logger x
  end

  def is_severity(x) do
    :logi.is_severity x
  end

  def severities() do
    :logi.severities
  end

  def severity_level(severity) do
    :logi.severity_level severity
  end

  def which_loggers() do
    :logi.which_loggers
  end

  def load(logger_id) do
    :logi.load logger_id
  end

  def load_default() do
    :logi.load_default
  end

  def save(logger_id, logger) do
    :logi.save logger_id, logger
  end

  def save_as_default(logger) do
    :logi.save_as_default logger
  end

  def new(options \\ []) do
    :logi.new options
  end
end
