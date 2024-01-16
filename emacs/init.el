(setq inhibit-startup-message t)

(setq frame-resize-pixelwise t)
(setq warning-minimum-level :emergency)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

(set-face-attribute 'default nil :font "Hack" :height 120)
(setq image-use-external-converter t)

(load-theme 'wombat)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; change auto save directory
(setq auto-save-default nil) ; until i figure out the nix problem
(setq auto-save-file-name-transforms
  `((".*" "~/.emacs-saves/" t)))
(setq backup-directory-alist `(("." . "~/.saves")))

(defun nils/home-manager-rebuild ()
  (interactive)
  (async-shell-command "home-manager switch --flake ~/.dotfiles/."))

(defun nils/nixos-rebuild ()
  (interactive)
  (async-shell-command "sudo nixos-rebuild switch --flake ~/.dotfiles/.#saruei"))

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

(use-package diminish)
(use-package command-log-mode)

(use-package tree-sitter
  :ensure t
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :ensure t
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

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (counsel-mode 1)
  :diminish)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package all-the-icons)

(use-package general
  :after evil
  :config
  (general-create-definer nils/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC"))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (evil-set-undo-system 'undo-redo)
  (define-key evil-motion-state-map "K" nil)
  (define-key evil-normal-state-map "K" 'lsp-ui-doc-glance)
  (define-key evil-normal-state-map (kbd "]e") 'flymake-goto-next-error)
  (define-key evil-normal-state-map (kbd "[e") 'flymake-goto-prev-error)
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
(evilnc-default-hotkeys)

(use-package hydra
  :defer t)

(use-package magit
  :commands magit-status)

(use-package git-gutter
  :after magit
  :config
  :diminish
  git-gutter-mode
  global-git-gutter-mode)
(global-git-gutter-mode +1)

(use-package projectile
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/src/")
    (setq projectile-project-search-path '("~/src/" "~/.dotfiles/" "~/work/")))
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
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . nils/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l"))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'at-point))

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
  :after tree-sitter
  :hook
  (rust-mode . rust-ts-mode)
  (rust-mode . lsp)
  :mode "\\.rs\\'"
  :config
  (setq indent-tabs-mode nil))

(use-package company
  :diminish
  :after lsp-mode
  :hook (lsp-mode . company-mode)
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

(nils/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text")
  "sf" 'find-file
  "SPC" 'counsel-switch-buffer
  "gs" 'magit-status
  "gd" 'magit-diff-unstaged
  "gf" 'magit-fetch
  "gF" 'magit-fetch-all
  "ca" 'lsp-execute-code-action
  "gc" 'magit-branch-or-checkout)
