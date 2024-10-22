;;; project-config.el --- use and configure projectile project management -*- lexical-binding: t -*-

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
  :config
  (projectile-mode t)
  (setq projectile-project-search-path '("~/Documents/GitHub/"))
  :bind
  (:map projectile-mode-map
              ("s-p" . projectile-command-map)))

(use-package org-projectile
  :after projectile
  :bind
  (:map projectile-command-map
        ("n" . org-project-capture-project-todo-completing-read))
  :config
  (setq org-project-capture-default-backend (make-instance 'org-project-capture-projectile-backend)
        org-project-capture-strategy (make-instance 'org-project-capture-per-project-strategy)
        org-project-capture-per-project-filepath "TODO.org")
  (org-project-capture-per-project))

(provide 'projectile-config)
;;; projectile-config.el ends here
