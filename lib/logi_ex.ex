defmodule Logi do
  defmacro current_location do
    quote do
      :logi_location.unsafe_new(
        self,
        unquote(Application.get_application(__CALLER__.module)),
        unquote(__CALLER__.module),
        unquote(case __CALLER__.function do
          {f, _} -> f
          _ -> nil
        end),
        unquote(__CALLER__.line))
    end
  end

  defmacro log(severity, format, data \\ [], options \\ []) do
    quote do
      case :logi._ready(unquote(severity), Logi.current_location, unquote(options)) do
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

  def set_headers(headers, options \\ []) do
    :logi.set_headers headers, options
  end
end

defmodule Logi.Channel do
  def default_channel do
    :logi_channel.default_channel
  end

  def which_channels do
    :logi_channel.which_channels
  end

  def which_sinks(channel \\ LogiChannel.default_channel) do
    :logi_channel.which_sinks channel
  end

  def install_sink(sink, condition) do
    :logi_channel.install_sink sink, condition
  end

  def install_sink(channel, sink, condition) do
    :logi_channel.install_sink channel, sink, condition
  end
end

defmodule Logi.BuiltIn.Sink.IoDevice do
  def new(id, options \\ []) do
    :logi_builtin_sink_io_device.new id, options
  end
end
