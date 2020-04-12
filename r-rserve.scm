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
  #:use-module (gnu packages tls))



(define-public r-rserve
  (package
    (name "r-rserve")
    (version "1.8-4")
    (source
     (origin
       (method url-fetch)
       ;(uri "https://github.com/s-u/Rserve/releases/download/1.8-4/Rserve_1.8-4.tar.gz")
       (uri "http://www.rforge.net/Rserve/snapshot/Rserve_1.8-4.tar.gz")
       (sha256
        (base32
         ;"1dncwiyhy1s1pimb6f2dzs3ivahah5id3chw4r10j92754bxmrn2"
         "0ayriwzwdx78357f8nvyq65idjz91szhhcg1hmyqv74i6l3x8nk0"))))
    (propagated-inputs
     `(("r" ,r)))
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
     `(("r-rserve" ,r-rserve)
       ))
;    (native-inputs `(("gfortran" ,gfortran)))
    (home-page "http://biostat.mc.vanderbilt.edu/rms")
    (synopsis "Regression modeling strategies")
    (description
     "This is a package for regression modeling, testing, estimation,
validation, graphics, prediction, and typesetting by storing enhanced model
design attributes in the fit.  The rms package is a collection of functions
that assist with and streamline modeling.  It also contains functions for
binary and ordinal logistic regression models, ordinal models for continuous Y
with a variety of distribution families, and the Buckley-James multiple
regression model for right-censored responses, and implements penalized
maximum likelihood estimation for logistic and ordinary linear models.  The
package works with almost any regression model, but it was especially written
to work with binary or ordinal regression models, Cox regression, accelerated
failure time models, ordinary linear models, the Buckley-James model,
generalized least squares for serially or spatially correlated observations,
generalized linear models, and quantile regression.")
    (license license:gpl2+)))

