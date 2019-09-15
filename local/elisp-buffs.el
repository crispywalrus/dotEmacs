;; elisp.el elisp programming add ons and customizations -*- lexical-binding: t -*- 
;;
(use-package s)
(use-package string-inflection
  :bind ("s-i" . string-inflection-all-cycle))
(use-package dash)
(use-package dash-functional)
(use-package m-buffer)
(use-package f)
(use-package multiple-cursors)
(use-package suggest)

(provide 'elisp-buffs)
