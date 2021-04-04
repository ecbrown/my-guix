(define-module (openmolcas)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 match)
  #:use-module (gnu packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module ((guix build utils) #:select (alist-replace))
  #:use-module (guix build-system cmake)
;  #:use-module (guix build-system glib-or-gtk)
;  #:use-module (guix build-system gnu)
;  #:use-module (guix build-system python)
;  #:use-module (guix build-system ruby)
;  #:use-module (gnu packages algebra)
;  #:use-module (gnu packages audio)
;  #:use-module (gnu packages autotools)
;  #:use-module (gnu packages base)
;  #:use-module (gnu packages bison)
;  #:use-module (gnu packages boost)
;  #:use-module (gnu packages check)
  #:use-module (gnu packages cmake)
;  #:use-module (gnu packages compression)
;  #:use-module (gnu packages curl)
;  #:use-module (gnu packages cyrus-sasl)
;  #:use-module (gnu packages dbm)
;  #:use-module (gnu packages documentation)
;  #:use-module (gnu packages elf)
;  #:use-module (gnu packages file)
;  #:use-module (gnu packages flex)
;  #:use-module (gnu packages fltk)
;  #:use-module (gnu packages fontutils)
;  #:use-module (gnu packages gettext)
  #:use-module (gnu packages gcc)
;  #:use-module (gnu packages gd)
;  #:use-module (gnu packages ghostscript)
;  #:use-module (gnu packages glib)
;  #:use-module (gnu packages graphviz)
;  #:use-module (gnu packages gtk)
;  #:use-module (gnu packages icu4c)
;  #:use-module (gnu packages image)
;  #:use-module (gnu packages java)
;  #:use-module (gnu packages less)
;  #:use-module (gnu packages lisp)
;  #:use-module (gnu packages linux)
;  #:use-module (gnu packages llvm)
;  #:use-module (gnu packages logging)
;  #:use-module (gnu packages lua)
;  #:use-module (gnu packages gnome)
;  #:use-module (gnu packages guile)
;  #:use-module (gnu packages xorg)
;  #:use-module (gnu packages gl)
;  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages maths)
;  #:use-module (gnu packages m4)
;  #:use-module (gnu packages mpi)
;  #:use-module (gnu packages multiprecision)
;  #:use-module (gnu packages netpbm)
;  #:use-module (gnu packages onc-rpc)
;  #:use-module (gnu packages pcre)
;  #:use-module (gnu packages popt)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
;  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages python)
;  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
;  #:use-module (gnu packages qt)
;  #:use-module (gnu packages readline)
;  #:use-module (gnu packages ruby)
;  #:use-module (gnu packages tbb)
;  #:use-module (gnu packages scheme)
;  #:use-module (gnu packages shells)
;  #:use-module (gnu packages tcl)
;  #:use-module (gnu packages texinfo)
;  #:use-module (gnu packages tex)
;  #:use-module (gnu packages tls)
;  #:use-module (gnu packages version-control)
;  #:use-module (gnu packages wxwidgets)
;  #:use-module (gnu packages xml)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26))

(define-public openmolcas
	(package
	 (name "openmolcas")
   (version "21.02")

    (source (origin
              (method url-fetch)
;              (uri (string-append "https://nosignal.fi/download/ecasound-"
;                                  version ".tar.gz"))
              (uri "https://gitlab.com/Molcas/OpenMolcas/-/archive/v21.02/OpenMolcas-v21.02.tar.gz")
              (sha256
               (base32 "1k1vpdpx038k0m0fcbfq30q93jmz450yn40l1hj5jfizgyn8qnzs"))))
;    (source (origin
;     (method git-fetch)
;     (uri (git-reference
;           (url "https://gitlab.com/molcas/openmolcas")
;           (commit (string-append "v" version))))
;     (file-name (git-file-name name version))
;     (sha256
;      (base32 "1n6l91yyqjx0pz4w1lp3yybpq0fs2yjswfcm8c1wjfkxwiznbdxi"))))
	  (build-system cmake-build-system)
        (arguments
     '(#:tests? #f
       #:configure-flags
       (let ((out (assoc-ref %outputs "out")))
         (list "-DLINALG=OpenBLAS"
               (string-append "-DOPENBLASROOT=" (assoc-ref native-inputs "openblas"))
               ;"-DCC=gcc"
               ;(string-append "-DCMAKE_INSTALL_SYSCONF_PREFIX=" out "/etc")
               ;(string-append "-DBASHCOMPLETIONDIR=" out "/etc/bash_completion.d"))
         ))
       ;#:phases
       ;(modify-phases %standard-phases
       ;  (add-after 'install 'install-xsession
       ;    (lambda* (#:key outputs #:allow-other-keys)
       ;      (let* ((out (assoc-ref outputs "out"))
       ;             (xsessions (string-append out "/share/xsessions")))
       ;        (mkdir-p xsessions)
       ;        (call-with-output-file
       ;            (string-append xsessions "/herbstluftwm.desktop")
       ;          (lambda (port)
       ;            (format port "~
       ;              [Desktop Entry]~@
       ;              Name=herbstluftwm~@
       ;              Comment=Manual tiling window manager~@
       ;              Exec=~a/bin/herbstluftwm~@
       ;              Type=XSession~%" out)))
       ;        #t))))
       ))
    ;(arguments
    ; `(#:configure-flags (list
    ;                      "-DLINALG=OpenBLAS"
    ;                      (string-append "-DOPENBLASROOT=" (assoc-ref (or inputs native-inputs) "openblas"))))
    ;                     #:tests? #f)
	 (inputs
		`(("openblas" ,openblas-ilp64)
			("lapack" ,lapack)
      ))
	 (native-inputs
		`(("hdf5" ,hdf5)
      ("python" ,python)
      ("python-minimal" ,python-minimal)
      ("openblas" ,openblas-ilp64)
			("lapack" ,lapack)
			("gfortran" ,gfortran)))
	 (home-page "https://www.openmolcas.org")
	 (synopsis "OpenMOLCAS")
	 (description "OpenMOLCAS")
	 (license license:gpl3)))
