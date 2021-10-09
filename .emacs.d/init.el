(setq inhibit-startup-message t) 	; Disable startup message
(setq
 whitespace-display-mappings
 '((space-mark 32 [183] [46]) ; 32 SPACE, 183 MIDDLE DOT 「·」, 46 FULL STOP 「.」
   (newline-mark 10 [10]) ; 10 line feed
   (tab-mark 9 [9655 9] [92 9]))) ; 9 TAB, 9655 WHITE RIGHT-POINTING TRIANGLE 「▷」

(scroll-bar-mode -1)			; Disable scrollbar
(tool-bar-mode  -1)			; Disable toolbar
(tooltip-mode -1)			; Disable tooltips
(set-fringe-mode 10)			; Breathing room 
(menu-bar-mode -1)			; Disable menu bar
(set-face-attribute
 'default nil
 :font "Victor Mono SemiBold"		; Set font
 :height 150)				; Set font size
(load-theme 'gruber-darker t)		; Set nice theme
(global-set-key (kbd "<escape>")
		'keyboard-escape-quit)	; Use ESC to quit

(require 'package)			; Init package

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("melpa stable" . "https://stable.melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(setq backup-directory-alist '(("" . "~/.emacs.d/backup")))

(setq
 gnutls-algorithm-priority
 "NORMAL:-VERS-TLS1.3")			; Fix gnu archive

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
	(package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(column-number-mode)			; Show line number column
(global-display-line-numbers-mode t)	; Line numbers everywhere

;; Turn off line numbers for terminals and org mode
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("03e26cd42c3225e6376d7808c946f7bed6382d795618a82c8f3838cd2097a9cc" "d14f3df28603e9517eb8fb7518b662d653b25b26e83bd8e129acea042b774298" default))
 '(global-command-log-mode t)
 '(package-selected-packages
   '(magit cider auctex company lsp-haskell python-mode rust-mode lsp-ivy dap-mode flycheck lsp-ui lsp-mode haskell-mode evil helpful smex gruber-darker-theme counsel ivy-rich which-key rainbow-delimiters doom-modeline gruvbox-theme ivy command-log-mode use-package))
 '(send-mail-function 'smtpmail-send-it)
 '(smtpmail-smtp-server "smtp.gmail.com")
 '(smtpmail-smtp-service 25))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package command-log-mode) ; Commands buffer

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)		; Find text
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
	 ("C-d" . ive-reverse-i-search-kill))
  :demand				; Force enable ivy
  :config
  (ivy-mode 1))				; Enable ivy keybinds

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

;; Buffer switcher Ctrl-Alt-j
(global-set-key (kbd "C-M-j") 'counsel-switch-buffer)

(require 'smex)				; Better M-x
(smex-initialize)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key
 (kbd "C-c C-c M-x")
 'execute-extended-command)		; Ivy rich M-x

;; Run M-x all-the-icons-install-fonts
;; after installing for the first time
(use-package all-the-icons)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

;; Rainbow brackets essentially
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Show keybinds
;; A little hidden behind doom-modeline
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 1))

;; Better docs for elisp
(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(require 'lsp)
(require 'lsp-haskell)

(setq lsp-haskell-server-path "/Users/willlane/Library/Application Support/Code/User/globalStorage/haskell.haskell/haskell-language-server-1.3.0-darwin-9.0.1")

(add-hook 'haskell-mode-hook #'lsp)
(add-hook 'haskell-literate-mode-hook #'lsp)

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-l")
  :hook ((python-mode . lsp)
	 (rust-mode . lsp)
	 (haskell-mode . lsp)
	 (c-mode . lsp)
	 (c++-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; LSP 
(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package lsp-ui
  :commands lsp-ui-mode)

;; eshell paths
(defun jpk/eshell-mode-hook ()
  (eshell/addpath "/opt/bin")
  (eshell/addpath "~/.cabal/bin")
  (eshell/addpath "~/.local/bin")
  (eshell/addpath "~/.cargo/bin")
  (eshell/addpath "~/Library/Application Support/Code/User/globalStorage/haskell.haskell")
  (eshell/addpath "~/.ghcup/ghc/9.0.1/bin")
  (eshell/addpath "/Applications/Julia-1.5.app/Contents/Resources/julia/bin")
  (eshell/addpath "~/.cabal/bin")
  (eshell/addpath "~/.ghcup/bin")
  (eshell/addpath "/usr/local/sbin")
  (eshell/addpath "~/go/bin")
  (eshell/addpath "/usr/local/share/dotnet")
  (eshell/addpath "/usr/local/bin"))
(add-hook 'eshell-mode-hook #'jpk/eshell-mode-hook)

