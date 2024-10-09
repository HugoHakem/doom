;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'modus-vivendi)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq doom-localleader-key ",")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(after! vterm
  (setq vterm-shell "zsh"))
   (map! :map python-mode-map
         :localleader
         :n "z" #'run-python
         "y" #'realgud:pdb
         "f" #'realgud-pdb-pytest

         (:desc "send to REPL" :prefix "s"
                "r" #'python-shell-send-region-or-line
                "b" #'python-shell-send-buffer
                "d" #'python-shell-send-defun))

   (defun python-shell-send-region-or-line nil
     "Sends from python-mode buffer to a python shell, intelligently."
     (interactive)
     (cond ((region-active-p)
            (setq deactivate-mark t)
            (python-shell-send-region (region-beginning) (region-end)))
           (t (python-shell-send-current-statement))))

  (defun python-shell-send-current-statement ()
    "Send current statement to Python shell.
Taken from elpy-shell-send-current-statement"
    (interactive)
    (let ((beg (python-nav-beginning-of-statement))
          (end (python-nav-end-of-statement)))
      (python-shell-send-string (buffer-substring beg end)))
    (python-nav-forward-statement))

(after! code-cells
  (map! :map code-cells-mode-map
        :desc "Navigate to next cell" :n "n" (code-cells-speed-key 'code-cells-forward-cell)
        :desc "Navigate to previous cell" :n "p" (code-cells-speed-key 'code-cells-backward-cell)
        :desc "Eval until this cell" :n "u" (code-cells-speed-key 'code-cells-eval-above)
        :desc "Eval current cell" :n "e" (code-cells-speed-key 'code-cells-eval)
        :n "TAB" (code-cells-speed-key 'outline-cycle)
        :n ";" (code-cells-speed-key 'code-cells-comment-or-uncomment)

        ;; Map additional keys using local-leader to better suit my live-testing
        ;; workflow.
        :localleader
        :desc "eval current cell" :n "e" #'code-cells-eval
        :desc "navigate to previous cell" :n "k" #'code-cells-backward-cell
        :desc "Navigate to next cell" :n "j" #'code-cells-forward-cell
        :desc "Eval until this cell" :n "u" #'code-cells-eval-above))

(setq realgud:pdb-command-name "python -m ipdb")
;; (setq realgud:pdb-command-name "pytest -s --trace")
(defun realgud-pdb-pytest nil
  (interactive)
  (realgud:pdb (concat "pytest --trace --color=yes " buffer-file-name)))

(after! pdb-track
(defface term-color-darkgreen
'((t :foreground "DarkGreen" :background "DarkGreen"))
"Face used to render dark green color code."
:group 'term)
(defface term-color-cadetblue
'((t :foreground "CadetBlue" :background "CadetBAlue"))
"Face used to render dark cadet blue color code."
:group 'term)

(defface term-color-purple
'((t :foreground "Purple" :background "Purple"))
"Face used to render dark Purple color code."
:group 'term)

(defface term-color-darkgoldenrod
'((t :foreground "Darkgoldenrod" :background "Darkgoldenrod"))
"Face used to render dark Darkgoldenrod color code."
:group 'term)

(defface term-color-ivory4
'((t :foreground "Ivory4" :background "Ivory4"))
"Face used to render dark Ivory4 color code."
:group 'term)

(setq ansi-term-color-vector
[term
term-color-black
term-color-red
term-color-darkgreen
term-color-cadetblue
term-color-blue
term-color-purple
term-color-darkgoldenrod
term-color-ivory4]))

(defun dired-copy-filepath-as-kill ()
  (interactive)
  (dired-copy-filename-as-kill 0))
(map! :map dired-mode-map :localleader :n "y" #'dired-copy-filepath-as-kill)
(map! :map evil-normal-state-map "g C" #'evilnc-copy-and-comment-lines)

   (map! :map python-mode-map
         :localleader
         :n "z" #'run-python
         ;; "y" #'realgud:pdb
         ;; "f" #'realgud-pdb-pytest

         (:desc "send to REPL" :prefix "s"
                "r" #'python-shell-send-region-or-line
                "b" #'python-shell-send-buffer
                "d" #'python-shell-send-defun))

   (defun python-shell-send-region-or-line nil
     "Sends from python-mode buffer to a python shell, intelligently."
     (interactive)
     (cond ((region-active-p)
            (setq deactivate-mark t)
            (python-shell-send-region (region-beginning) (region-end)))
           (t (python-shell-send-current-statement))))

(clipetty-mode 1)
(xterm-mouse-mode 1)
(setq httpd-port 9377)

(envrc-global-mode)
