(setq preferences-directory "~/.emacs.d/")
 
(defun load-file-in-dir (dir file)
  (load (concat dir file)))
 
(cond
 ((string-match "^22\." emacs-version)
  (load-file-in-dir preferences-directory "init22.el"))
 ((string-match "^24\." emacs-version)
  (load-file-in-dir preferences-directory "init24.el"))
 ((string-match "^26\." emacs-version)
  (load-file-in-dir preferences-directory "init26.el"))
 )
