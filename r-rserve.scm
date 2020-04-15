;;; Copyright © 2020 Eric Brown <ecbrown@ericcbrown.com>
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

(define-public r-brms
(package
  (name "r-brms")
  (version "2.12.0")
  (source
    (origin
      (method url-fetch)
      (uri (cran-uri "brms" version))
      (sha256
        (base32
          "1699lwkklfhjz7fddawlig552g2zvrc34mqwrzqjgl35r9fm08gs"))))
  (properties `((upstream-name . "brms")))
  (build-system r-build-system)
  (propagated-inputs
    `(("r-abind" ,r-abind)
      ("r-backports" ,r-backports)
      ("r-bayesplot" ,r-bayesplot)
      ("r-bridgesampling" ,r-bridgesampling)
      ("r-coda" ,r-coda)
      ("r-future" ,r-future)
      ("r-ggplot2" ,r-ggplot2)
      ("r-glue" ,r-glue)
      ("r-loo" ,r-loo)
      ("r-matrix" ,r-matrix)
      ("r-matrixstats" ,r-matrixstats)
      ("r-mgcv" ,r-mgcv)
      ("r-nleqslv" ,r-nleqslv)
      ("r-nlme" ,r-nlme)
      ("r-rcpp" ,r-rcpp)
      ("r-rstan" ,r-rstan)
      ("r-rstantools" ,r-rstantools)
      ("r-shinystan" ,r-shinystan)))
  (native-inputs `(("r-knitr" ,r-knitr)))
  (home-page
    "https://github.com/paul-buerkner/brms")
  (synopsis
    "Bayesian Regression Models using 'Stan'")
  (description
    "Fit Bayesian generalized (non-)linear multivariate multilevel models using 'Stan' for full Bayesian inference.  A wide range of distributions and link functions are supported, allowing users to fit -- among others -- linear, robust linear, count data, survival, response times, ordinal, zero-inflated, hurdle, and even self-defined mixture models all in a multilevel context.  Further modeling options include non-linear and smooth terms, auto-correlation structures, censored data, meta-analytic standard errors, and quite a few more.  In addition, all parameters of the response distribution can be predicted in order to perform distributional regression.  Prior specifications are flexible and explicitly encourage users to apply prior distributions that actually reflect their beliefs.  Model fit can easily be assessed and compared with posterior predictive checks and leave-one-out cross-validation.  References: BÃ¼rkner (2017) <doi:10.18637/jss.v080.i01>; BÃ¼rkner (2018) <doi:10.32614/RJ-2018-017>; Carpenter et al. (2017) <doi:10.18637/jss.v076.i01>.")
  (license gpl2)))

(define-public r-h2o
(package
  (name "r-h2o")
  (version "3.30.0.1")
  (source
    (origin
      (method url-fetch)
      (uri (cran-uri "h2o" version))
      (sha256
        (base32
          "1xdhd0h0hncg7s5nsrb97arqiyd9r3cxv1in36lx7pyplxcfy4fb"))))
  (properties `((upstream-name . "h2o")))
  (build-system r-build-system)
  (inputs `(("java" ,java)))
  (propagated-inputs
    `(("r-jsonlite" ,r-jsonlite) ("r-rcurl" ,r-rcurl)))
  (home-page "https://github.com/h2oai/h2o-3")
  (synopsis
    "R Interface for the 'H2O' Scalable Machine Learning Platform")
  (description
    "R interface for 'H2O', the scalable open source machine learning platform that offers parallelized implementations of many supervised and unsupervised machine learning algorithms such as Generalized Linear Models, Gradient Boosting Machines (including XGBoost), Random Forests, Deep Neural Networks (Deep Learning), Stacked Ensembles, Naive Bayes, Cox Proportional Hazards, K-Means, PCA, Word2Vec, as well as a fully automatic machine learning algorithm (AutoML).")
  (license #f)))

