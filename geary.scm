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

;; Broken: unable to find folks

(define-module (geary)
  #:use-module (gnu packages)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages enchant)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages mail)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages webkit)
  #:use-module ((guix licenses) #:select (lgpl2.1 public-domain))
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix utils)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-26)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system meson))

(define-public sqlite-fts3
  (package
   (name "sqlite")
   (replacement sqlite-3.26.0)
   (version "3.24.0")
   (source (origin
            (method url-fetch)
            (uri (let ((numeric-version
                        (match (string-split version #\.)
                          ((first-digit other-digits ...)
                           (string-append first-digit
                                          (string-pad-right
                                           (string-concatenate
                                            (map (cut string-pad <> 2 #\0)
                                                 other-digits))
                                           6 #\0))))))
                   (string-append "https://sqlite.org/2018/sqlite-autoconf-"
                                  numeric-version ".tar.gz")))
            (sha256
             (base32
              "0jmprv2vpggzhy7ma4ynmv1jzn3pfiwzkld0kkg6hvgvqs44xlfr"))))
   (build-system gnu-build-system)
   (inputs `(("readline" ,readline)))
   (arguments
    `(#:configure-flags
      ;; Add -DSQLITE_SECURE_DELETE, -DSQLITE_ENABLE_UNLOCK_NOTIFY and
      ;; -DSQLITE_ENABLE_DBSTAT_VTAB to CFLAGS.  GNU Icecat will refuse
      ;; to use the system SQLite unless these options are enabled.
      (list (string-append "CFLAGS=-O2 -DSQLITE_SECURE_DELETE "
                           "-DSQLITE_ENABLE_UNLOCK_NOTIFY "
                           "-DSQLITE_ENABLE_DBSTAT_VTAB "
                           "-DSQLITE_ENABLE_FTS3"))))
   (home-page "https://www.sqlite.org/")
   (synopsis "The SQLite database management system")
   (description
    "SQLite is a software library that implements a self-contained, serverless,
zero-configuration, transactional SQL database engine.  SQLite is the most
widely deployed SQL database engine in the world.  The source code for SQLite
is in the public domain.")
   (license public-domain)))

(define-public geary
  (package
    (name "geary")
    (version "3.33.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://gnome/sources/" name "/"
                           (version-major+minor version) "/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "1nlgrh8brjml17qb60pgqmk9811sxswgiw85iqygs45fbbgh0gmb"))))
    (build-system meson-build-system)
    (native-inputs
     `(("cmake" ,cmake)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("enchant" ,enchant)
       ("folks" ,folks)
       ("gmime-2.6" ,gmime-2.6)
       ("gtk+" ,gtk+)
       ("sqlite" ,sqlite-fts3)
       ("vala" ,vala)
       ("webkitgtk" ,webkitgtk)))
    (home-page "https://wiki.gnome.org/Apps/Geary/")
    (synopsis "Mail application built around conversations")
    (description "Geary is an email application built around conversations, for the GNOME 3 desktop. It allows you to read, find and send email with a
straightforward, modern interface.")
    (license lgpl2.1)))