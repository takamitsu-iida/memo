
# visual studio code

[//]:# ( visual studio code / vs code / vscode )

Visual Studio Codeの設定メモ。

## 拡張機能（各言語共通）

使わなくなったもの

- Auto-Open Markdown preview
- beautify
- Toggle Proxy

使っているもの

- Japanese Language Pack
- Remove backspace control character
- Prettier - Code Formatter
- final-newline
- Excel Viewer

## 拡張機能（JavaScript）

- ESLint

## 拡張機能（Python）

- Python
- Jinja
- autoDocstring

## 拡張機能（YAML）

- YAML

## 拡張機能（なくてもいいかも）

- Angular Material snippets
- Angular UI Bootstrap Snippets
- Jasmine code snippets

## 頻繁に使うキー

- ctrl-shift-p コマンド入力
- ctrl-@ コマンドプロンプト
- ctrl-b サイドメニューを表示する、隠す

<BR>

## メニューの日本語化

バージョンアップでメニュー表示を英語に戻されることがあるので、手動で日本語に変える。

1. Ctrl+Shift+P でコマンドパレットを開く
1. Configure Languageでlocale.jsonを開く
1. localeをjaに設定する
1. 再起動する

```js
{
    // VSCode の表示言語を定義します。
    // サポートされている言語の一覧については、https://go.microsoft.com/fwlink/?LinkId=761051 をご覧ください。
    // VSCode の再起動に必要な値を変更します。
    "locale":"ja"
}
```

<BR>

## 基本設定

ファイル→基本設定→設定

```js
// 既定の設定を上書きするには、このファイル内に設定を挿入します
{
  // HTTP 構成
  // 使用するプロキシ設定。設定されていない場合、環境変数 http_proxy および https_proxy から取得されます。
  // "http.proxy": "http://username:passowrd@proxy-addr:8080",
  "http.proxy": "",

  // 提供された CA の一覧と照らしてプロキシ サーバーの証明書を確認するかどうか。
  "http.proxyStrictSSL": false,

  // ミニマップを表示するかどうかを制御します
  "editor.minimap.enabled": false,

  // エディターで空白文字を表示するかどうかを制御します
  "editor.renderWhitespace": "boundary",

  // タブ 1 つに相当するスペースの数。
  "editor.tabSize": 2,

  // ファイルを開くと、そのファイルの内容に基づいて `editor.tabSize` と `editor.insertSpaces` が検出されます。
  "editor.detectIndentation": true,

  // エディターで最後の行を越えてスクロールするかどうかを制御します
  "editor.scrollBeyondLastLine": false,

  // Controls whether the editor should render indent guides
  "editor.renderIndentGuides": true,

  // エディターで制御文字を表示する必要があるかどうかを制御します
  "editor.renderControlCharacters": true,

  // 有効にすると、ファイルの保存時に末尾の空白をトリミングします。
  "files.trimTrailingWhitespace": true,

  // マウス ホイール スクロール イベントの `deltaX` と `deltaY` で使用される乗数
  "editor.mouseWheelScrollSensitivity": 2,

  // 拡張機能 final-newline
  "files.insertFinalNewline": true,

  // JavaScript の検証を有効/無効にします
  "javascript.validate.enable": false,

  "eslint.enable": true,

  "eslint.options": {
    "rules": {
      "quotes": [
        2,
        "single"
      ],
       "linebreak-style": [
        2,
        "unix"
      ],
      "semi": [
        2,
        "always"
      ],
      "no-console": 0
    },
    "env": {
      "es6": true,
      "browser": true
    },
    "extends": "eslint:recommended"
  },

  // python
  "python.pythonPath": "${env:PYENV_ROOT}/shims/python",
  "python.linting.pylintEnabled": true,
  "python.linting.pylintPath": "${env:PYENV_ROOT}/shims/pylint",
  "python.linting.lintOnSave": true,
  "python.formatting.provider": "yapf",
  "python.formatting.yapfPath": "${env:PYENV_ROOT}/shims/yapf",
  "python.formatting.yapfArgs": [
      "--style={based_on_style: chromium, indent_width: 2, continuation_indent_width: 4, column_limit: 120}"
  ],

  // typescript
  "typescript.check.tscVersion": false
}

  // markdownlint
  "markdownlint.config": {
    "default": true,
    "no-hard-tabs": false,
    "MD003": false,
    "MD007": { "indent": 2 },
    "MD013": false,
    "MD025": false,
    "MD033": false
  }

  // YAML
  "[yaml]": {
      "editor.tabSize": 2,
      "editor.detectIndentation": false
  }

```

- 2017/06/11 -- バージョンアップで追加されたminimap機能が邪魔なのでfalseにするよう変更。
- 2018/02/24 -- VSCodeが参照するpythonのパスを明示的に設定。
- 2018/07/01 -- 1行目を#!/usr/bin/pythonで始めるとそれがVSCodeで利用されてしまうので、明示的にパスを追加
- 2018/07/15 -- markdownlint用の設定を追加
- 2019/01/04 -- yaml用の設定を追加
