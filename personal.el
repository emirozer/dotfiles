;;; personal config start:

;; OSX SPECIFIC
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH"))

;; default start up frame size
(if (window-system)
    (set-frame-size (selected-frame) 150 50))

;; disable default theme
(disable-theme 'zenburn)

;; neotree setup with all-the-icons
(require 'all-the-icons)
(require 'neotree)
(setq neo-window-fixed-size nil)
(setq neo-window-width 25)
(neotree)

;; autopair utilize globally
(require 'autopair)
(autopair-global-mode 1)
(setq autopair-autowrap t)


;; circe irc settings
(setq circe-network-options
      '(("Freenode"
         :tls t
         :nick "REDACTED"
         :sasl-username "REDACTED"
         :sasl-password "REDACTED"
         :channels ("#erlang" "#protobuf" "##linux" "#debian" "#git" "#go-nuts" "##aws" "#docker" "#erlang" "##java" "#cloudfoundry" "#postgresql" "#bosh" "#python" "#python-dev")
         )))
(setq circe-reduce-lurker-spam t)

(setq helm-mode-no-completion-in-region-in-modes
      '(circe-channel-mode
        circe-query-mode
        circe-server-mode))

;; HELM SETUP STARTS
(require 'prelude-helm)
(prelude-require-packages '(helm-descbinds helm-ag))
(require 'helm-eshell)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-m") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-h f") 'helm-apropos)
(global-set-key (kbd "C-h r") 'helm-info-emacs)
(global-set-key (kbd "C-h C-l") 'helm-locate-library)
(define-key prelude-mode-map (kbd "C-c f") 'helm-recentf)

(define-key minibuffer-local-map (kbd "C-c C-l") 'helm-minibuffer-history)
;; shell history.
(define-key shell-mode-map (kbd "C-c C-l") 'helm-comint-input-ring)
;; use helm to list eshell history
(add-hook 'eshell-mode-hook
          #'(lambda ()
              (substitute-key-definition 'eshell-list-history 'helm-eshell-history eshell-mode-map)))

(substitute-key-definition 'find-tag 'helm-etags-select global-map)
(setq projectile-completion-system 'helm)
(helm-descbinds-mode)
(helm-mode 1)

(helm-autoresize-mode 1)
(setq helm-autoresize-max-height 30)
(setq helm-split-window-in-side-p t)
(setq helm-autoresize-min-height 30)
(setq helm-display-header-line nil) ;; t by default
(set-face-attribute 'helm-source-header nil :height 0.1)

;; enable Helm version of Projectile with replacement commands
(helm-projectile-on)
;; HELM SETUP ENDS

;; TERMINAL EMULATION
(add-to-list 'load-path "/Users/eoz/emacs-libvterm")
(require 'vterm)


;; IDE SETUP STARTS HERE
(require 'company)

;; ERLANG STARTS
(add-hook 'after-init-hook
          #'(lambda ()
              (require 'auto-complete-config)
              (require 'edts-start)
              (ac-config-default)))
(require 'edts-mode)
(define-key edts-mode-map (kbd "C-.") 'edts-find-source-under-point)
(define-key edts-mode-map (kbd "C-,") 'edts-find-source-unwind)
;; ERLANG ENDS

;; GOLANG STARTS
(setq exec-path (append '("/Users/eoz/go/bin") exec-path))
(setenv "PATH" (concat "/Users/eoz/go/bin:" (getenv "PATH")))

                                        ; As-you-type error highlighting
(add-hook 'after-init-hook #'global-flycheck-mode)

(defun my-go-mode-hook ()
  (add-hook 'before-save-hook 'gofmt-before-save)
  (setq tab-width 4 indent-tabs-mode 1)
                                        ; eldoc shows the signature of the function at point in the status bar.
  (go-eldoc-setup)
  (local-set-key (kbd "C-.") #'godef-jump)
  (add-hook 'before-save-hook 'gofmt-before-save)

                                        ; extra keybindings from https://github.com/bbatsov/prelude/blob/master/modules/prelude-go.el
  (let ((map go-mode-map))
    (define-key map (kbd "C-c a") 'go-test-current-project) ;; current package, really
    (define-key map (kbd "C-c m") 'go-test-current-file)
    (define-key map (kbd "C-c .") 'go-test-current-test)
    (define-key map (kbd "C-c b") 'go-run)))
(add-hook 'go-mode-hook 'my-go-mode-hook)

(require 'go-mode)
(require 'company-go)
(add-hook 'go-mode-hook (lambda ()
                          (company-mode)
                          (set (make-local-variable 'company-backends) '(company-go))))
;; GOLANG ENDS HERE

;; PYTHON STARTS
(require 'use-package)
(use-package anaconda-mode
  :init 
  (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'company-mode)
  (add-hook 'python-mode-hook 'anaconda-eldoc-mode)
  (add-hook 'python-mode-hook 'display-line-numbers-mode))
(eval-after-load "company"
  '(add-to-list 'company-backends 'company-anaconda))
;; PYTHON ENDS

;; IDE SETUP ENDS HERE

;;; personal.el ends here
