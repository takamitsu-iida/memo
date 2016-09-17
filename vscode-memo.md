
# visual studio code

[//]:# ( visual studio code / vs code / vscode )

## 利用している拡張機能

- Angular Material Snippets 0.3.1
- ESLint 1.0.5
- Python 0.3.24
- Angular UI Bootstrap Snippets 4.0.6
- Auto-Open Markdown preview 0.0.3
- beautify 0.1.10
- Partial Diff 0.1.0
- final-newline 0.2.0
- Toggle Proxy 0.2.0
- Jasmine code snippets 0.2.0


# よく使うキー

- ctrl-shift-p コマンド入力
- ctrl-@ コマンドプロンプト
- ctrl-b サイドメニューの表示を消す


# 基本設定

```js

// 既定の設定を上書きするには、このファイル内に設定を挿入します
{

  // HTTP 構成
  // 使用するプロキシ設定。設定されていない場合、環境変数 http_proxy および https_proxy から取得されます。
  "http.proxy": "", // "http://username:password@proxy-server:8080",

  // 提供された CA の一覧と照らしてプロキシ サーバーの証明書を確認するかどうか。
  "http.proxyStrictSSL": false,

  // エディターで空白文字を表示するかどうかを制御します
  "editor.renderWhitespace": true,

  // タブ 1 つに相当するスペースの数。
  "editor.tabSize": 2,

  // ファイルを開くと、そのファイルの内容に基づいて `editor.tabSize` と `editor.insertSpaces` が検出されます。
  "editor.detectIndentation": false,

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

  "python.linter": "flake8"

}
```
