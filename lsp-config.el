;;; lsp-config.el --- emacs configuration -*- lexical-binding: t -*-

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

;; Configure lsp and all the enhancements that I desire and configure
;; them for default setup

;;; Code:

(use-package lsp-mode
  :config (setq lsp-enable-snippet nil)
  (setq gc-cons-threshold 100000000)
  (setq read-process-output-max (* 1024 1024))
  :hook (lsp-mode . lsp-lens-mode))

(use-package lsp-ui)

(use-package consult-lsp)

;; for some reason this still needs to be added by hand
(use-package lsp-metals)

;; Posframe is a pop-up tool that must be manually installed for dap-mode
(use-package posframe)

(use-package dap-mode
  :hook (lsp-mode . dap-mode)
        (lsp-mode . dap-ui-mode))

;;; lsp-config.el ends here
