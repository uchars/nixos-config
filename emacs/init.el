(setq inhibit-startup-message t)

(setq warning-minimum-level :emergency)

; disable some UI elements
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)          ; Disable the menu bar

(set-default-coding-systems 'utf-8)
(setq indent-tabs-mode nil) ; spaces rule

;; scroll settings
(setq scroll-margin 8)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq use-dialog-box nil) ;; Disable dialog boxes since they weren't working in Mac OSX

;; disable symlink warnings
(setq vc-follow-symlinks t)

(defun nils/transparency-enable ()
  "Enables Editor transparency."
  (interactive)
  (set-frame-parameter (selected-frame) 'alpha '(90 . 90))
  (add-to-list 'default-frame-alist '(alpha . (90 . 90))))

(defun nils/transparency-disable ()
  "Disable Editor transparency."
  (interactive)
  (set-frame-parameter (selected-frame) 'alpha '(100 . 100))
  (add-to-list 'default-frame-alist '(alpha . (100 . 100))))

(defun nils/set-font ()
  "Set the editor font."
  (if (eq system-type 'windows-nt)
      (set-face-attribute 'default nil :height 120)
    (set-face-attribute 'default nil :height 120)))

(nils/set-font)

(setq image-use-external-converter t)

(setq tramp-default-method "ssh")

(load-theme 'wombat)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; change auto save directory
(setq auto-save-default nil) ; until i figure out the nix problem
(setq auto-save-file-name-transforms
  `((".*" "~/.emacs-saves/" t)))
(setq backup-directory-alist `(("." . "~/.saves")))

(defun nils/home-manager-rebuild ()
  "Home Manager build."
  (interactive)
  (async-shell-command "home-manager switch --flake ~/.dotfiles/."))

(defun nils/nixos-rebuild ()
  "NixOS system build."
  (interactive)
  (async-shell-command "sudo nixos-rebuild switch --flake ~/.dotfiles/.#lumi"))

(dolist (mode '(org-mode-hook
		image-mode-hook
		lsp-ui-doc-frame-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(dolist (mode '(term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (evil-emacs-state))))

;; Initialize package sources
(require 'package)

(require 'treesit)
(setq major-mode-remap-alist
      '((css-mode . css-ts-mode)))

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(defun nils/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 0)
  (setq evil-auto-indent nil)
  (diminish org-indent-mode))

(use-package org
  :defer t
  :hook (org-mode . nils/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
	org-hide-emphasis-markers t
	org-src-fontify-natively t
	org-fontify-quote-and-verse-blocks t
	org-src-tab-acts-natively t
	org-edit-src-content-indentation 2
	org-hide-block-startup nil
	org-src-preserve-indentation nil
	org-startup-folded 'content
	org-cycle-separator-lines 2)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-j") 'org-next-visible-heading)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-k") 'org-previous-visible-heading)
  (use-package org-superstar
    :after org
    :hook (org-mode . org-superstar-mode)
    :custom
    (org-superstar-remove-leading-stars t)
    (org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●")))
  (set-face-attribute 'org-document-title nil :weight 'bold :height 1.3)
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :weight 'medium :height (cdr face)))
  (require 'org-indent)
  (use-package evil-org
    :after org
    :hook ((org-mode . evil-org-mode)
	   (org-agenda-mode . evil-org-mode)
	   (evil-org-mode . (lambda () (evil-org-set-key-theme '(navigation todo insert textobjects additional)))))
    :config
    (require 'evil-org-agenda)
    (evil-org-agenda-set-keys)))

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Documents/notes")
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+date: %U\n")
      :unnarrowed t)
     ("b" "dienstreise" plain "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+date: %U\n#+filetags: Dienstreise")
      :unnarrowed t)))
   :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))

(use-package org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
	org-roam-ui-follow t
	org-roam-ui-update-on-save t))

(use-package marginalia
  :after vertico
  :straight t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(defun efs/exwm-update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))

(use-package exwm
  :config
  (setq exwm-workspace-number 5)
  (add-hook 'exwm-update-class-hook #'efs/exwm-update-class)

  (require 'exwm-randr)
  (exwm-randr-enable)

  (require 'exwm-systemtray)
  (exwm-systemtray-enable)

  (setq exwm-input-prefix-keys
	'(?\C-x
	  ?\C-u
	  ?\C-w
	  ?\C-h
	  ?\M-x
	  ?\M-`
	  ?\M-&
	  ?\M-:
	  ?\C-\M-j  ;; Buffer list
	  ?\C-\ ))  ;; Ctrl+Space
  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

  (setq exwm-input-global-keys
	`(
	  ;; Reset to line-mode (C-c C-k switches to char-mode via exwm-input-release-keyboard)
	  ([?\s-r] . exwm-reset)

          ;; Move between windows
          ([?\s-h] . windmove-left)
          ([?\s-l] . windmove-right)
          ([?\s-k] . windmove-up)
          ([?\s-j] . windmove-down)

          ;; Launch applications via shell command
          ([?\s-&] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))

          ;; Switch workspace
          ([?\s-w] . exwm-workspace-switch)
          ([?\s-`] . (lambda () (interactive) (exwm-workspace-switch-create 0)))

          ;; 's-N': Switch to certain workspace with Super (Win) plus a number key (0 - 9)
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
		    (number-sequence 0 9))))

  (exwm-enable))

(use-package diminish)
(diminish 'eldoc-mode)
(use-package command-log-mode)

(use-package tree-sitter
  :diminish
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :after tree-sitter)

(use-package swiper)

(use-package ivy
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1)
  :diminish)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package all-the-icons)

(use-package general
  :after evil
  :config
  (general-create-definer nils/spc-leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC"))

(use-package vundo)

(defun nils/evil-scroll-up ()
  "Emacs version of C-u zz."
  (interactive)
  (evil-scroll-up nil)
  (evil-scroll-line-to-center nil))

(defun nils/evil-scroll-down ()
  "Emacs version of C-d zz."
  (interactive)
  (evil-scroll-down nil)
  (evil-scroll-line-to-center nil))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (evil-define-key 'normal 'global (kbd "C-u") 'nils/evil-scroll-up)
  (evil-define-key 'normal 'global (kbd "C-d") 'nils/evil-scroll-down)
  (evil-set-undo-system 'undo-redo)
  (define-key evil-motion-state-map "K" nil)
  (define-key evil-motion-state-map (kbd "C-f") nil)
  (define-key evil-normal-state-map "K" 'lsp-ui-doc-glance)
  (define-key evil-normal-state-map (kbd "]e") 'flycheck-next-error)
  (define-key evil-normal-state-map (kbd "[e") 'flycheck-previous-error)
  :diminish)

;; line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

(use-package evil-collection
  :after evil
  :custom (evil-collection-want-unimpaired-p nil)
  :config
  (evil-collection-init)
  :diminish)

(use-package evil-nerd-commenter
  :after evil)

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
	 ("C-f" . 'counsel-rg)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (counsel-mode 1)
  :diminish)

(use-package hydra
  :defer t)

(use-package magit
  :commands magit-status)

(use-package magit-todos
  :defer t
  :after magit
  :config (magit-todos-mode 1))

(use-package git-gutter
  :diminish
  :hook
  ((text-mode . git-gutter-mode)
   (prog-mode . git-gutter-mode))
  :config
  (setq git-gutter:update-interval 2))

(use-package projectile
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/src/")
    (add-to-list projectile-project-search-path '("~/src/")))
  (when (file-directory-p "~/.dotfiles/")
    (add-to-list 'projectile-project-search-path "~/.dotfiles/"))
  (when (file-directory-p "~/work/")
    (add-to-list 'projectile-project-search-path "~/work/"))

  (setq projectile-switch-project-action #'projectile-dired)
  :diminish projectile-mode)

(use-package ripgrep
  :after projectile)

(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

;; lsp
(defun nils/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (general-define-key
   :states '(normal)
   :prefix "SPC"
   "ca" 'lsp-execute-code-action
   "gr" 'lsp-find-references)
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook
  (lsp-mode . nils/lsp-mode-setup)
  (c-mode . lsp-deferred)
  (c++-mode . lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l"))

(use-package flycheck
  :defer t
  :diminish
  :hook
  (lsp-mode . flycheck-mode)
  (emacs-lisp-mode . flycheck-mode))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'at-point))

(use-package ccls
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp))))

(use-package cmake-mode
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'")
  :hook (cmake-mode . lsp-deferred))

(use-package cmake-font-lock
  :after cmake-mode
  :config (cmake-font-lock-activate))

(use-package typescript-mode
  :diminish
  :after tree-sitter
  :hook
  (typescript-mode . lsp)
  :config
  (define-derived-mode typescriptreact-mode typescript-mode
    "TypeScript TSX")
  (setq typescript-indent-level 2)
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescriptreact-mode))
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescriptreact-mode . tsx)))

(use-package rust-mode
  :diminish
  :after lsp-mode
  :hook
  (rust-mode . lsp)
  :mode "\\.rs\\'")

(use-package cargo
  :defer t)

(use-package lsp-nix
  "Install 'nil' & 'nixpkgs-fmt'"
  :ensure lsp-mode
  :after lsp-mode
  :custom
  (lsp-nix-nil-formatter ["nixpkgs-fmt"]))

(use-package nix-mode
  :hook (nix-mode . lsp-deferred)
  :mode "\\.nix\\'")

(use-package go-mode
  "Install 'gofmt' & 'gopls'"
  :diminish
  :after lsp-mode
					;  :hook (go-mode . lsp)
  :mode "\\.go\\'")
(add-hook 'go-mode-hook #'lsp)

(use-package company
  :diminish
  :after lsp-mode
  :hook
  (lsp-mode . company-mode)
  :bind
  (:map company-active-map
	("<tab>" . company-select-next)
	("<backtab>" . company-select-previous))
  (:map lsp-mode-map
	("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :diminish
  :hook (company-mode . company-box-mode)
  :custom
  (company-box-scrollbar nil))

;; symbols (functions, variables) inside of the file
(use-package lsp-treemacs
  :after lsp)

(use-package markdown-mode
  :straight t
  :mode "\\.md\\'"
  :config
  (setq markdown-command "marked")
  (defun dw/set-markdown-header-font-sizes ()
    (dolist (face '((markdown-header-face-1 . 1.2)
                    (markdown-header-face-2 . 1.1)
                    (markdown-header-face-3 . 1.0)
                    (markdown-header-face-4 . 1.0)
                    (markdown-header-face-5 . 1.0)))
      (set-face-attribute (car face) nil :weight 'normal :height (cdr face))))
  (defun dw/markdown-mode-hook ()
    (dw/set-markdown-header-font-sizes))
  (add-hook 'markdown-mode-hook 'dw/markdown-mode-hook))

(use-package bufler
  :bind (("C-M-j" . bufler-switch-buffer)
	 ("C-M-k" . bufler-workspace-frame-set))
  :config
  (evil-collection-define-key 'normal 'bufler-list-mode-map
    (kbd "RET")   'bufler-list-buffer-switch
    (kbd "M-RET") 'bufler-list-buffer-peek
    "D"           'bufler-list-buffer-kill)
  (setf bufler-groups
	(bufler-defgroups
	 (group (auto-workspace))
	 (group (auto-projectile))
	 (group
	  (group-or "Browsers"
		    (name-match "Firefox" (rx bos "Firefox"))
		    (name-match "Chromium" (rx bos "Chromium")))))
	(group
	 (group-or "Help/Info"
		   (mode-match "*Help*" (rx bos (or "help-" "helpful-")))
		   (mode-match "*Info*" (rx bos "info-"))))
	(auto-mode)))

(nils/spc-leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text")
  "sf" 'find-file
  "SPC" 'counsel-switch-buffer
  "C-SPC" 'counsel-switch-buffer
  "gs" 'magit-status
  "fm" 'lsp-format-buffer
  "gd" 'magit-diff-unstaged
  "gf" 'magit-fetch
  "gF" 'magit-fetch-all
  "gc" 'magit-branch-or-checkout
  "/" 'evilnc-comment-or-uncomment-lines
  ;; org-mode bindings
  "o"   '(:ignore t :which-key "org mode")
  "oi"  '(:ignore t :which-key "insert")
  "oil" '(org-insert-link :which-key "insert link")
  "on"  '(org-toggle-narrow-to-subtree :which-key "toggle narrow")
  "os"  '(dw/counsel-rg-org-files :which-key "search notes")
  "oa"  '(org-agenda :which-key "status")
  "ot"  '(org-todo-list :which-key "todos")
  "oc"  '(org-capture t :which-key "capture")
  "ox"  '(org-export-dispatch t :which-key "export"))
