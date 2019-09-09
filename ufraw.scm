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

(define-module (ufraw)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages ghostscript)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages m4)
  #:use-module (gnu packages pkg-config))

(define-public ufraw
  (package
    (name "ufraw")
    (version "0.22")
    (source (origin
             (method url-fetch)
             (uri (list
                   (string-append "mirror://sourceforge/ufraw/files/ufraw/"
                                  name "-" version "/ufraw-" version ".tar.gz")))
             (sha256
              (base32
               "06bdnhb0l81srdzg6gn2v2ydhhaazza7rshrcj3q8dpqr3gn97dd"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)
       ("libtool" ,libtool)
       ("m4" ,m4)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("glib", glib)
       ("lcms2" ,lcms)))
    (synopsis "Utility for raw image processing")
    (description
     "The Unidentified Flying Raw (UFRaw) is a utility to read and manipulate
raw images from digital cameras. It can be used on its own or as a Gimp
plug-in.")
    (license license:gpl3+)
    (home-page "http://ufraw.sourceforge.net/")))
