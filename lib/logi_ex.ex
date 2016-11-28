defmodule Logi do
  defmacro current_location do
    {{:., [], [:logi_location, :unsafe_new]}, [],
     [(quote do: self), Application.get_application(__CALLER__.module), __CALLER__.module,
      case __CALLER__.function do
        {f, _} -> f
        _ -> nil
      end,
      __CALLER__.line]}
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
end
