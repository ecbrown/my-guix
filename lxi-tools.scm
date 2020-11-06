(define-module (lxi-tools)
  #:use-module (guix)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages avahi)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages lua)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages xml)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix git-download)
  #:use-module (guix build-system emacs)
  #:use-module ((guix licenses) #:prefix license:))

(define-public liblxi
  (package
    (name "liblxi")
    (version "1.13")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/lxi-tools/liblxi/releases/download/v"
                                  version "/liblxi-" version ".tar.xz"))
              (sha256
               (base32
                "0jr4s5p4azd5sxji5mi9w42hd2mc46p2c1v7ahn7mvqcdk74vm21"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)
       ("gettext" ,gettext-minimal)
       ("lua" ,lua)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("avahi" ,avahi)
       ("libxml2" ,libxml2)
       ("lua-5.3" ,lua)))
    (synopsis "Library for communication with LXI compatible devices")
    (description
     "liblxi is an open source software library which offers a simple API for
communicating with LXI compatible instruments. The API allows applications to
discover instruments on your network, send SCPI commands, and receive
responses.")
    (home-page "https://lxi-tools.github.io/")
    (license license:non-copyleft)))

(define-public lxi-tools
  (package
    (name "lxi-tools")
    (version "1.21")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/lxi-tools/lxi-tools/releases/download/v"
                                  version "/lxi-tools-" version ".tar.xz"))
              (sha256
               (base32
                "1v5ddp6f0q9vmlc7i448q5yy1dbfnrwxhk9z10fx93j42d79rng9"))))
    (build-system gnu-build-system)
;    (arguments
;     `(#:phases
;       (modify-phases %standard-phases
;         (add-before
;             'configure 'pre-configure
;           (lambda _ (invoke "autoreconf" "-vfsi"))))))
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)
       ("gettext" ,gettext-minimal)
       ("lua" ,lua)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("avahi" ,avahi)
       ("libxml2" ,libxml2)
       ("lua-5.3" ,lua)
       ("qtbase" ,qtbase)
       ("qtcharts" ,qtcharts)
       ("qwt" ,qwt)
       ("readline" ,readline)))
    (propagated-inputs
     `(("liblxi" ,liblxi)))
    (synopsis "Library for communication with LXI compatible devices")
    (description
     "liblxi is an open source software library which offers a simple API for
communicating with LXI compatible instruments. The API allows applications to
discover instruments on your network, send SCPI commands, and receive
responses.")
    (home-page "https://lxi-tools.github.io/")
    (license license:non-copyleft)))
