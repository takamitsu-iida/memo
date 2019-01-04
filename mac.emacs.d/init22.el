;;;  -*- emacs-lisp -*-

;;  http://macemacsjp.sourceforge.jp/matsuan/FontSettingJp.html
(if (eq window-system 'mac) (require 'carbon-font))
 (if window-system (progn
 (fixed-width-set-fontset "hirakaku_w3" 12)))
; 他にこんなフォントが使える 
; "hiramaru" "hirakaku_w3" "hirakaku_w6" "hirakaku_w8" "hiramin_w3" "hiramin_w6" "osaka"
; 7, 8, 9, 10, 12, 14, 16, 18, 20, 24

(if (string= default-directory "/") (cd "~/"))
(if (featurep 'carbon-emacs-package) (tool-bar-mode nil))


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

; keisen-mule
(unless (fboundp 'sref) (defalias 'sref 'aref))
(autoload 'keisen-mode "keisen-mule" "MULE版罫線モード" t)

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

;; --------- Window system ---------

(global-font-lock-mode t)  ; always turn on syntax highlighting (e21)

(if window-system (progn

;; default color
(add-to-list 'default-frame-alist '(cursor-color . "SlateBlue2"))
(add-to-list 'default-frame-alist '(mouse-color . "SlateBlue2"))
(add-to-list 'default-frame-alist '(foreground-color . "gray10"))
(add-to-list 'default-frame-alist '(background-color . "white"))
(set-face-foreground 'modeline "white")
(set-face-background 'modeline "SlateBlue2")
(set-face-background 'region  "LightSteelBlue1")

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

;; pc-selection-mode
(if (>= emacs-major-version 22)
    (progn
      (setq pc-select-selection-keys-only t)
      (pc-selection-mode 1)
      )
  (transient-mark-mode 1)
  )

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
