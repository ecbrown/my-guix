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


; Builds, but breaks with Segmentation Fault

(define-module (nextcloud-client)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system cmake)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages check)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages tls))

(define-public nextcloud-client
  (package
    (name "nextcloud-client")
    ; stuck on 2.5.2 until Nextcloud can be build without QtWebEngine
    (version "2.5.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
	     (url "https://github.com/nextcloud/desktop")
	     (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "02q9fyxicaisrqy2sgrnrxfq3pbrc2k95krx5yrc9ca4p6f85kgn"))
;       (patches (search-patches "owncloud-disable-updatecheck.patch"))
       (patches '("patches/nextcloud-client-qtwebkit-instead-of-qtwebengine.patch"))
       (modules '((guix build utils)))
       (snippet
        '(begin
           ;; libcrashreporter-qt has its own bundled dependencies
           (delete-file-recursively "src/3rdparty/libcrashreporter-qt")
           (delete-file-recursively "src/3rdparty/sqlite3")
           ;; qprogessindicator, qlockedfile, qtokenizer and
           ;; qtsingleapplication have not yet been packaged, but all are
           ;; explicitly used from the 3rdparty folder during build.
           ;; We can also remove the macgoodies folder
           (delete-file-recursively "src/3rdparty/qtmacgoodies")
           #t))))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f
;       #:phases
;       (modify-phases %standard-phases
;         (add-after 'unpack 'delete-failing-tests
           ;; "Could not create autostart folder"
;           (lambda _
;             (substitute* "test/CMakeLists.txt"
;                          (("owncloud_add_test\\(Utility \"\"\\)" test)
;                           (string-append "#" test)))
;             #t))
;         (add-after 'unpack 'dont-embed-store-path
;           (lambda _
;             (substitute* "src/common/utility_unix.cpp"
;               (("QCoreApplication::applicationFilePath\\()") "\"owncloud\""))
;             #t))
;         (delete 'patch-dot-desktop-files))
       #:configure-flags '(
                           "-DUNIT_TESTING=ON"
                           ;; build without qtwebkit, which causes the
                           ;; package to FTBFS while looking for QWebView.
                           "-DNO_SHIBBOLETH=1"
			   )))
    (native-inputs
     `(
;       ("cmocka" ,cmocka)
;       ("glib" ,glib)
       ("perl" ,perl)
       ("pkg-config" ,pkg-config)
       ("qtlinguist" ,qttools)
       ))
    (inputs
     `(("openssl" ,openssl-next)
       ("qtbase" ,qtbase)
       ("qtkeychain" ,qtkeychain)
;       ("qtwebview" ,qtwebview)
       ("sqlite" ,sqlite)
       ("zlib" ,zlib)
       ))
    (home-page "https://nextcloud.org")
    (synopsis "Folder synchronization with a Nextcloud server")
    (description "The Nextcloud system lets you always have your
latest files wherever you are.  Just specify one or more folders on
the local machine to and a server to synchronize to.  You can
configure more computers to synchronize to the same server and any
change to the files on one computer will silently and reliably flow
across to every other.")
    (license license:gpl2+)))
