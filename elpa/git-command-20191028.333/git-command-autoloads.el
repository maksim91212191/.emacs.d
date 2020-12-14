;;; git-command-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "git-command" "git-command.el" (0 0 0 0))
;;; Generated autoloads from git-command.el

(autoload 'git-command "git-command" "\
Invoke git shell command.
While running git command, $GIT_EDITOR and $GIT_PAGER are set to use emacsclient
to open files and get outputs.

CMD is shell command string to run.
Called interactively, asks users what shell command to invoke.

If NEW-BUFFER-P is non-nil, generate new buffer for running command.
Interactively, give prefix argument for new buffer.

\(fn CMD &optional NEW-BUFFER-P)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "git-command" '("git-command-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; git-command-autoloads.el ends here
