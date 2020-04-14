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

(define-module (r-rserve)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system r)
  #:use-module (guix build-system trivial)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages statistics)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cran)
  #:use-module (gnu packages tls))

(define-public r-rserve
  (package
    (name "r-rserve")
    (version "1.8-6")
    (source
     (origin
       (method url-fetch)
       (uri "http://www.rforge.net/Rserve/snapshot/Rserve_1.8-6.tar.gz")
       (sha256
        (base32
         "1imz78wa9rphz9ly1wbz4ahdlzcc9hcfbfgdd2pbnpmipbrpg233"))))
    (propagated-inputs
     `(("r" ,r)
       ("r-rcpp" ,r-rcpp)
       ("r-r6" ,r-r6)
       ("r-uuid" ,r-uuid)
       ("r-checkmate" ,r-checkmate)
       ("r-mime" ,r-mime)
       ("r-jsonlite" ,r-jsonlite)
       ("r-knitr" ,r-knitr)))
    (inputs `(("zlib" ,zlib)
              ("openssl" ,openssl)))
    (build-system r-build-system)
    (home-page "https://github.com/s-u/Rserve")
    (synopsis "Fast, flexible and powerful server providing access to R from many languages and systems http://RForge.net/Rserve")
    (description
     "Rserve acts as a socket server (TCP/IP or local sockets) which
allows binary requests to be sent to R. Every connection has a
separate workspace and working directory. Client-side implementations
are available for popular languages such as C/C++ and Java, allowing
any application to use facilities of R without the need of linking to
R code. Rserve supports remote connection, user authentication and
file transfer. A simple R client is included in this package as
well.")
    (license license:gpl2)))

(define-public r-restrserve
  (package
    (name "r-restrserve")
    (version "0.2.2")
    (source
     (origin
       (method url-fetch)
       (uri (cran-uri "RestRserve" version))
       (sha256
        (base32 "1b8wbar98qhhl46s4i7qks5nm2wy5bvfi9029gpd4gmqsq4bmbm7"))))
    (build-system r-build-system)
    (propagated-inputs
     `(("r-rserve" ,r-rserve)))
    (home-page "https://restrserve.org")
    (synopsis "R web API framework")
    (description
     "RestRserve is an R web API framework for building high-performance AND
robust microservices and app backends. With Rserve backend on UNIX-like systems
it is parallel by design. It will handle incoming requests in parallel - each
request in a separate fork.")
    (license license:gpl2+)))
