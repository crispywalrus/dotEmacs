;;; configuration.el --- emacs configuration -*- lexical-binding: t -*-

;; Copyright ©  1997-2023 Chris Vale
;;
;; Author: Chris Vale <crispywalrus@gmail.com>

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; This file is not part of GNU Emacs.

;;; Commentary:

;; load various Emacs extensions that make my life easier and more productive.

;;; Code:

(defgroup configuration nil
  "Customization switches for configuration.el."
  :group 'emacs)

(defcustom project-management (expand-file-name "~/.emacs.d/projectile-config.el")
  "Use the file specified (if non-nil) for project management."
  :type 'file
  :group 'configuration)

;; configure appearance, no scrollbar or toolbars
(when (display-graphic-p)
  (setq initial-frame-alist nil
        default-frame-alist nil)
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (windmove-default-keybindings))

;; setup key bindings to allow for both super and hyper to have useful
;; bindings from darwin running device. also paper over the
;; differences between the way keys are named in emace-plus and
;; railwaycats distributions.
(when (eq system-type 'darwin)
  ;; mac osx, use ns-* settings to distiguish between the flavors of
  ;; emacs available. if we're on darwin use ns-use-native-fullscreen
  ;; to determine if we're using emacs-plus or railwaycats
  (if (boundp 'ns-use-native-fullscreen)
      ;; emacs-plus
      (progn
        (setq ns-use-native-fullscreen t
              ns-command-modifier 'meta
              ns-option-modifier 'super
              ns-right-option-modifier 'hyper)
        (global-set-key (kbd "M-h") 'ns-do-hide-emacs))
      ;; else railwaycats
      (setq mac-command-modifier 'meta
            mac-option-modifier 'super
            ;;            mac-right-option-modifier 'hyper))
            mac-right-option-modifier 'hyper)
    ()))

;; enable emacsclient
(server-start)

;; make use-package download all referenced but uninstalled
;; packages.
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; magit is so important we load it first
(use-package magit
  :ensure t
  :commands magit-status magit-blame
  :init
  (setq magit-auto-revert-mode nil)
  :bind (("s-g" . magit-status)
         ("s-b" . magit-blame)))

(use-package exec-path-from-shell
  :demand t
  :config (exec-path-from-shell-initialize))

;; exec-path-from-shell is great and I have a number of env variable
;; customized but it's not reliable with more than PATH
(setenv "JAVA_HOME" (expand-file-name "~/.sdkman/candidates/java/current"))
(setenv "GOPATH" (expand-file-name "~/go"))
(setenv "GOPROXY" "https://repo1.uhc.com/artifactory/api/go/golang-virtual/")
(setenv "GOPRIVATE" "github.com/optum-digital-rewards")
(setenv "PKG_CONFIG_PATH" "/opt/homebrew/Cellar/glib/2.80.0_2/lib/pkgconfig")

;; for code we can't just use from a package manager we'll check it
;; into the vendor tree and manage it by hand.
(add-to-list 'load-path (expand-file-name "vendor" user-emacs-directory))

(use-package editorconfig
  :config
  (editorconfig-mode 1))

;; these are various elisp coding and data structure
;; libraries. they're not user modes they're elisp
;; enhancements. Sometimes the modes and extensions used rely on them,
;; but I also use them for local elisp development. Since these are
;; just coding tools they tend to not need any configuration.
(use-package s)
(use-package dash)
(use-package m-buffer)
(use-package f)
(use-package suggest)
(use-package parsec)
(use-package pfuture)
(use-package async)
(use-package memoize)
(use-package uuidgen)

;; packages
;; my default customization

;; I use a .gitignored custom.el file so I can maintain different
;; configs per system. Loading fails if the file doesn't exist so we
;; touch it to make sure emacs always starts.
(f-touch (expand-file-name "custom.el" user-emacs-directory))

;; no tabs
(setq-default indent-tabs-mode nil)

;; I feel a bit curmudgeonly about this but no to menus, no to
;; scrollbars, no to toolbars, no to the scratch buffer message, no to
;; the startup screen.
(setq
 inhibit-startup-screen t
 initial-scratch-message nil
 custom-file (expand-file-name "custom.el" user-emacs-directory)
 load-prefer-newer t
 debug-on-error nil)

;; up abover we touched custom.el. we did this so that there was
;; definately going to be a file. now we can load it in relative
;; safety.
(load custom-file)

;; don't ask about narrow-to-regeion
(put 'narrow-to-region 'disabled nil)

(with-eval-after-load 'dired
  (require 'dired-x))

(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)

;; for some reason the mac version of emacs has decided to use / as
;; the default directory. That's not great for usability.
(setq default-directory "~/")

(use-package use-package-hydra
  :ensure t)

(use-package all-the-icons
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :after all-the-icons
  :hook (dired-mode . all-the-icons-dired-mode)
  :config (setq all-the-icons-dired-monochrome nil))

;; completion
(use-package hydra
  :ensure t
  :after (use-package-hydra dap-mode)
  :config
  (require 'dap-mode)
  (require 'dap-ui)
  :init
  (add-hook 'dap-stopped-hook
          (lambda (arg) (ignore arg) (call-interactively #'dap-hydra)))
  :hydra (hydra-go (:color pink :hint nil :foreign-keys run)
  "
   _n_: Next       _c_: Continue _g_: goroutines      _i_: break log
   _s_: Step in    _o_: Step out _k_: break condition _h_: break hit condition
   _Q_: Disconnect _q_: quit     _l_: locals
   "
	     ("n" dap-next)
	     ("c" dap-continue)
	     ("s" dap-step-in)
	     ("o" dap-step-out)
	     ("g" dap-ui-sessions)
	     ("l" dap-ui-locals)
	     ("e" dap-eval-thing-at-point)
	     ("h" dap-breakpoint-hit-condition)
	     ("k" dap-breakpoint-condition)
	     ("i" dap-breakpoint-log-message)
	     ("q" nil "quit" :color blue)
	     ("Q" dap-disconnect :color red)))

(use-package vertico
  :init (vertico-mode))

(use-package vertico-posframe
  :init (vertico-posframe-mode 1))

(use-package consult
  :after vertico
  :init
  ;; Use `consult-completion-in-region' if Vertico is enabled.
  ;; Otherwise use the default `completion--in-region' function.
  (setq completion-in-region-function
        (lambda (&rest args)
          (apply (if vertico-mode
                     #'consult-completion-in-region
                   #'completion--in-region)
                 args))))

(use-package marginalia
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

(use-package smart-mode-line
  :init
  (setq sml/no-confirm-load-theme t
        sml/theme 'dark
        sml/name-width 40
        sml/mode-width 'full)
  :hook (after-load-theme-hook . smart-mode-line-enable)
  :config (sml/setup))

;; turn down the busy on the modeline
(use-package diminish)

;; general programing IDE
(use-package ligature
  :config
  (global-ligature-mode t))

(use-package string-inflection
  :bind ("s-i" . string-inflection-all-cycle))

(use-package smartparens
  :init
  (smartparens-global-mode))

(require 'smartparens-config)

(use-package lsp-mode
  :config (setq lsp-enable-snippet nil)
  (setq gc-cons-threshold 100000000)
  (setq read-process-output-max (* 1024 1024))
  :hook (merlin-mode . lsp)
        (lsp-mode . lsp-lens-mode)
        (scala-mode . lsp)
        (go-mode . lsp)
        (rust-mode . lsp)
        (tuareg-mode . lsp))

(use-package lsp-ui)

(use-package flycheck
  :init
  (global-flycheck-mode))

(use-package flycheck-posframe
  :ensure t
  :after flycheck
  :hook (flycheck-mode))

(use-package consult-lsp)

;; for some reason this still needs to be added by hand
(use-package lsp-metals
  :after lsp-mode)

;; Posframe is a tool to create popup viewports
(use-package posframe)

(use-package dap-mode
  :config
  (dap-mode 1)
  (tooltip-mode 1)
  (setq dap-print-io t)
  (require 'dap-hydra)
  (require 'dap-dlv-go)
  (use-package dap-ui
    :ensure nil
    :config
    (dap-ui-mode 1)
    (dap-ui-controls-mode 1))
  :hook
  (lsp-mode . dap-mode)
  (lsp-mode . dap-ui-mode))

(use-package go-mode
  :init
  (setq lsp-go-analyses
        '((composites . :json-false)))
  :hook (before-save . gofmt-before-save)
        (go-mode . subword-mode))

(use-package rust-mode
  :init
  (setq rust-format-on-save t))

(use-package cargo-mode
  :hook
  (rust-mode . cargo-minor-mode))

(use-package tuareg)
(add-to-list 'load-path (expand-file-name "~/.opam/default/share/emacs/site-lisp"))
(use-package ocamlformat
  :custom
  (ocamlformat-enable 'enable-outside-detected-project)
  (ocamlformat-command
   (concat
    (file-name-as-directory
     (substring (shell-command-to-string "opam config var bin --switch=ocamlformat --safe") 0 -1))
    "ocamlformat"))
  :hook (before-save . ocamlformat-before-save))

(require 'utop)
(require 'ocp-indent)

(use-package zig-mode)

(use-package jwt)

(use-package graphql-mode)

(use-package json-mode
  :after graphql-mode)

(use-package sbt-mode
  :init (setq sbt:prefer-nested-projects t)
  :commands sbt-start sbt-command sbt-hydra
  :config (substitute-key-definition
           'minibuffer-complete-word
           'self-insert-command
           minibuffer-local-completion-map))

(use-package company
  :diminish company-mode)

(use-package scala-mode
  :config
  (require 'scala-mode-prettify-symbols)
  (setq prettify-symbols-alist scala-prettify-symbols-alist)
  :hook (scala-mode . company-mode)
        (scala-mode . smartparens-mode)
        (scala-mode . subword-mode)
  :diminish smartparens-mode
  :bind
  ("C-c C-b" . sbt-hydra)
  :interpreter
  ("scala" . scala-mode))

(use-package bazel
  :commands bazel-build bazel-run bazel-test bazel-coverage
  :mode ("\\.star\\'" . bazel-starlark-mode))

(use-package sml-mode
  :defer t)

(use-package smithy-mode)

;; mermaid is a package for laying out graphs in markdown and other
;; documents. It's rendered in github docs so that makes it a useful
;; package.
(use-package mermaid-mode)

(use-package markdown-mode)

(use-package yaml-mode)

(with-eval-after-load 'sql
  ;; sql-mode pretty much requires your psql to be uncustomised from stock settings
  (add-to-list 'sql-postgres-options "--no-psqlrc"))

(use-package sqlformat
  :config
  (setq sqlformat-command 'pgformatter
        sqlformat-args '("-s4" )))

;; moving on from programming support
(load project-management)

(use-package edit-indirect)

;; the end all, and be all. the navel of the world.
(use-package org
  :demand t
  :config (setq org-directory (expand-file-name "~/.org")
                org-default-notes-file (concat org-directory "/notes.org")
                org-agenda-files (directory-files-recursively (concat org-directory "/projects") "\\.org$"))
  :hook (jinx-mode)
  :bind (("C-c l" . org-store-link)
         ("C-c c" . org-capture)
         ("C-c a" . org-agenda)
         ("C-c b" . org-iswitchb)
         ("C-c C-w" . org-refile)
         ("C-c j" . org-clock-goto)
         ("C-c C-x C-i" . org-clock-in)
         ("C-c C-x C-o" . org-clock-out)))

(use-package org-fancy-priorities
  :init
  (setq org-priority-highest 0
        org-priority-default 2
        org-priority-lowest 4
        org-fancy-priorities-list '(
                                    (?0 . "P0")
                                    (?1 . "P1")
                                    (?2 . "P2")
                                    (?3 . "P3")
                                    (?4 . "P4"))
        org-priority-faces '((?0 :foreground "DarkRed" :background "LightPink")
                             (?1 :foreground "DarkOrange4" :background "LightGoldenrod")
                             (?2 :foreground "gray20" :background "gray")
                             (?3 :foreground "gray20" :background "gray")
                             (?4 :foreground "gray20" :background "gray"))))

(use-package org-modern)

(use-package org-kanban)

(use-package ob-go)
(use-package ob-rust)
(require 'ob-scala)
(use-package ob-graphql)
(use-package ob-mermaid)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((go . t)
   (rust . t)
   (graphql . t)
   (shell . t)
   (emacs-lisp . t)
   (scala . t)
   (sql . t)
   (sqlite . t)))

(use-package jinx
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages)))

(use-package sly)

(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))

(require 'quelpa-use-package)

(use-package copilot.el
;;         :quelpa (copilot.el :fetcher github
;;                         :repo "copilot-emacs/copilot.el"
;;                         :branch "main"
;;                         :files ("dist" "*.el"))
  :preface
  (defun rk/copilot-tab ()
    "Tab command that will complet with copilot if a completion is
available. Otherwise will try company, yasnippet or normal
tab-indent."
    (interactive)
    (or (copilot-accept-completion)
        (indent-for-tab-command)))
  :bind (:map copilot-mode-map
              ("<tab>" . rk/copilot-tab)))
;;        :hook ((prog-mode . copilot-mode)));;

(use-package copilot-chat)
  ;; :quelpa (copilot-chat :fetcher github
  ;;                       :repo "chep/copilot-chat.el"
  ;;                       :branch "master"
  ;;                       :files ("*.el")       ))

(use-package which-key)

(use-package which-key-posframe
  :init
  (setq which-key-posframe-poshandler 'posframe-poshandler-frame-top-right-corner))

(use-package casual-calc
  :ensure t
  :bind (:map calc-mode-map ("C-o" . casual-calc-tmenu)))

(use-package casual-info
  :ensure t
  :bind (:map Info-mode-map ("C-o" . casual-info-tmenu)))

(use-package casual-dired
  :ensure t
  :bind (:map dired-mode-map ("C-o" . casual-dired-tmenu)))

(use-package casual-isearch
  :ensure t
  :bind (:map isearch-mode-map ("<f2>" . casual-isearch-tmenu)))

(require 'ibuffer)
(use-package casual-ibuffer
  :ensure t
  :bind (:map ibuffer-mode-map
              ("C-o" . casual-ibuffer-tmenu)
              ("F" . casual-ibuffer-filter-tmenu)
              ("s" . casual-ibuffer-sortby-tmenu)))

(require 're-builder)
(use-package casual-re-builder
  :ensure t
  :bind (:map reb-mode-map
              ("C-o" . casual-re-builder-tmenu)))
;;; configuration.el ends here
