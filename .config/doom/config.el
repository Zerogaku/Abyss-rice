(setq user-full-name "Wim Veto"
      user-mail-address "wimveto@gmail.com")

(setq doom-font (font-spec :family "JetBrainsMono NF" :size 15))

(setq doom-theme 'doom-moonlight)

(setq display-line-numbers-type 'relative)

(add-to-list 'default-frame-alist '(alpha-background . 95))

(setq bookmark-default-file "~/.config/doom/bookmarks")

(setq projectile-project-search-path '("~/Code/web/"))

(setq doom-modeline-bar-width 5)
;; (display-battery-mode 1)
;; (setq doom-modeline-battery t)
;; (display-time-mode 1)
;; (setq display-time-format "%Y %b %d (%a) %R %p")
;; (setq doom-modeline-time t)
(setq doom-modeline-height 30)

(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))

(map! :leader
      :prefix ("w" . "window")
      :desc "writeroom mode" "M-w" #'writeroom-mode)

(setq org-roam-directory "~/Org/roam/mindmap")

(setq zettlekasten-paths-alist '(("Main" . "~/Org/roam/mindmap")
                                 ("Noosphere" . "~/Org/roam/stories/noosphere")))

(defun my/switch-zettlekasten ()
  (interactive)
  (let* ((keys (mapcar #'car zettlekasten-paths-alist))
         (prompt (format "Select Zettlekasten:"))
         (key (completing-read prompt keys))
         (chosen-zettlekasten-path (cdr (assoc key zettlekasten-paths-alist))))
    (setq org-roam-directory chosen-zettlekasten-path)
    (setq org-roam-db-location (file-name-concat chosen-zettlekasten-path "org-roam.db"))
    (org-roam-db-sync)))

(defun my/print-org-roam-directory ()
  "Print the value of org-roam-directory to the minibuffer."
  (interactive)
  (message "org-roam-directory: %s" org-roam-directory))

(map! :leader
    :prefix ("n" . "notes")
    (:prefix ("r" . "roam")
     :desc "Switch to an Org Roam database" "S" #'my/switch-zettlekasten
     :desc "Open Org Roam UI" "o" #'org-roam-ui-open
     :desc "Print current Org Roam directory" "v" #'my/print-org-roam-directory))

(use-package! websocket
    :after org-roam)
(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(after! org
  (setq org-agenda-files
        '("~/Org/agenda/agenda.org")))

(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(use-package! evil-org
  :config
  (map! :map evil-org-mode-map
        :i "C-k" #'evil-insert-digraph))

(setq highlight-indent-guides-method 'column)
(setq highlight-indent-guides-responsive 'top)

(map! :after web-mode
      :map emmet-mode-keymap
      :i
      "<tab>" #'emmet-expand-line)

(setq web-mode-enable-current-element-highlight t)
