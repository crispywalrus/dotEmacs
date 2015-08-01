;; -*- mode: emacs-lisp; -*-
;;
;; crispy's init.el

;; other than my personal code and a very few oddball packages
;; everything elispy comes from elpa/melpa etc. nowadays.
(package-initialize)

;; look in marmalade as well as melpa for packages
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

(install-saved-packages )

(require 's)

;; system specific
;; these are set for OS X with brew
(setq brew-prefix "/usr/local")
(setq seperator ":")

;; customize our environment
(setenv "PATH" (concat
                (concat brew-prefix "/bin")
                (concat seperator (getenv "PATH"))
                (concat seperator brew-prefix "/sbin")
                (concat seperator brew-prefix "/share/npm/bin")))

(add-to-list 'exec-path (concat brew-prefix "/opt/coreutils/libexec/gnubin"))
(add-to-list 'exec-path (concat brew-prefix "/sbin"))
(add-to-list 'exec-path (concat brew-prefix "/bin"))
(add-to-list 'exec-path "/usr/local/share/npm/bin/")
(add-to-list 'exec-path
             (concat
              (s-trim
               (shell-command-to-string "brew --prefix coreutils"))
              "/libexec/gnubin"))
(setenv "JAVA_HOME" (s-trim (shell-command-to-string "/usr/libexec/java_home")))

;; my normal setup. no tabs, no menu, no scrollbars, no toolbar and
;; pop out compilation and grep windows.
(setq-default indent-tabs-mode nil)
(setq inhibit-startup-screen t)
(put 'narrow-to-region 'disabled nil)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(setq special-display-buffer-names '("*compilation*" "*grep*" "*Find*"))
(setq-default debug-on-error nil)
(server-start)

;; my local elisp
(add-to-list 'load-path (expand-file-name "~/.emacs.d/local"))
;; make maven work (such as it is)
(add-to-list 'load-path (expand-file-name "~/.emacs.d/crispy"))
(require 'mvn-foo)
(require 'eshell-foo)

;; load and customize modes

;; protobuffer IDL editing mode
(require 'protobuf-mode)
(setq auto-mode-alist  (cons '("\\.proto$" . protobuf-mode) auto-mode-alist))

;; scala mode plus ensime for ehanced scalating!
(require 'ensime)
(require 'scala-mode2)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

(require 'org-install)

(require 'markdown-mode)
(setq auto-mode-alist  (cons '("\\.md$" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist  (cons '("\\.markdown$" . markdown-mode) auto-mode-alist))

;; edredis give us elisp access to redis
(require 'eredis)

;; docs are good, pandoc is at least simple to use
(require 'pandoc-mode)

;; for elixir 
(require 'alchemist)

;; use projectile 
(projectile-global-mode)
(setq projectile-completion-system 'grizzl)

;; crispy code
(require 's)

;; hook functions. all packages should have been loaded and customized
;; by now

(defun crispy-java-mode-hook ()
  (progn
    (c-set-style "bsd")
    (setq c-basic-offset 4)
    ;; (c-toggle-auto-newline 1)
    (c-set-offset 'substatement-open 0)
    (c-set-offset 'annotation-var-cont 0)))

(add-hook 'java-mode-hook 'crispy-java-mode-hook)

;; ok, this is not much of a function but given that I have to work
;; with eclipse users it's the only way to stay sane.
(defun fix-format-buffer ()
  "indent, untabify and remove trailing whitespace for a buffer"
  (interactive)
  (save-excursion 
    (delete-trailing-whitespace)
    (indent-region (point-min) (point-max))
    (untabify (point-min) (point-max))
    (replace-string "( " "(" nil (point-min) (point-max))
    (replace-string " (" "(" nil (point-min) (point-max))
    (replace-string " )" ")" nil (point-min) (point-max))
    (replace-string " +" "+" nil (point-min) (point-max))
    (replace-string "+ " "+" nil (point-min) (point-max))
    (replace-string " ," "," nil (point-min) (point-max))
    (replace-string ", " "," nil (point-min) (point-max))))
;; end code 

;; auto generted custom stuffs
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#657b83"])
 '(background-color "#002b36")
 '(background-mode dark)
 '(cursor-color "#839496")
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(custom-safe-themes
   (quote
    ("7356632cebc6a11a87bc5fcffaa49bae528026a78637acd03cae57c091afd9b9" "ab04c00a7e48ad784b52f34aa6bfa1e80d0c3fcacc50e1189af3651013eb0d58" "04dd0236a367865e591927a3810f178e8d33c372ad5bfef48b5ce90d4b476481" "2b5aa66b7d5be41b18cc67f3286ae664134b95ccc4a86c9339c886dfd736132d" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "25f330cb050c7e7ec402af1b60243e8185a7837b455af0fa026593d4f48a78b2" "a705d91a43f7fb73751de9e5f901aeaccbf0b55c92c2a4698104befbed2c5074" default)))
 '(diary-entry-marker (quote font-lock-variable-name-face))
 '(elnode-do-init nil)
 '(emms-mode-line-icon-image-cache
   (quote
    (image :type xpm :ascent center :data "/* XPM */
static char *note[] = {
/* width height num_colors chars_per_pixel */
\"    10   11        2            1\",
/* colors */
\". c #1ba1a1\",
\"# c None s None\",
/* pixels */
\"###...####\",
\"###.#...##\",
\"###.###...\",
\"###.#####.\",
\"###.#####.\",
\"#...#####.\",
\"....#####.\",
\"#..######.\",
\"#######...\",
\"######....\",
\"#######..#\" };")))
 '(fci-rule-color "#c7c7c7")
 '(foreground-color "#839496")
 '(gnus-logo-colors (quote ("#4c8383" "#bababa")))
 '(gnus-mode-line-image-cache
   (quote
    (image :type xpm :ascent center :data "/* XPM */
static char *gnus-pointer[] = {
/* width height num_colors chars_per_pixel */
\"    18    13        2            1\",
/* colors */
\". c #1ba1a1\",
\"# c None s None\",
/* pixels */
\"##################\",
\"######..##..######\",
\"#####........#####\",
\"#.##.##..##...####\",
\"#...####.###...##.\",
\"#..###.######.....\",
\"#####.########...#\",
\"###########.######\",
\"####.###.#..######\",
\"######..###.######\",
\"###....####.######\",
\"###..######.######\",
\"###########.######\" };")))
 '(jenkins-api-url "http://f1tst-linbld100.f1tst.rl.com/jenkins/")
 '(org-log-done (quote time))
 '(scala-indent:align-parameters t)
 '(scala-interpreter "/usr/local/bin/scala")
 '(vc-annotate-background "#d4d4d4")
 '(vc-annotate-color-map
   (quote
    ((20 . "#437c7c")
     (40 . "#336c6c")
     (60 . "#205070")
     (80 . "#2f4070")
     (100 . "#1f3060")
     (120 . "#0f2050")
     (140 . "#a080a0")
     (160 . "#806080")
     (180 . "#704d70")
     (200 . "#603a60")
     (220 . "#502750")
     (240 . "#401440")
     (260 . "#6c1f1c")
     (280 . "#935f5c")
     (300 . "#834744")
     (320 . "#732f2c")
     (340 . "#6b400c")
     (360 . "#23733c"))))
 '(vc-annotate-very-old-color "#23733c")
 '(virtualenv-root "~/Development/crispy/pyEnvs"))

;; fix some magit warts
(setq magit-auto-revert-mode nil)
(setq magit-last-seen-setup-instructions "1.4.0")
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
