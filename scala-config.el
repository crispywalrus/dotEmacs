;;; scala-config.el --- emacs configuration -*- lexical-binding: t -*-

;; Copyright ©  2023 Chris Vale
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

;; A standalone configuration file for programming in Scala.

;;; Code:

(require 'lsp-config)

;; To use lsp with scala this needs to be added by hand
(use-package lsp-metals)

(use-package sbt-mode
  :init (setq sbt:prefer-nested-projects t)
  :commands sbt-start sbt-command sbt-hydra
  :config (substitute-key-definition
           'minibuffer-complete-word
           'self-insert-command
           minibuffer-local-completion-map))

(use-package scala-mode
  :config
  (require 'scala-mode-prettify-symbols)
  (setq prettify-symbols-alist scala-prettify-symbols-alist)
  :hook (company-mode smartparens-mode subword-mode lsp-mode)
  :bind
  ("C-c C-b" . sbt-hydra)
  :interpreter
  ("scala" . scala-mode))

;;; scala-config.el ends here
