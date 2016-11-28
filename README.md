logi_ex
=======

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

[logi](https://github.com/sile/logi)のElixirラッパー

インストール
------------

`mix.exs`に以下を追加:

```elixir
def deps do
  [{:logi_ex, git: "https://github.com/sile/logi_ex.git"}]
end
```

アプリケーションファイルに以下を追加:

``` elixir
def application do
  [applications: [:logi_ex]]
end
```

使用例
------

``` elixir
# マクロを有効にする
require Logi

Logi.info "hello ~p", [:world]
```
