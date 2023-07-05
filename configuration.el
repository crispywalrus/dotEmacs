;;; configuration.el --- emacs configuration -*- lexical-binding: t -*-

;; Copyright ©  2022 Chris Vale
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

;; configure our GUI appearance. no scrollbar or toolbars and set the
;; font to Hack 12.

(defgroup configuration nil
  "Customization switches for configuration.el.")

(defcustom native-project nil
  "If non-nil use native project.el for project tracking"
  :type 'string
  :group 'configuration)

(when (display-graphic-p)
  (setq initial-frame-alist nil
        default-frame-alist nil)
  (set-frame-font "Hack-12" nil t)
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

;; make use-package download all referenced but uninstalled
;; packages.
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; magit is so important we load it first
(use-package magit
  :ensure t
  :commands magit-status magit-blame
  :init
  (setq magit-auto-revert-mode nil
        magit-last-seen-setup-instructions "1.4.0")
  :bind (("s-g" . magit-status)
         ("s-b" . magit-blame)))


(use-package exec-path-from-shell
  :init (exec-path-from-shell-initialize))

(setenv "JAVA_HOME" "/Users/cvale2/.sdkman/candidates/java/current")
(setenv "PATH" (concat "/Users/cvale2/.sdkman/candidates/java/current/bin:" (getenv "PATH")))
(setenv "GOPROXY" "direct")
(setenv "GOSUMDB" "off")

;; for code we can't just use from a package manager we'll check it
;; into the vendor tree and manage it by hand.
(add-to-list 'load-path (expand-file-name "vendor" user-emacs-directory))

;; these are various elisp coding and data structure
;; libraries. they're not user modes they're elisp
;; enhancements. Sometimes the modes and extensions used rely on them,
;; but I also use them for local elisp development. Since these are
;; just coding tools they tend to not need any configuration.
(use-package s)
(use-package string-inflection
  :bind ("s-i" . string-inflection-all-cycle))
(use-package dash)
(use-package m-buffer)
(use-package f)
;; (use-package multiple-cursors
;;   :ensure t)
(use-package suggest)
(use-package parsec)
(use-package pfuture)
(use-package async)
(use-package memoize)

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

(add-hook 'dired-load-hook (lambda () (require 'dired-x)))

;; for some reason the mac version of emacs has decided to use / as
;; the default directory. That's not great for usability.
(setq default-directory "~/")

(use-package nano-theme)

(use-package all-the-icons
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :after all-the-icons
  :hook (dired-mode . all-the-icons-dired-mode)
  :config (setq all-the-icons-dired-monochrome nil))

;; completion
(use-package hydra)

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
  :init
  (marginalia-mode))

(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

;; general programing IDE
(use-package diminish)

(use-package smartparens)

(require 'smartparens-config)

(use-package lsp-mode
  :config (setq lsp-enable-snippet nil)
  (setq gc-cons-threshold 100000000)
  (setq read-process-output-max (* 1024 1024))
  :hook (merlin-mode . lsp)
        (lsp-mode . lsp-lens-mode)
        (scala-mode . lsp)
        (go-mode . lsp)
        (rust-mode . lsp))

(use-package lsp-ui)

(use-package consult-lsp)

;; for some reason this still needs to be added by hand
(use-package lsp-metals)

;; Posframe is a pop-up tool that must be manually installed for dap-mode
(use-package posframe)

(use-package dap-mode
  :hook (lsp-mode . dap-mode)
        (lsp-mode . dap-ui-mode))

(use-package go-mode
  :hook (before-save . gofmt-before-save))

(use-package rust-mode
  :init
  (setq rust-format-on-save t))

(use-package cargo-mode
  :hook
  (rust-mode . cargo-minor-mode))

(use-package zig-mode)

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


;; project management
(defun enable-projectile ()
    "Enable projectile for project management"
  (use-package projectile
    :init
    (setq projectile-enable-caching t)
    :config
    (setq projectile-completion-system 'ido)
    (projectile-mode +1)
    :bind-keymap (("s-p" . projectile-command-map)
                  ("C-c p" . projectile-command-map))))
(if native-project
    (enable-project)
  (enable-projectile))
  
(use-package edit-indirect)

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

(use-package org
  :ensure t
  :config
  (setq org-directory (expand-file-name "~/.org")
        org-default-notes-file (concat org-directory "/notes.org"))
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

(use-package org-kanban)

(use-package ob-go)
(use-package ob-rust)
(require 'ob-scala)
(use-package ob-graphql)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((go . t)
   (graphql . t)
   (shell . t)
   (emacs-lisp . t)
   (scala . t)))

(use-package jinx)

(use-package sly)

;;; configuration.el ends here
