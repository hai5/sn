
(global-set-key (kbd "C-M-<tab>") #'sn-xp )

(defvar sn-AUTOLOAD_DIR ())
;; DONT 
;; - MERGE this into defvar: it won't update when user change this definition
(setq sn-AUTOLOAD_DIR (concat (file-name-directory (file-truename load-file-name)) "autoloads"))  ; = $(dirname $(readlink -e <this-loaded-file>))/autoloads
(unless (file-exists-p sn-AUTOLOAD_DIR)
  (error "%s: %s" "File not exist" sn-AUTOLOAD_DIR))

;; - autoloading (batch-loading):
(dolist (file (directory-files sn-AUTOLOAD_DIR t "\.el$" nil))
  (let (( the-file-base-name (file-name-base file )))
    (unless (string-match "\.skip$" the-file-base-name)
      (autoload (intern the-file-base-name) file "" "interactive") ; my template system)
      ;; (unless (string-match "^skip.*" (file-name-base file))
      ;; (autoload (intern (file-name-base file)) file "" "interactive") ; my template system)))
      )))
      
