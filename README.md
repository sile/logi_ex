logi_ex
=======

[![hex.pm version](https://img.shields.io/hexpm/v/logi_ex.svg)](https://hex.pm/packages/logi_ex)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

This is a wrapper library of [logi](https://github.com/sile/logi).

`logi` is a logger interface library for Erlang/OTP.

[Documentation](https://hexdocs.pm/logi_ex/api-reference.html)

Installation
------------

Add following lines to your `mix.exs`:

```elixir
def deps do
  [{:logi_ex, "~> 0.5"}]
end
```

Next, add this to your application file:

``` elixir
def application do
  [applications: [:logi_ex]]
end
```

Usage Examples
--------------

``` elixir
# Enables macros
iex> require Logi

# Installs a sink
iex> sink = Logi.BuiltIn.Sink.IoDevice.new :foo
iex> Logi.Channel.install_sink sink, :info

# Outputs a log message
iex> Logi.info "hello ~p", [:world]
```
