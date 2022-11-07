;;; eshell-visual-vterm.el --- Use vterm for eshell visual commands -*- lexical-binding: t; -*-

;; Copyright (C) 2022 Archit Gupta

;; Version: 1.0.0
;; Author: Archit Gupta <archit@accelbread.com>
;; Maintainer: Archit Gupta <archit@accelbread.com>
;; URL: https://github.com/accelbread/eshell-visual-vterm
;; Keywords: eshell, vterm
;; Package-Requires: ((emacs "28.1") (vterm "0.0.1") (inheritenv "0.1"))

;; This file is not part of GNU Emacs

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package advises eshell functions such that `vterm-mode' will be used
;; instead of `term-mode'.
;;
;; To enable, add (eshell-visual-vterm-mode) to your init.el.

;;; Code:

(require 'em-term)
(require 'vterm)
(require 'inheritenv)

;;;###autoload
(define-minor-mode eshell-visual-vterm-mode
  "Advise eshell to use vterm for visual commands."
  :global t
  :group 'eshell-visual-vterm
  (if eshell-visual-vterm-mode
      (progn (advice-add
              #'eshell-exec-visual :around
              (lambda (orig-fun &rest args)
                "Advise `eshell-exec-visual' to use vterm."
                (cl-letf (((symbol-function #'term-mode) #'ignore)
                          ((symbol-function #'term-exec)
                           (lambda (_ _ program _ args)
                             (let ((vterm-shell
                                    (mapconcat #'shell-quote-argument
                                               (cons (file-local-name program)
                                                     args)
                                               " "))
                                   (vterm-buffer-name "*eshell-visual*"))
                               (vterm-mode))))
                          ((symbol-function #'term-char-mode) #'ignore)
                          ((symbol-function #'term-set-escape-char) #'ignore))
                  (apply #'inheritenv-apply orig-fun args)))
              '((name . eshell-visual-vterm)))
             (advice-add
              #'eshell-term-sentinel :around
              (lambda (orig-fun &rest args)
                "Advise `eshell-term-sentinel' to use vterm."
                (cl-letf ((vterm-kill-buffer-on-exit nil)
                          ((symbol-function #'term-sentinel) #'vterm--sentinel))
                  (apply orig-fun args)))
              '((name . eshell-visual-vterm))))
    (advice-remove #'eshell-exec-visual 'eshell-visual-vterm)
    (advice-remove #'eshell-term-sentinel 'eshell-visual-vterm)))

(provide 'eshell-visual-vterm)
;;; eshell-visual-vterm.el ends here
