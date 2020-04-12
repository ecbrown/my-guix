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

(define-module (sysbench)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system gnu)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages compression)  
  #:use-module (gnu packages databases)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages lua)
  #:use-module (gnu packages m4)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages tls))

(define-public sysbench
  (package
    (name "sysbench")
    (version "1.0.19")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/akopytov/sysbench")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "02i9knvp0bjw6ri848xxiy2dbww2xv70nah9yn67a6zgw617hwa6"))
       (modules '((guix build utils)))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ; until shebangs fixed
       #:configure-flags '("--with-system-luajit" "--without-mysql")
       #:phases
       (modify-phases %standard-phases
         (delete 'bootstrap)
         (add-after 'patch-source-shebangs 'libtoolize
           (lambda _ (invoke "libtoolize" "--copy" "--force")))
         (add-after 'libtoolize 'aclocal
           (lambda _ (invoke "aclocal" "-I" "m4")))
         (add-after 'aclocal 'autoreconf
           (lambda _ (invoke "autoreconf" "--install")))
         (add-after 'autoreconf 'automake
           (lambda _ (invoke "automake"
                             "-c" "--foreign" "--add-missing")))
         (add-after 'automake 'autoconf
           (lambda _ (invoke "autoconf"))))))
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)
       ("libtool" ,libtool)
       ("lua" ,lua)
       ("m4" ,m4)
       ("perl" ,perl)
       ("pkg-config" ,pkg-config)
       ("python" ,python-minimal)))
    (inputs
     `(("libaio" ,libaio)
       ("luajit" ,luajit)
       ;("mariadb" ,mariadb)
       ("openssl" ,openssl)
       ("postgresql" ,postgresql)
       ("zlib" ,zlib)))
    (home-page "https://github.com/akopytov/sysbench/")
    (synopsis "Scriptable multi-threaded benchmark tool ")
    (description "sysbench is a scriptable multi-threaded benchmark tool based
on LuaJIT. It is most frequently used for database benchmarks, but can also be
used to create arbitrarily complex workloads that do not involve a database
server.")
    (license license:gpl2+)))
