;; System-type definition
(defun system-is-linux()
    (string-equal system-type "gnu/linux"))
(defun system-is-windows()
  (string-equal system-type "windows-nt"))

;; Unix path-variable
(when (system-is-linux)
    (setq unix-sbcl-bin          "/usr/bin/sbcl")
    (setq unix-init-path         "~/.emacs.d")
    (setq unix-init-ct-path      "~/.emacs.d/plugins/color-theme")
    (setq unix-init-ac-path      "~/.emacs.d/plugins/auto-complete")
    (setq unix-init-slime-path   "/usr/share/common-lisp/source/slime/")
    (setq unix-init-ac-dict-path "~/.emacs.d/plugins/auto-complete/dict"))

(require 'package)
(add-to-list 'package-archives
         '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

(setq make-backup-files nil)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(add-to-list 'load-path "~/.emacs.d/custom")

;;Color themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

(desktop-save-mode 1)

;;-----------------Russian hotkeys off-------------
(defun reverse-input-method (input-method)
  "Build the reverse mapping of single letters from INPUT-METHOD."
  (interactive
   (list (read-input-method-name "Use input method (default current): ")))
  (if (and input-method (symbolp input-method))
      (setq input-method (symbol-name input-method)))
  (let ((current current-input-method)
        (modifiers '(nil (control) (meta) (control meta))))
    (when input-method
      (activate-input-method input-method))
    (when (and current-input-method quail-keyboard-layout)
      (dolist (map (cdr (quail-map)))
        (let* ((to (car map))
               (from (quail-get-translation
                      (cadr map) (char-to-string to) 1)))
          (when (and (characterp from) (characterp to))
            (dolist (mod modifiers)
              (define-key local-function-key-map
                (vector (append mod (list from)))
                (vector (append mod (list to)))))))))
    (when input-method
      (activate-input-method current))))

(reverse-input-method 'russian-computer)

;; == irony-mode ==
(use-package irony
  :ensure t
  :defer t
  :init
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode)
  :config
  ;; replace the `completion-at-point' and `complete-symbol' bindings in
  ;; irony-mode's buffers by irony-mode's function
  (defun my-irony-mode-hook ()
    (define-key irony-mode-map [remap completion-at-point]
      'irony-completion-at-point-async)
    (define-key irony-mode-map [remap complete-symbol]
      'irony-completion-at-point-async))
  (add-hook 'irony-mode-hook 'my-irony-mode-hook)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  )

;; == company-mode ==
(use-package company
  :ensure t
  :defer t
  :init (add-hook 'after-init-hook 'global-company-mode)
  :config
  (use-package company-irony :ensure t :defer t)
  (setq company-idle-delay              nil
	company-minimum-prefix-length   2
	company-show-numbers            t
	company-tooltip-limit           20
	company-dabbrev-downcase        nil
	company-backends                '((company-irony company-gtags))
	)
  :bind ("C-'" . company-complete-common)
  )

;;HotKeys
(global-set-key (kbd "C-x <C-up>") 'helm-gtags-find-files)
(global-set-key (kbd "<M-right>") 'tabbar-forward-tab)
(global-set-key (kbd "<M-left>") 'tabbar-backward-tab)
(global-set-key (kbd "M-p") 'tabbar-local-mode)
(global-set-key (kbd "C-x n") 'split-window-right)

;;GDB windows
(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t

 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t
 )

(require 'setup-general)
(if (version< emacs-version "24.4")
    (require 'setup-ivy-counsel)
  (require 'setup-helm)
  (require 'setup-helm-gtags))
 ;;(require 'setup-ggtags)
(require 'setup-cedet)
(require 'setup-editing)

(require 'helm-gtags)

;;Cmake
(setq load-path (cons (expand-file-name "/elpa/cmake-ide-20201027.1947/") load-path))
(require 'cmake-mode)

;;,,TAB
(setq-default indent-tabs-mode t) ;; включить возможность ставить отступы TAB'ом
(setq-default tab-width          4) ;; ширина табуляции - 4 пробельных символа
(setq-default c-basic-offset     4)
(setq-default indent-tabs-mode nil) ;; tab to space
(setq-default standart-indent    4) ;; стандартная ширина отступа - 4 пробельных символа
(setq-default lisp-body-indent   4) ;; сдвигать Lisp-выражения на 4 пробельных символа
(global-set-key (kbd "RET") 'newline-and-indent) ;; при нажатии Enter перевести каретку и сделать отступ
(setq lisp-indent-function  'common-lisp-indent-function)

;; Show-paren-mode settings
(show-paren-mode t) ;; включить выделение выражений между {},[],()
(setq show-paren-style 'expression) ;; выделить цветом выражения между {},[],()

;; Electric-modes settings
(electric-pair-mode    1) ;; автозакрытие {},[],() с переводом курсора внутрь скобок
(electric-indent-mode -1) ;; отключить индентацию  electric-indent-mod'ом (default in Emacs-24.4)

;; Custom lines, created automaticaly. Don't touch this shit

;; function-args
;; (require 'function-args)
;; (fa-config-default)
;; (define-key c-mode-map  [(tab)] 'company-complete)
;; (define-key c++-mode-map  [(tab)] 'company-complete)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Linum-format "%7i ")
 '(ansi-color-names-vector
   ["#110F13" "#B13120" "#719F34" "#CEAE3E" "#7C9FC9" "#7868B5" "#009090" "#F4EAD5"])
 '(company-c-headers-path-user
   (quote
    ("/home/max/projects/dsp/commonpocket/CSC/Test/Include")))
 '(company-idle-delay nil)
 '(company-minimum-prefix-length 2)
 '(company-show-numbers t)
 '(company-tooltip-limit 20)
 '(custom-enabled-themes (quote (cherry-blossom)))
 '(custom-safe-themes
   (quote
    ("2aa073a18b2ba860d24d2cd857bcce34d7107b6967099be646d9c95f53ef3643" "7153b82e50b6f7452b4519097f880d968a6eaf6f6ef38cc45a144958e553fbc6" "5e3fc08bcadce4c6785fc49be686a4a82a356db569f55d411258984e952f194a" "04dd0236a367865e591927a3810f178e8d33c372ad5bfef48b5ce90d4b476481" "a0feb1322de9e26a4d209d1cfa236deaf64662bb604fa513cca6a057ddf0ef64" "ab04c00a7e48ad784b52f34aa6bfa1e80d0c3fcacc50e1189af3651013eb0d58" "94146ac747852749e9444b184eb1e958f0e546072f66743929a05c3af62de473" "15492649746910860a155b296e94e18c94d48408079ced764165c47a1f78d2e7" default)))
 '(fci-rule-character-color "#202020")
 '(fci-rule-color "#202020")
 '(fringe-mode 4 nil (fringe))
 '(gdb-many-windows t)
 '(gdb-non-stop-setting nil)
 '(gdb-show-main t)
 '(global-company-mode t)
 '(gud-gdb-command-name "gdb-multiarch -i=mi")
 '(helm-ff-lynx-style-map t)
 '(main-line-color1 "#1E1E1E")
 '(main-line-color2 "#111111")
 '(main-line-separator-style (quote chamfer))
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(package-selected-packages
   (quote
    (tabbar magit clang-format format-all git-command git helm-navi cmake-ide cmake-font-lock cmake-mode company-irony company-irony-c-headers irony helm-company company-go company-c-headers zygospore helm-gtags helm yasnippet ws-butler volatile-highlights use-package undo-tree iedit dtrt-indent counsel-projectile company clean-aindent-mode anzu)))
 '(powerline-color1 "#1E1E1E")
 '(powerline-color2 "#111111")
 '(safe-local-variable-values
   (quote
    ((company-clang-arguments "-I/home/max/TestProject/include/")
     (company-clang-arguments "-I/home/max/projects/dsp/commonpocket/CSC/Include/" "-I/home/max/projects/dsp/commonpocket/CSC/JetServer/Include/" "-I/home/max/projects/dsp/commonpocket/CSC/Test/Include/"))))
 '(tabbar-mode t nil (tabbar))
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-echo-common ((t (:foreground "magenta"))))
 '(company-preview ((t (:background "yellow" :foreground "wheat"))))
 '(company-preview-common ((t (:inherit company-preview :foreground "deep sky blue"))))
 '(company-scrollbar-bg ((t (:background "azure4"))))
 '(company-scrollbar-fg ((t (:background "blue"))))
 '(company-template-field ((t (:background "yellow" :foreground "magenta"))))
 '(company-tooltip ((t (:background "black" :foreground "yellow"))))
 '(company-tooltip-annotation ((t (:foreground "steel blue"))))
 '(company-tooltip-common ((t (:foreground "green"))))
 '(company-tooltip-selection ((t (:background "midnight blue"))))
 '(tabbar-button ((t (:inherit tabbar-default :box (:line-width 1 :color "black" :style released-button)))))
 '(tabbar-default ((t (:inherit variable-pitch :background "black" :foreground "deep sky blue" :height 0.8))))
 '(tabbar-modified ((t (:inherit tabbar-default :foreground "red" :box (:line-width 1 :color "white" :style released-button)))))
 '(tabbar-selected ((t (:inherit tabbar-default :foreground "gold" :box (:line-width 1 :color "white" :style pressed-button)))))
 '(tabbar-selected-modified ((t (:inherit tabbar-default :foreground "green" :box (:line-width 1 :color "white" :style released-button))))))
(put 'set-goal-column 'disabled nil)
