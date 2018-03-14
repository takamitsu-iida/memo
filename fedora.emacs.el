; ロードパス
(add-to-list 'load-path "/usr/share/emacs/25.3/lisp/")
(add-to-list 'load-path "~/e-lisp/")

; 日本語環境設定
(prefer-coding-system 'utf-8)
(require 'mozc)
(setq default-input-method "japanese-mozc")
(global-set-key "\C-o" 'toggle-input-method)

; nn ん
(setq quail-japanese-use-double-n t)



; C-hでヘルプ表示するのを抑止
(keyboard-translate ?\C-h ?\C-?)
(global-set-key "\C-h" nil)

; C-nで改行しない
(setq next-line-add-newlines nil)

; ツールバーを表示しない
(tool-bar-mode 0)

; オートセーブは抑止する
(auto-save-mode nil)

; バックアップファイルは作成する
(setq backup-inhibited t)

; リージョン指定を色つきにする
(transient-mark-mode 1)

; buffer list
(load-library "ebuff-menu")
(global-set-key "\C-x\C-b" 'electric-buffer-list)

; calc-mode
(autoload 'calc-mode "calc-mode" "calculator in Emacs" t)

; ミニバッファ拡大禁止
(setq resize-mini-windows nil)


;
; ホワイトスペースの可視化
(require 'whitespace)
(global-whitespace-mode t)
(setq whitespace-style
      '(tabs tab-mark spaces space-mark))
(setq whitespace-space-regexp "\\(\x3000+\\)")
(setq whitespace-display-mappings
      '((space-mark ?\x3000 [?\□])
        (tab-mark   ?\t   [?\xBB ?\t])
        ))
(set-face-foreground 'whitespace-space "LightSlateGray")
(set-face-background 'whitespace-space "DarkSlateGray")
(set-face-foreground 'whitespace-tab "LightSlateGray")
(set-face-background 'whitespace-tab "DarkSlateGray")
