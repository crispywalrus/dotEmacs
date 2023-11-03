;;; projectile-config.el --- use and configure projectile project management -*- lexical-binding: t -*-

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

;; load various Emacs extensions that make my life easier and more productive.

;;; Code:

(use-package projectile
  :init
  (setq projectile-enable-caching t)
  :config
  (setq projectile-completion-system 'default)
  (projectile-mode +1)
  :bind-keymap (("s-p" . projectile-command-map)
                ("C-c p" . projectile-command-map)))

(use-package go-projectile
  :ensure t
  :after (projectile))

(provide 'projectile-config)
;;; projectile-config.el ends here
