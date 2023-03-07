;;; early-init.el --- emacs configuration -*- lexical-binding: t -*-

;; Copyright © 2022 Chris Vale
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

;;; Code:

;; the effectively disables gc so it must be paired with the
;; after-init-hook lambda to set it back to some reasonable value or
;; else we're going to become very unhappy
(setq gc-cons-threshold most-positive-fixnum)

;; set gc threshold to 8Mb after initialization is complete
(add-hook 'after-init-hook (lambda ()
                             (setq gc-cons-threshold (* 8 1024 1024))))

(setq read-process-output-max (* 1024 1024))

;;; early-init.el ends here
