;; version: 0.4.0
;; DONT USE yas-expand-snippet: it always added 't' infront of expanded embeded snippet due to its calling evil-track-after-changes and flycheck-... after the expansion

;; keymap is set in ~/sn/sn-snip-mode.el
;; DONT:
;; - MERGE setq into defvar - it won't get updated when re-loading buffer)
(defvar sn-SHELL_EXE ()) (setq sn-SHELL_EXE "~/bin/sn")
(defvar sn-RX_ECMD_FIND ()) (setq sn-RX_ECMD_FIND "`\\((.+)\\)`" ) ; regular expression to search for emacs command 2 be performed by the emacs editor 
(defvar sn-RX_ECMD_REPL ()) (setq sn-RX_ECMD_REPL "" ) ; regular expression to parse the sn-RX_ECMD_FIND above into proper emacs command to be performed

(unless (file-readable-p sn-SHELL_EXE)
  (error "%s: %s" "File not readable" sn-SHELL_EXE))

;;;###autoload
(defun sn-xp (&optional snipKeyword)
  "Expand my snippet. 
  SnipKeyword: root name (base name without extension) of the snippet file. If non provided to this function, scan the word at point."
  (interactive)
  (let* (
         (local-bounds ()) 
         (local-majorMode major-mode)
         (embedCode ())
         (trimmedEmbedCode ())
         ;; (callerBuffer (current-buffer))
         (derivedBufferStr "") ; content of the cached snippet file
         )
    (when (equal snipKeyword ())
      (setq snipKeyword (symbol-name (symbol-at-point))) ; the text at point (used as keyword for searching the template)
      (setq local-bounds (bounds-of-thing-at-point 'symbol)) ; the boundary of selected region; used to delete the region after the snip expanded
      ;; - kill the selected region right away:
      ;; DONT MOVE this operation away from the setq local-bounds statement above, other ops may change the selected region
      (if local-bounds
          (delete-region (car local-bounds) (cdr local-bounds))
        ) ; modified from Tomohiro Matsuyama 's snipKeywordopt.el
      )      
    
    ;; - get the template keyword (at point) - add the major-mode to it - expand it with ~/bin/sn:
    
    ;; - check if snipKeyword is not null:
    (if (equal snipKeyword ())
        (user-error "%s" "EXIT: sn-snip(): snipKeyword is still null"))
    
    ;; - open the cached file to edit it
    
    ;; - search for the snippet cache file - open it in a buffer:
    (setq derivedBufferStr "") ; reset derivedBuffer b4 finding cache snippet file:
    (save-excursion
      (when (find-file (shell-command-to-string (concat sn-SHELL_EXE " " snipKeyword "." (replace-regexp-in-string "-mode$" "" (symbol-name major-mode) ) ) ))
        (setq major-mode local-majorMode)
        ;; (setq derivedBuffer (current-buffer))
        (goto-char (point-min))
        
        ;; TODO: 
        ;; - turn when into do-loop keep repeating until none found
        ;; - replace bound at point with simple replace-match and match-string
        (while (re-search-forward sn-RX_ECMD_FIND nil t) ; emacs 24: match as least as possible -> no worry about the match over-reaching to the tail of another `(`) instead of just this `(`) phrase
          (setq embedCode (concat (match-string-no-properties 1)))
          (replace-match sn-RX_ECMD_REPL) ; clear the inline elisp-code in the buffer
          ;; (setq trimmedEmbedCode (replace-regexp-in-string "`" "" embedCode))
        
        ;; DONT REORDER the codes below - messed up due to setq's volatility -> kill-region b4 eval the region content -> var holding thing-at-point will be nil:
        ;; (setq local-bounds (bounds-of-thing-at-point 'sentence))
        ;; (delete-region (car local-bounds) (cdr local-bounds))
        (message "%s: `%s'" "cut phrase" embedCode)
        (when embedCode
        (let ((result (eval (car (read-from-string embedCode)))))
          ;; (message "result: %s" result)
          ;; (when result
          ;;   (format "%s" result)
          ;; TODO: only save buffer when the eval operation return non-nil (now it always return nil even if ops successfull!!!)
          (save-buffer) ; save the buffer (if modified) to the cache file
          ) ; let result..
          ) ;when embedCode
          ); while re-search-forward
      ;; - insert-buffer-substring (this buffer) -> the caller buffer
      ;; (message "%s is: %s" "local-bounds" (symbol-name 'local-bounds))
      (setq derivedBufferStr (buffer-string))
      (kill-buffer (current-buffer))
      ) ; when find-file
      ) ; save-excursion
  ;; (insert-buffer-substring derivedBuffer)
  (insert derivedBufferStr)
  ) ; let*
  ) ; defun

;; Local Variables:
;; flycheck-disabled-checkers: (emacs-lisp-checkdoc)
;; End:
