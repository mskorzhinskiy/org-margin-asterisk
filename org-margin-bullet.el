;;; org-margin-bullet.el --- draw org-mode bullets on margin -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Mikhail Skorzhisnkii
;;
;; Author: Mikhail Skorzhisnkii <https://github.com/rasmi>
;; Maintainer: Mikhail Skorzhisnkii <mskorzhinskiy@eml.cc>
;; Created: March 06, 2021
;; Modified: March 06, 2021
;; Version: 0.0.1
;; Keywords: Symbol’s value as variable is void: finder-known-keywords
;; Homepage: https://github.com/rasmi/org-margin-bullet
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  draw org-mode bullets on margin
;;
;;; Code:

(require 'org)
(require 'org-indent)

(defcustom org-margin-bullet-indentation-char ?\s
  "Symbol to use as an indentation."
  :type 'string
  :group 'org-indent)

(defcustom org-margin-bullet-char ?*
  "Symbol to use as a bullet asterisk."
  :type 'string
  :group 'org-indent)

(defcustom org-margin-bullet-indent 4
  "Horizontal indentation level."
  :type 'integer
  :group 'org-indent)

(defface org-margin-bullet-face
  '((t (:weight bold :inherit fixed-pitch)))
  "Face used for margins and bullet characters."
  :group 'org-indent)

(defun org-margin-bullet-make-a-string (n char)
  "Make a string of N CHARs with a propert face."
  (propertize (make-string n char)
              'face 'org-margin-bullet-face))

(defun org-margin-bullet-compute-prefixes ()
  "Compute prefix strings for regular text and headlines."
  (setq org-indent--heading-line-prefixes
        (make-vector org-indent--deepest-level nil))
  (setq org-indent--inlinetask-line-prefixes
        (make-vector org-indent--deepest-level nil))
  (setq org-indent--text-line-prefixes
        (make-vector org-indent--deepest-level nil))
  (dotimes (n org-indent--deepest-level)
    (aset org-indent--heading-line-prefixes n
          (concat
           (org-margin-bullet-make-a-string
            org-margin-bullet-indent
            org-margin-bullet-indentation-char)
           (org-margin-bullet-make-a-string
            n
            org-margin-bullet-char)
           (org-margin-bullet-make-a-string
            (max 0 (- org-margin-bullet-indent n))
            org-margin-bullet-indentation-char)))
    (aset org-indent--inlinetask-line-prefixes n
          (org-margin-bullet-make-a-string
           org-margin-bullet-indent
           org-margin-bullet-indentation-char))
    (aset org-indent--text-line-prefixes n
          (org-margin-bullet-make-a-string
           org-margin-bullet-indent
           org-margin-bullet-indentation-char))))

;;;###autoload
(defun org-margin-bullet-load ()
  "Install margin bullet advice."
  (advice-add #'org-indent--compute-prefixes
              :override
              #'org-margin-bullet-compute-prefixes))

;;;###autoload
(defun org-margin-bullet-unload ()
  "Install margin bullet advice."
  (advice-remove #'org-indent--compute-prefixes
                 #'org-margin-bullet-compute-prefixes))

(provide 'org-margin-bullet)
;;; org-margin-bullet.el ends here
