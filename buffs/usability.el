;; usability.el -*- lexical-binding: t -*-

;; stackoverflow is an integral part of the coding process. so why
;; leave emacs to search it?
(use-package sx
  :bind (("H-x q" . sx-tab-all-questions)
         ("H-x i" . SX-inbox)
         ("H-x o" . sx-open-link)
         ("H-x u" . sx-tab-unanswered-my-tags)
         ("H-x a" . sx-ask)
         ("H-x s" . sx-search)))

(use-package expand-region
  :commands 'er/expand-region
  :bind ("C-=" . er/expand-region))

;; change word bounderies to include lower case to upper case
;; transitions inside camel cased words.
(use-package subword
  :init (global-subword-mode t))

(use-package popwin)

(use-package memoize)

(use-package all-the-icons)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package ivy
  :diminish
  :bind (("C-c C-r" . ivy-resume)
         ("C-x B" . ivy-switch-buffer-other-window))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  :config (ivy-mode))

(use-package counsel)

(use-package all-the-icons-ivy-rich
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :init (ivy-rich-mode 1))

(provide 'usability)
