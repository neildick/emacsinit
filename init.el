
;; Configure the c/c++ formatting
(require 'cc-mode)
(require 'linum)
;; Turn off the damn beeping
(setq ring-bell-function 'ignore)

;; set the ispell directory on windows
(setq ispell-program-name "aspell")

; use c style comments in c++
(add-hook 'c++-mode-hook (lambda ()
                           (setq comment-start "/* " comment-end " */")))




;; try to improve slow performance on windows.
(setq w32-get-true-file-attributes nil)


;; (defun vhdl-align-region-2 (begin end match &optional substr spacing)
;;   "Align a range of lines from BEGIN to END.  The regular expression
;; MATCH must match exactly one field: the whitespace to be
;; contracted/expanded.  The alignment column will equal the
;; rightmost column of the widest whitespace block.  SPACING is
;; the amount of extra spaces to add to the calculated maximum required.
;; SPACING defaults to 1 so that at least one space is inserted after
;; the token in MATCH."
;;   (message "%s" begin)
;;   (message "%s" end)
;;   (setq spacing (or spacing 1))
;;   (setq substr (or substr 1))
;;   (save-excursion
;;     (let (distance (max 0) (lines 0) bol eol width)
;;       ;; Determine the greatest whitespace distance to the alignment
;;       ;; character
;;       (goto-char begin)
;;       (setq eol (point-at-eol)
;; 	    bol (setq begin (progn (beginning-of-line) (point))))

;;       (while (< bol end)
;; 	(save-excursion
;; 	  (when (and (vhdl-re-search-forward match eol t)
;; 		     (save-excursion
;; 		       (goto-char (match-beginning 0))
;; 		       (forward-char)
;; 		       (and (not (vhdl-in-literal))
;; 			    (not (vhdl-in-quote-p))
;; 			    (not (vhdl-in-extended-identifier-p))))
;; 		     (not (looking-at "\\s-*$")))
;; 	    (setq distance (- (match-beginning substr) bol))
;; 	    (when (> distance max)
;; 	      (setq max distance))))
;; 	(forward-line)
;; 	(setq bol (point)
;; 	      eol (point-at-eol))
;; 	(setq lines (1+ lines)))

;;       ;; ND - HACK try to conform to midas style guide
;;       (when (< max 30)
;; 	(setq max 29))
;;       ;; Now insert enough maxs to push each assignment operator to
;;       ;; the same column.  We need to use 'lines' as a counter, since
;;       ;; the location of the mark may change
;;       (goto-char (setq bol begin))
;;       (setq eol (point-at-eol))
;;       (while (> lines 0)
;;   	(when (and (vhdl-re-search-forward match eol t)
;; 		   (save-excursion
;; 		     (goto-char (match-beginning 0))
;; 		     (forward-char)
;; 		     (and (not (vhdl-in-literal))
;; 			  (not (vhdl-in-quote-p))
;; 			  (not (vhdl-in-extended-identifier-p))))
;; 		   (not (looking-at "\\s-*$"))
;; 		   (> (match-beginning 0)  ; not if at boi
;; 		      (save-excursion (back-to-indentation) (point))))
;; 	  (setq width (- (match-end substr) (match-beginning substr)))
;; 	  (setq distance (- (match-beginning substr) bol))
;; 	  (goto-char (match-beginning substr))
;; 	  (delete-char width)
;; 	  (insert-char ?  (+ (- max distance) spacing)))
;; 	(beginning-of-line)
;; 	(forward-line)
;; 	(setq bol (point)
;; 	      eol (point-at-eol))
;; 	(setq lines (1- lines))))))

;; Look at the file path and apply linux style if contains 'linux'
(defun apply-linux-style ()
  (progn
    (c-set-style "Linux")
    (setq tab-width 8)
    (setq c-basic-offset 8)
    (setq indent-tabs-mode t)
    (c-set-offset 'arglist-intro '++)
    (c-set-offset 'arglist-cont-nonempty 'c-lineup-arglist)
    (setq comment-style 'extra-line)))
(defun apply-my-style ()
  (progn
    (setq c-set-style "linux")
    (setq c-basic-offset 4)
    (setq tab-width 4)
    (setq-default tab-width 4)
    (setq-default indent-tabs-mode nil)
    (c-set-offset 'arglist-intro '++)
    ;; indent case statements properly
    ;; (c-set-offset 'case-label '+)
    ;; ok-labs style function alignment
    (c-set-offset 'arglist-cont-nonempty '++)))

;; If the filepath has 'linux' in it, use linux style
(defun maybe-linux-style ()
  (if (and buffer-file-name
           (string-match "CID660" buffer-file-name))
      (apply-linux-style)
    (apply-my-style)))
(add-hook 'c-mode-hook 'maybe-linux-style)
(add-hook 'c++-mode-hook 'maybe-linux-style)

;; neat tab complete
;; (defun indent-or-expand (arg)
;;   "Either indent according to mode, or expand the word preceding
;; point."
;;   (interactive "*P")
;;   (if (and
;;        (or (bobp) (= ?w (char-syntax (char-before))))
;;        (or (eobp) (not (= ?w (char-syntax (char-after))))))
;;       (dabbrev-expand arg)
;;     (indent-according-to-mode)))

;; (defun my-tab-fix ()
;;   (local-set-key [tab] 'indent-or-expand))
 
;; (add-hook 'c-mode-hook       'my-tab-fix)
;; (add-hook 'c++-mode-hook     'my-tab-fix)
;; (add-hook 'python-mode-hook  'my-tab-fix)


(require 'whitespace)
;; show whitespace in shell files
(add-hook 'sh-mode-hook
          (lambda()
            (setq show-trailing-whitespace t)))

;; vhdl formatting
(add-hook 'vhdl-mode-hook
	  (lambda ()
	    (setq-default vhdl-basic-offset 2)
	    (setq show-trailing-whitespace t)
	    (setq whitespace-line-column 80)
	    (setq-default indent-tabs-mode-nil)))

;; setup whitespace highlighting
(add-hook 'vhdl-mode-hook
	  (lambda ()
	    (setq whitespace-style '(face lines-tail tabs tab-mark))
	    (whitespace-mode t)))
;; only enable linum mode in vhdl files
(add-hook 'vhdl-mode-hook #'linum-on)

;; run the vhdl beautifier on save
;; note this removes undo information for some reason :(
;; (defun beautify-vhdl()
;;   (when (eq major-mode 'vhdl-mode)
;;     (vhdl-beautify-buffer)))
;; (add-hook 'before-save-hook #'beautify-vhdl)

;; better xml formattting
(add-hook 'nxml-mode-hook
	  (lambda()
	    (setq show-trailing-whitespace t)
	    (setq-default tab-width 4)
        (setq sgml-basic-offset 4)
        (setq-default sgml-basic-offset 4)
        (setq tab-width 4)
	    (setq-default indent-tabs-mode nil)))

;; Python whitespace
(add-hook 'python-mode-hook
          (lambda () (setq show-trailing-whitespace t)))
(add-hook 'python-mode-hook
          (lambda ()
            (setq whitespace-style '(face lines-tail))
            (whitespace-mode t)))


(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line


;; Deal with pesky whitespace
(add-hook 'c-mode-hook
          (lambda () (setq show-trailing-whitespace t)))
(add-hook 'c++-mode-hook
          (lambda () (setq show-trailing-whitespace t)))

;; highlight over 80
(add-hook 'c-mode-hook
          (lambda ()
            (setq whitespace-style '(face lines-tail tabs tab-mark))
            (whitespace-mode t)))
(add-hook 'c++-mode-hook
          (lambda ()
            (setq whitespace-style '(face lines-tail tabs tab-mark))
            (whitespace-mode t)))


;; better enter key behaviour
(define-key global-map (kbd "RET") 'newline-and-indent)

;; org mode
(setq org-agenda-include-diary t)

;; Spell check git commit messages
(add-hook 'git-commit-setup-hook
          (lambda ()
            (git-commit-turn-on-flyspell)))

;; gui font
(set-face-attribute 'default nil :font "Hack 10")


;; Avy for jumping around visible characters
(define-key global-map (kbd "C-;") 'avy-goto-char)
(define-key global-map (kbd "C-c C-SPC") 'avy-goto-line)
(define-key global-map (kbd "C-c C-;") 'avy-kill-region)
;; Set global linenum and hl-line mode
;; (global-linum-mode 1)
;; (global-hl-line-mode 1)

;; auto enter matching parens
(electric-pair-mode 1)
(setq electric-pair-inhibit-predicate 'electric-pair-conservative-inhibit)

;; Save a desktop session!!
;;(desktop-save-mode 1)

;; Prompt on exit
(setq confirm-kill-emacs 'yes-or-no-p)

;; Ivy mode!
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key (kbd "M-s o") 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-rg)
(global-set-key (kbd "C-c C-k") 'rg-file)
(global-set-key (kbd "C-x l") 'counsel-locate)
(define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
(define-key ivy-minibuffer-map (kbd "TAB") 'ivy-call)
;; increase the popup window height
(setq ivy-height 25)
(setq ivy-count-format "")



;; custom rg wrapper for searching for vhdl
(defun rg-vhdl ()
    (interactive)
    (counsel-rg nil nil "--type vhdl" "rg-vhdl"))

;; custom wrapper for searching for a certain file type
(defun rg-file ()
  (interactive)
  (let ((file-type (read-string "File type ")))
    (counsel-rg
     nil
     nil
     (format "--type %s" file-type)
     (format "rg-%s" file-type))))

;; provide all the options
(defun rg-generic ()
  (interactive)
  (let ((file-type (read-string "Options ")))
    (counsel-rg
     nil
     nil
     (format "%s" file-type)
     "rg-generic")))

;; Show the filepath of the current buffer, pretty handy
(defun display-name-of-file ()
  (interactive)
  (message (buffer-file-name)))

(global-set-key (kbd "C-c b") 'display-name-of-file)
(global-set-key (kbd "M-z") 'avy-zap-up-to-char)
(global-set-key (kbd "<f5>") 'magit-status)

;;(global-set-key (kbd "<f2>") 'other-window)
(global-set-key (kbd "<f2>") 'ace-window)
(global-set-key (kbd "M-o") 'ace-window)

;; automatically balance windows when splitting
(defun auto-balance-windows ()
  (interactive)
  (split-window-right)
  (balance-windows))

(defun close-auto-balance ()
  (interactive)
  (delete-window)
  (balance-windows))

;; automatically balance the windows when splitting vertically (more like vim)
(global-set-key (kbd "C-x 3") 'auto-balance-windows)
(global-set-key (kbd "C-x 0") 'close-auto-balance)

;; Function to calculate memory offsets,
;; base - base address
;; size - partition size in Mb
(defun calc-mem (base size)
    (+ base (* 1024 1024 size)))


;; Copy the whole line if nothing is selected
(defun my-kill-ring-save (beg end)
  (interactive (if (use-region-p)
		   (list (region-beginning) (region-end))
		 (list (line-beginning-position) (line-beginning-position 2))))
  (kill-ring-save beg end))
(global-set-key [remap kill-ring-save] 'my-kill-ring-save)

;; unbind control z to stop accidentally exiting emacs
;;(global-unset-key (kbd "C-z"))

(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;;(set-terminal-parameter nil 'background-mode 'light)


;; Mouse and clipboard support
(setq select-enable-clipboard t)
(setq select-enable-primary t)

(require 'moe-theme)
(moe-dark)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("a5956ec25b719bf325e847864e16578c61d8af3e8a3d95f60f9040d02497e408" default)))
 '(package-selected-packages
   (quote
    (avy-zap ace-window ivy-hydra ninja-mode gruvbox-theme evil wgrep rust-mode zzz-to-char moe-theme magit counsel ace-jump-mode)))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
