;;;  -*- emacs-lisp -*-

(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)

;; �Ť�����
;; ���������ư���ʤ�
;; http://macemacsjp.sourceforge.jp/matsuan/FontSettingJp.html
;(if (eq window-system 'mac) (require 'carbon-font))
; (if window-system (progn
; (fixed-width-set-fontset "hirakaku_w3" 12)))
; ¾�ˤ���ʥե���Ȥ��Ȥ��� 
; "hiramaru" "hirakaku_w3" "hirakaku_w6" "hirakaku_w8" "hiramin_w3" "hiramin_w6" "osaka"
; 7, 8, 9, 10, 12, 14, 16, 18, 20, 24

;; 2017/10 Emacs25�����ܸ����Ϥ����������äƻȤ��ʤ�
;; railwaycat�Ǥ�emacs�ϥ���饤��Ǥ�IMEư��Ǥ��ʤ�
;; https://qiita.com/makky_tyuyan/items/d692e1fe2aeba979bc11
;; https://github.com/railwaycat/homebrew-emacsmacport

;; MacEmacs JP Emacs24-with-inline-patch �Х��ʥ������
;; Emacs24����������
(setq default-input-method "MacOSX")
(mac-set-input-method-parameter "com.google.inputmethod.Japanese.base" `title "��")

;; �Ѹ�font
(set-face-attribute 'default nil
  :family "Menlo" ;; font
  :height 140)    ;; font size

;; ���ܸ�font
(set-fontset-font
  nil 'japanese-jisx0208
  ;; (font-spec :family "Hiragino Mincho Pro")) ;; font
  (font-spec :family "Hiragino Kaku Gothic ProN")) ;; font

;; Ⱦ�Ѥ����Ѥ����1:2�ˤ��������
(setq face-font-rescale-alist
  ;; '((".*Hiragino_Mincho_pro.*" . 1.2)))
  '((".*Hiragino_Kaku_Gothic_ProN.*" . 1.2)));; Mac�ѥե��������

;; �������
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

;; keys
(global-set-key "\C-z" 'undo)
(global-set-key "\C-x\C-b" 'electric-buffer-list)
(global-set-key "\C-c\C-i" 'indent-region) ; C-u C-c TAB => (un)indent-region
(global-set-key "\C-c;" 'comment-or-uncomment-region)
(global-set-key "\C-ck" (lambda ()(interactive)(kill-line 0)))
(global-set-key "\C-cu" 'untabify)
(global-set-key "\C-o" 'toggle-input-method)
(global-set-key "\C-h" 'delete-backward-char)

;; ������emacs��MAC�ǻȤ���Google���ܸ����Ϥ��Ȥ��ʤ�
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>")) ; ���ܸ��Ѵ����C-h

;; nn = ��
(setq quail-japanese-use-double-n t)

;; keisen-mule
(unless (fboundp 'sref) (defalias 'sref 'aref))
(autoload 'keisen-mode "keisen-mule" "MULE�Ƿ����⡼��" t)

;; delete file if empty
;; ref. http://www.bookshelf.jp/cgi-bin/goto.cgi?file=meadow&node=delete%20nocontents
(add-hook 'after-save-hook 'delete-file-if-no-contents t)
(defun delete-file-if-no-contents ()
  (when (and buffer-file-name (= (point-min) (point-max)))
    (if (y-or-n-p "Delete file and kill buffer? ")
      (let ((filename buffer-file-name))
        (delete-file filename)
        (kill-buffer (current-buffer))
        (message (concat "Deleted " (file-name-nondirectory filename)))
        ))))

;; toolbar��ä�
(tool-bar-mode 0)

(global-font-lock-mode t)  ; always turn on syntax highlighting (e21)

(if window-system (progn
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
  (set-face-bold-p 'font-lock-function-name-face t)
  (set-face-foreground 'font-lock-variable-name-face "black")
  (set-face-foreground 'font-lock-type-face "LightSeaGreen")
  (set-face-foreground 'font-lock-builtin-face "purple")
  (set-face-foreground 'font-lock-constant-face "black")
  (set-face-foreground 'font-lock-warning-face "blue")
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


; yaml-mode.el
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))
