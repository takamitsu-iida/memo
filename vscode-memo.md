
# visual studio code

[//]:# ( visual studio code / vs code / vscode )

Visual Studio Codeの設定メモ。


## 拡張機能（各言語共通）

- Auto-Open Markdown preview
- beautify
- final-newline
- Toggle Proxy

## 拡張機能（JavaScript）

- ESLint


## 拡張機能（Python）

- Python


## 拡張機能（なくてもいいかも）

- Angular Material snippets
- Angular UI Bootstrap Snippets
- Jasmine code snippets


## 頻繁に使うキー

- ctrl-shift-p コマンド入力
- ctrl-@ コマンドプロンプト
- ctrl-b サイドメニューを表示する、隠す


## 基本設定

ファイル→基本設定→ユーザ設定


```js

// 既定の設定を上書きするには、このファイル内に設定を挿入します
{
  // HTTP 構成
  // 使用するプロキシ設定。設定されていない場合、環境変数 http_proxy および https_proxy から取得されます。
  // "http.proxy": "http://username:passowrd@proxy-addr:8080",
  "http.proxy": "",

  // 提供された CA の一覧と照らしてプロキシ サーバーの証明書を確認するかどうか。
  "http.proxyStrictSSL": false,

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
  "python.linting.pylintEnabled": true,
  "python.formatting.provider": "yapf",
  "python.formatting.yapfPath": "yapf",
  "python.formatting.yapfArgs": [
    "--style={based_on_style: chromium, indent_width: 2, continuation_indent_width: 4, column_limit: 120}"
  ],

  // typescript
  "typescript.check.tscVersion": false
}
```
