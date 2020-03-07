;;  -*- emacs-lisp -*-

;; 参照
;; https://www.muskmelon.jp/?page_id=410

(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)

(setq default-file-name-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))

(set-default-coding-systems 'utf-8-unix)    ; UTF-8 が基本
(set-terminal-coding-system 'utf-8-unix)    ; emacs -nw も文字化けしない

;; 初期状態
(if (string= default-directory "/") (cd "~/"))

;; basic setup
(setq load-path (cons "~/e-lisp" load-path))
(setq nextline-add-newlines nil)
(setq inhibit-startup-message t)        ; don't show the startup message
(setq kill-whole-line t)                ; C-k deletes the end of line
(setq make-backup-files nil)            ; don't make *~
(setq auto-save-list-file-prefix nil)   ; don't make ~/.saves-PID-hostname
(setq auto-save-default nil)            ; disable auto-saving
(column-number-mode 1)

;; 日本語入力
(require 'mozc)
(setq default-input-method "japanese-mozc")

;; keys
(global-set-key "\C-z" 'undo)
(global-set-key "\C-x\C-b" 'electric-buffer-list)
(global-set-key "\C-c\C-i" 'indent-region) ; C-u C-c TAB => (un)indent-region
(global-set-key "\C-c;" 'comment-or-uncomment-region)
(global-set-key "\C-ck" (lambda ()(interactive)(kill-line 0)))
(global-set-key "\C-cu" 'untabify)
(global-set-key "\C-o" 'toggle-input-method)
(global-set-key "\C-h" 'delete-backward-char)

;; Meta キーを左Command キーに割り当てる
(when (eq system-type 'darwin)
  (setq ns-command-modifier (quote meta)))

;; 純正のemacsをMACで使うとGoogle日本語入力が使えない
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>")) ; 日本語変換中のC-h

;; nn = ん
(setq quail-japanese-use-double-n t)

;; keisen-mule
(unless (fboundp 'sref) (defalias 'sref 'aref))
(autoload 'keisen-mode "keisen-mule" "MULE版罫線モード" t)

;; toolbarを消す
(tool-bar-mode 0)

;; always turn on syntax highlighting (e21)
(global-font-lock-mode t)

;; yaml-mode.el
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

;; ミニバッファに入力時、自動的に英語モード
(when (functionp 'mac-auto-ascii-mode)
  (mac-auto-ascii-mode 1))

;; 英語font
; (set-face-attribute 'default nil
;   :family "Menlo" ;; font
;   :height 140)    ;; font size

;; 日本語font
;(set-fontset-font
;  nil 'japanese-jisx0208
;  ;; (font-spec :family "Hiragino Mincho Pro")) ;; font
;  (font-spec :family "Hiragino Kaku Gothic ProN")) ;; font

;; 半角と全角の比を1:2にしたければ
;(setq face-font-rescale-alist
;  ;; '((".*Hiragino_Mincho_pro.*" . 1.2)))
;  '((".*Hiragino_Kaku_Gothic_ProN.*" . 1.2)));; Mac用フォント設定

;; フォントの設定
;; 出典：http://sakito.jp/emacs/emacs23.html

(if window-system (progn

  (create-fontset-from-ascii-font "Menlo-14:weight=normal:slant=normal" nil "menlokakugo")
  (set-fontset-font "fontset-menlokakugo"
		    'unicode
		    (font-spec :family "Hiragino Kaku Gothic ProN" :size 14)
		    nil
		    'append)
  (add-to-list 'default-frame-alist '(font . "fontset-menlokakugo"))

  ;; default color
  (add-to-list 'default-frame-alist '(cursor-color . "SlateBlue2"))
  (add-to-list 'default-frame-alist '(mouse-color . "SlateBlue2"))
  (add-to-list 'default-frame-alist '(foreground-color . "gray10"))
  (add-to-list 'default-frame-alist '(background-color . "white"))
  ;(set-face-foreground 'modeline "white")
  ;(set-face-background 'modeline "SlateBlue2")
  ;(set-face-background 'region  "LightSteelBlue1")

  ;; size
  (setq initial-frame-alist '((width . 120) (height . 45)))

  ;; faces
  (set-face-foreground 'font-lock-comment-face "MediumSeaGreen")
  (set-face-foreground 'font-lock-string-face  "purple")
  (set-face-foreground 'font-lock-keyword-face "blue")
  (set-face-foreground 'font-lock-function-name-face "blue")
  (set-face-foreground 'font-lock-variable-name-face "black")
  (set-face-foreground 'font-lock-type-face "LightSeaGreen")
  (set-face-foreground 'font-lock-builtin-face "purple")
  (set-face-foreground 'font-lock-constant-face "black")
  (set-face-foreground 'font-lock-warning-face "blue")
  (set-face-bold-p 'font-lock-function-name-face t)
  (set-face-bold-p 'font-lock-warning-face nil)

  ;; scroll bar
  (set-scroll-bar-mode 'right)

  ;; additional menu
  (require 'easymenu)
  (setq my-encoding-map (make-sparse-keymap "Encoding Menu"))
  (easy-menu-define my-encoding-menu my-encoding-map
    "Encoding Menu."
    '("Change File Encoding"
      ["UTF8 - Unix (LF)" (set-buffer-file-coding-system 'utf-8-unix) t]
      ["UTF8 - Mac (CR)" (set-buffer-file-coding-system 'utf-8-mac) t]
      ["UTF8 - Win (CR+LF)" (set-buffer-file-coding-system 'utf-8-dos) t]
      ["--" nil nil]
      ["Shift JIS - Mac (CR)" (set-buffer-file-coding-system 'sjis-mac) t]
      ["Shift JIS - Win (CR+LF)" (set-buffer-file-coding-system 'sjis-dos) t]
      ["--" nil nil]
      ["EUC - Unix (LF)"  (set-buffer-file-coding-system 'euc-jp-unix) t]
      ["JIS - Unix (LF)"  (set-buffer-file-coding-system 'junet-unix) t]
      ))
  (define-key-after menu-bar-file-menu [my-file-separator]
    '("--" . nil) 'kill-buffer)
  (define-key-after menu-bar-file-menu [my-encoding-menu]
    (cons "File Encoding" my-encoding-menu) 'my-file-separator)
))
