;;; Copyright © 2019 Eric Brown <brown@fastmail.com>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (emacs-pastebin)
  #:use-module (guix)
  #:use-module (guix git-download)
  #:use-module (guix build-system emacs)
  #:use-module ((guix licenses) #:prefix license:))

(define-public emacs-pastebin
  (let ((commit "b8cba70821e84aad7561787c99ebdca1bd8c5d42")
        (revision "1"))
    (package
      (name "emacs-pastebin")
      (version (git-version "0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://github.com/dhilst/emacs-pastebin.git")
           (commit commit)))
         (file-name (git-file-name name commit))
         (sha256
          (base32
           "0b9bmb2c717fhdzapk85rm2s8q7hs19h55mbhzzwy78p4f6p8z9i"))))
      (build-system emacs-build-system)
      (arguments '(#:include '("\\.el$")))
      (home-page
       "https://github.com/dhilst/emacs-pastebin/")
      (synopsis
       "Emacs pastebin interface")
      (description
       "This is an interface to pastebin.com. With it, you can paste buffers, and fetch, delete, and list pastes. Additionally, it is possible to sort the paste lists by various attributes.")
      (license license:gpl2+))))
