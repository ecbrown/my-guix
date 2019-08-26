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

(define-module (sylpheed)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages crypto)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages mail)
  #:use-module (gnu packages onc-rpc)
  #:use-module (gnu packages openldap)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages tls)
  #:use-module ((guix licenses) #:select (gpl2+))
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu))

(define-public sylpheed
  (package
    (name "sylpheed")
    (version "3.7.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://sylpheed.sraoss.jp/sylpheed/v3.7/"
                                  name "-" version ".tar.xz"))
              (sha256
               (base32
                "0j9y5vdzch251s264diw9clrn88dn20bqqkwfmis9l7m8vmwasqd"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("bogofilter" ,bogofilter)
       ("compface" ,compface)
       ("gnupg" ,gnupg-1)
       ("gpgme" ,gpgme)
       ("gtk+-2.0" ,gtk+-2)
       ("gtkspell" ,gtkspell3)
       ("libnsl" ,libnsl)
       ("openldap" ,openldap)
       ("openssl" ,openssl)))
    (home-page "http://sylpheed.sraoss.jp/")
    (synopsis "Lightweight GTK+ email client")
    (description
     "Sylpheed is a simple, lightweight but featureful, and easy-to-use e-mail
client. Sylpheed provides intuitive user-interface. Sylpheed is also designed
for keyboard-oriented operation, so Sylpheed can be widely used from beginners
to power users.")
    (license gpl2+)))
