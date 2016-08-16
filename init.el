;; -*- mode: emacs-lisp; -*-
;;

;; package configuration and management
(require 'package)

;; use melpa
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(package-initialize)

(when
    (not package-archive-contents)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-always-ensure t)

(use-package s)                         ;string functions

(use-package exec-path-from-shell
  :init (exec-path-from-shell-initialize))

;; leverage homebrew installs
(setq brew-prefix "/usr/local")

;; packages

(use-package kanban)

(use-package yasnippet
  :diminish yas-mode
  :commands yas-minor-mode
  :config (yas-reload-all))

(use-package projectile
  :pin melpa-stable
  :diminish projectile-mode
  :init
  (setq projectile-completion-system 'ivy)
  (setq projectile-enable-caching t)
  :config
  (projectile-global-mode))

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
  :pin melpa-stable
  :diminish company-mode)

(use-package ivy
  :pin melpa-stable)

(use-package magit
  :commands magit-status magit-blame
  :init
  (setq magit-auto-revert-mode nil)
  (setq magit-last-seen-setup-instructions "1.4.0")
  :bind (("s-g" . magit-status)
         ("s-b" . magit-blame)))

(use-package gh)
(use-package magit-gh-pulls)
(use-package github-notifier)

(use-package expand-region
  :commands 'er/expand-region
  :bind ("C-=" . er/expand-region))

(use-package smartparens
  :diminish
  smartparens-mode
  :init
  (setq sp-interactive-dwim t)
  :config
  (require 'smartparens-config)
  (sp-use-smartparens-bindings)
  (sp-pair "(" ")" :wrap "C-(") ;; how do people live without this?
  (sp-pair "[" "]" :wrap "s-[") ;; C-[ sends ESC
  (sp-pair "{" "}" :wrap "C-{")
  (bind-key "C-<left>" nil smartparens-mode-map)
  (bind-key "C-<right>" nil smartparens-mode-map)

  (bind-key "s-<delete>" 'sp-kill-sexp smartparens-mode-map)
  (bind-key "s-<backspace>" 'sp-backward-kill-sexp smartparens-mode-map))

;; lesser used hence lesser customized stuff
(use-package markdown-mode)
(use-package pandoc-mode)
(use-package find-file-in-project)
(use-package git-timemachine)
(use-package thrift)
(use-package yaml-mode)
(use-package dockerfile-mode
  :mode ("Dockerfile\\'" . dockerfile-mode))

;; org however isn't minor
(use-package org
  :ensure org-plus-contrib
  :init (setq org-log-done t)
  :bind (("\C-cl" . org-store-link)
         ("\C-ca" . org-agenda)))

(use-package org-readme)
(use-package org-pandoc)
(use-package org-elisp-help)
(use-package org-dashboard)
;; hyperbole
(use-package hyperbole)

;; some cranky and insane stuff
(use-package eredis)
(use-package web-server)
(use-package web)
(use-package elnode ;awesome evented io
  :commands elnode-make-webserver)                    

;; erlang etc.
(use-package alchemist)
(use-package edts)
(use-package erlang)
(use-package lfe-mode)

;; various schemes, esp. chicken
(use-package geiser)

;; clojure
(use-package clojure-mode)
(use-package cider)

;; scala
(use-package sbt-mode)
(use-package scala-mode
  :interpreter ("scala" . scala-mode))
(use-package ensime
  :init (put 'ensime-auto-generate-config 'safe-local-variable #'booleanp)
  :config
  (require 'ensime-expand-region)
  (add-hook 'git-timemachine-mode-hook (lambda () (ensime-mode 0))))

(use-package protobuf-mode)

(use-package subword
  :ensure nil
  :diminish subword-mode
  :init (global-subword-mode t))
;; end package management

;; load local elisp
(add-to-list 'load-path (expand-file-name "maven" user-emacs-directory))
;; end environment

;; my normal setup. no tabs, no menu, no scrollbars, no toolbar and
;; pop out compilation and grep windows.
(setq-default indent-tabs-mode nil)
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(put 'narrow-to-region 'disabled nil)
(scroll-bar-mode -1)
(tool-bar-mode -1)
;; (setq special-display-buffer-names '("*compilation*" "*grep*" "*Find*"))
(setq-default debug-on-error nil)
(server-start)

;; make maven work (such as it is)
(require 'maven)

;; load and customize modes
(defcustom
  scala-mode-prettify-symbols
  '(("->" . ?→)
    ("<-" . ?←)
    ("=>" . ?⇒)
    ("<=" . ?≤)
    (">=" . ?≥)
    ("==" . ?≡)
    ("!=" . ?≠)
    ;; implicit https://github.com/chrissimpkins/Hack/issues/214
    ("+-" . ?±))
  "Prettify symbols for scala-mode.")

;;(require 'markdown-mode)
(setq auto-mode-alist  (cons '("\\.md$" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist  (cons '("\\.markdown$" . markdown-mode) auto-mode-alist))

(put 'dired-find-alternate-file 'disabled nil)
;; hook functions. all packages should have been loaded and customized
;; by now

(add-hook 'scala-mode-hook
          (lambda ()
            (setq prettify-symbols-alist scala-mode-prettify-symbols)
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
              (setq company-backends (push '(ensime-company company-yasnippet) backends)))))

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

;; given that I have to work with eclipse users it's the only way to
;; stay sane.
(defun fix-format-buffer ()
  "indent, untabify and remove trailing whitespace for a buffer"
  (interactive)
  (save-excursion
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

(load custom-file)

(setq org-agenda-files (mapcar 'expand-file-name (file-expand-wildcards "~/.org/*.org")))

(setq org-todo-keywords
      '((sequence "TODO(t)" "INPROGRESS(p)" "READY(r)" "BLOCKED(b)" "|" "DONE(d)")))

