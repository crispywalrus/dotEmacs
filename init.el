;;; init.el --- emacs configuration -*- lexical-binding: t -*-

;; Copyright © 2011 - 2017 Chris Vale
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

;; Configuration.

;;; Code:


(require 'package)

;; use melpa
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(package-initialize)

;; is use-package isn't installed yet go ahead and make it available.
(when
    (not package-archive-contents)
  (package-refresh-contents)
  (package-install 'use-package))

;; quelpa is something of a competitor to how use-package
;; works. instead of relying on melpa to build new versions it pulls
;; directly (usually) from the source repo and builds
;; locally. quelpa-use-package adds a 'virtual' package archive to
;; use-package the resolves down to quelpa proper.
(use-package quelpa)
(use-package quelpa-use-package)

;; packages
;; loads key-chord and adds a :chord symbol for use-package.
(use-package use-package-chords
  :config (key-chord-mode 1))

;; these next packages don't describe modes or features rather they're
;; packages of elisp function designed to make coding better.  Do this
;; here so that we can be sure they'll be available for local code.
(use-package s)
(use-package string-inflection
  :bind ("s-i" . string-inflection-all-cycle))
(use-package dash)
(use-package dash-functional)
(use-package m-buffer)
(use-package f
  :ensure t)
(use-package multiple-cursors)

;; no tabs, no menu, no scrollbars, no toolbar, no scratch buffer message, no startup screen.
(f-touch (expand-file-name "custom.el" user-emacs-directory))

(setq-default indent-tabs-mode nil)

(setq
 use-package-always-ensure t
 inhibit-startup-screen t
 initial-scratch-message nil
 custom-file (expand-file-name "custom.el" user-emacs-directory)
 load-prefer-newer t
 debug-on-error nil)

(load custom-file)
(put 'narrow-to-region 'disabled nil)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(windmove-default-keybindings)
(server-start)

(when (eq system-type 'darwin)
  (setq ns-use-native-fullscreen nil))
;; end defaults

;; packages
;; functionality follows
(use-package exec-path-from-shell
  :init (exec-path-from-shell-initialize))


(use-package yasnippet
  :pin melpa-stable
  :diminish yas-mode
  :commands yas-minor-mode
  :config (yas-reload-all))

(use-package desktop+)

(use-package projectile
  :diminish projectile-mode
  :init
  (setq projectile-completion-system 'ivy)
  (setq projectile-enable-caching t)
  :config
  (projectile-mode))

;; stackoverflow is great but why leave emacs to search it?
(use-package sx
  :init (require 'bind-key)
  :config
  (bind-keys
   :prefix "C-c s"
   :prefix-map my-sx-map
   :prefix-docstring "Global keymap for SX."
   ("q" . sx-tab-all-questions)
   ("i" . sx-inbox)
   ("o" . sx-open-link)
   ("u" . sx-tab-unanswered-my-tags)
   ("a" . sx-ask)
   ("s" . sx-search)))

(use-package company
  :diminish company-mode)

(use-package ivy
  :pin melpa-stable
  :bind
  (:map ivy-mode-map
        ("C-'" . ivy-avy))
  :diminish (ivy-mode . "")
  :config
  ;; (ivy-mode 1)
  ;; add ‘recentf-mode’ and bookmarks to ‘ivy-switch-buffer’.
  (setq ivy-use-virtual-buffers t)
  ;; number of result lines to display
  (setq ivy-height 10)
  ;; does not count candidates
  (setq ivy-count-format "")
  ;; no regexp by default
  (setq ivy-initial-inputs-alist nil)
  ;; configure regexp engine.
  (setq ivy-re-builders-alist
        ;; allow input not in order
        '((t   . ivy--regex-ignore-order))))

(use-package suggest)

(use-package with-editor
  :pin melpa-stable)

(use-package git-commit
  :pin melpa-stable)

(use-package magit-popup
  :pin melpa-stable)

(use-package magit
  :pin melpa-stable
  :commands magit-status magit-blame
  :init
  (setq magit-auto-revert-mode nil
        magit-last-seen-setup-instructions "1.4.0")
  :bind (("s-g" . magit-status)
         ("s-b" . magit-blame)))

(use-package magit-find-file
  :pin melpa-stable
  :bind (("s-f" . magit-find-file-completing-read)))

(use-package git-timemachine)

(use-package expand-region
  :commands 'er/expand-region
  :bind ("C-=" . er/expand-region))

(use-package smartparens
  :pin melpa-stable
  :diminish
  smartparens-mode
  :init
  (setq sp-interactive-dwim t)
  :config
  (require 'smartparens-config)
  (sp-use-smartparens-bindings)
  (sp-pair "(" ")" :wrap "s-(") ;; how do people live without this?
  (sp-pair "[" "]" :wrap "s-[") ;; C-[ sends ESC
  (sp-pair "{" "}" :wrap "s-{")
  (bind-key "C-<left>" nil smartparens-mode-map)
  (bind-key "C-<right>" nil smartparens-mode-map)

  (bind-key "s-<delete>" 'sp-kill-sexp smartparens-mode-map)
  (bind-key "s-<backspace>" 'sp-backward-kill-sexp smartparens-mode-map))

;; lesser used hence lesser customized stuff
(use-package markdown-mode
  :pin melpa-stable
  :init
  (setq auto-mode-alist  (cons '("\\.md$" . markdown-mode) auto-mode-alist))
  (setq auto-mode-alist  (cons '("\\.markdown$" . markdown-mode) auto-mode-alist)))

(use-package pandoc-mode)

(use-package thrift)

(use-package yaml-mode)

(use-package dockerfile-mode
  :mode ("Dockerfile\\'" . dockerfile-mode))

;; omg, org mode ends up eating the world!
(use-package org
  :ensure t
  :init
  (setq org-log-done t)
  (setq org-directory (expand-file-name "~/.org"))
  (setq org-default-notes-file (concat org-directory "~/main.org"))
  (setq org-agenda-files (mapcar 'expand-file-name (file-expand-wildcards "~/.org/agenda.org")))
  (setq org-todo-keywords
        '((sequence "TODO(t)" "READY(r)" "INPROGRESS(p)" "BLOCKED(b)" "DONE(d)")
          (sequence "IDEATE" "REFINE" "DOCUMENT" "PROMOTED")))
  :bind (("\C-cl" . org-store-link)
         ("\C-ca" . org-agenda)
         ("\C-cc" . org-capture)))

(use-package kanban)
(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package org-readme)
(use-package org-bullets)
(use-package org-elisp-help)
(use-package org-dashboard)

;; the ox mode name denotes an org exporter
(use-package ox-pandoc)
(use-package ox-reveal)

;; some cranky and insane stuff
(use-package eredis)
(use-package web-server)
(use-package web)
(use-package elnode ;awesome evented io
  :commands elnode-make-webserver)

;; scala
(use-package sbt-mode
  :pin melpa-stable
  :commands sbt-start sbt-command
  :init (setq sbt:prefer-nested-projects t))

(use-package scala-mode
  :pin melpa-stable
  :chords (("=." . "⇒")
           ("-," . "←")
           ("-." . "→"))
  :interpreter ("scala" . scala-mode))

(use-package popup
  :pin melpa-stable)

(use-package ensime
  :pin melpa-stable
  :init
  (put 'ensime-auto-generate-config 'safe-local-variable #'booleanp)
  (setq
   ensime-startup-snapshot-notification nil
   ensime-startup-notification nil)
  :config
  (require 'ensime-expand-region)
  (add-hook 'git-timemachine-mode-hook (lambda () (ensime-mode 0))))

(use-package protobuf-mode)

(use-package utop)

;; javascript
(use-package indium)

;; change word bounderies to include lower case to upper case
;; transitions, as in camel cased words
(use-package subword
  :ensure nil
  :diminish subword-mode
  :init (global-subword-mode t))

(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode)
  :diminish undo-tree)

(use-package popwin)

;; window/frame management
(use-package e2wm
  :pin melpa-stable
  :ensure t)

(use-package eyebrowse
  :ensure t
  :config
  (eyebrowse-mode))
  
;; end package management

;; packs are packages of packages and utility functions
(add-to-list 'load-path (expand-file-name "packs" user-emacs-directory))

;; we jump out of our happy use-package mode to explicitly enable
;; reason mode which hasn't been published as of yet. this means
;; there's a checked in version in coding ... :(
(require 'reason-pack)
(add-hook 'reason-mode-hook (lambda ()
                              (add-hook 'before-save-hook 'refmt-before-save)
                              (merlin-mode)))


;; load clojure pack
(require 'clojure-pack)

;; make maven work (such as it is)
(require 'maven-pack)

;; common lisp
(require 'common-lisp)

;; end packs

;; theme management
;; (use-package paganini-theme)

;; end themes
(put 'dired-find-alternate-file 'disabled nil)
;; hook functions. all packages should have been loaded and customized
;; by now

(global-prettify-symbols-mode)

(add-hook 'scala-mode-hook
          (lambda ()
            (setq prettify-symbols-alist scala-prettify-symbols-alist)
            (smartparens-mode t)))

(add-hook 'java-mode-hook
          (lambda ()
            (c-set-style "bsd")
            (setq c-basic-offset 4)
            ;; (c-toggle-auto-newline 1)
            (c-set-offset 'substatement-open 0)
            (c-set-offset 'annotation-var-cont 0)))

(add-hook 'ensime-mode-hook
          (lambda ()
            (let ((backends (company-backends-for-buffer)))
              (setq company-backends
                    (push '(ensime-company company-yasnippet) backends)))))


;; start code
(defun company-backends-for-buffer ()
  "Calculate appropriate `company-backends' for the buffer.
For small projects, use TAGS for completions, otherwise use a
very minimal set."
  (projectile-visit-project-tags-table)
  (cl-flet ((size () (buffer-size (get-file-buffer tags-file-name))))
    (let ((base '(company-keywords company-dabbrev-code company-yasnippet)))
      (if (and tags-file-name (<= 20000000 (size)))
          (list (push 'company-etags base))
        (list base)))))

;; given that I have to work with eclipse and intellij users
(defun fix-format-buffer ()
  "indent, untabify and remove trailing whitespace for a buffer"
  (interactive)
  (save-mark-and-excursion
    (delete-trailing-whitespace)
    (indent-region (point-min) (point-max))
    (untabify (point-min) (point-max))))

(defun contextual-backspace ()
  "Hungry whitespace or delete word depending on context."
  (interactive)
  (if (looking-back "[[:space:]\n]\\{2,\\}" (- (point) 2))
      (while (looking-back "[[:space:]\n]" (- (point) 1))
        (delete-char -1))
    (cond
     ((and (boundp 'smartparens-strict-mode)
           smartparens-strict-mode)
      (sp-backward-kill-word 1))
     ((and (boundp 'subword-mode)
           subword-mode)
      (subword-backward-kill 1))
     (t
      (backward-kill-word 1)))))

(global-set-key (kbd "C-<backspace>") 'contextual-backspace)

(require 'esh-mode)
(defun eshell-here()
  "Opens up a new shell in the directory associated with the
current buffer's file. The eshell is renamed to match that
directory to make multiple eshell windows easier."
  (interactive)
  (let*((parent(if(buffer-file-name)
                   (file-name-directory(buffer-file-name))
                 default-directory))
        (height(/(window-total-height) 3))
        (name  (car(last(split-string parent "/" t)))))
    (split-window-vertically(- height))
    (other-window 1)
    (eshell "new")
    (rename-buffer(concat "*eshell: " name "*"))

    (insert(concat "ls"))
    (eshell-send-input)))

(global-set-key(kbd "C-!") 'eshell-here)
;; end code
