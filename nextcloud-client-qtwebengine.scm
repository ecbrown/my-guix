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

(define-module (nextcloud-client-qtwebengine)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gperf)
  #:use-module (gnu packages gstreamer)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages image)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages pciutils)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages re2c)
  #:use-module (gnu packages ruby)
  #:use-module (gnu packages sdl)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages vulkan)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages xml)
  #:use-module (srfi srfi-1)

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

(define-public qt-qtwebengine
  (package
    (name "qt")
    (version "5.11.3")
    (outputs '("out" "examples"))
    (source (origin
             (method url-fetch)
             (uri
               (string-append
                 "http://download.qt.io/official_releases/qt/"
                 (version-major+minor version)
                 "/" version
                 "/single/qt-everywhere-src-"
                 version ".tar.xz"))
             (sha256
              (base32
               "0kgzy32s1fr22fxxfhcyncfryb3qxrznlr737r4y5khk4xj1g545"))
             (modules '((guix build utils)))
             (snippet
              '(begin
                ;; Remove qtwebengine, which relies on a bundled copy of
                ;; chromium. Not only does it fail compilation in qt 5.5:
                ;;    3rdparty/chromium/ui/gfx/codec/jpeg_codec.cc:362:10:
                ;;    error: cannot convert ‘bool’ to ‘boolean’ in return
                ;; it might also pose security problems.
                ;; Alternatively, we could use the "-skip qtwebengine"
                ;; configuration option.
;                (delete-file-recursively "qtwebengine")
                ;; The following snippets are copied from their mondular-qt counterparts.
                (for-each
                  (lambda (dir)
                    (delete-file-recursively (string-append "qtbase/src/3rdparty/" dir)))
                  (list "double-conversion" "freetype" "harfbuzz-ng"
                        "libpng" "libjpeg" "pcre2" "sqlite" "xcb"
                        "xkbcommon" "zlib"))
                (for-each
                  (lambda (dir)
                    (delete-file-recursively dir))
                  (list "qtimageformats/src/3rdparty"
                        "qtmultimedia/examples/multimedia/spectrum/3rdparty"
                        "qtwayland/examples"
                        "qtscxml/tests/3rdparty"
                        "qtcanvas3d/examples/canvas3d/3rdparty"))
                ;; Tests depend on this example, which depends on the 3rd party code.
                (substitute* "qtmultimedia/examples/multimedia/multimedia.pro"
                  (("spectrum") "#"))
                (substitute* "qtxmlpatterns/tests/auto/auto.pro"
                  (("qxmlquery") "# qxmlquery")
                  (("xmlpatterns ") "# xmlpatterns"))
                (substitute* "qtwebglplugin/tests/plugins/platforms/platforms.pro"
                  (("webgl") "# webgl"))
                (substitute* "qtscxml/tests/auto/auto.pro"
                  (("scion") "#"))
                (substitute* "qtnetworkauth/tests/auto/auto.pro"
                  (("oauth1 ") "# oauth1 "))
                (substitute* "qtremoteobjects/tests/auto/qml/qml.pro"
                  (("integration") "# integration")
                  (("usertypes") "# usertypes"))
                #t))))
    (build-system gnu-build-system)
    (propagated-inputs
     `(("mesa" ,mesa)))
    (inputs
     `(("alsa-lib" ,alsa-lib)
       ("bluez" ,bluez)
       ("cups" ,cups)
       ("dbus" ,dbus)
       ("double-conversion" ,double-conversion)
       ("expat" ,expat)
       ("fontconfig" ,fontconfig)
       ("freetype" ,freetype)
       ("gcc" ,gcc-9)
       ("gcc-toolchain" ,gcc-toolchain-9)
       ("glib" ,glib)
       ("gstreamer" ,gstreamer)
       ("gst-plugins-base" ,gst-plugins-base)
       ("harfbuzz" ,harfbuzz)
       ("icu4c" ,icu4c)
       ("jasper" ,jasper)
       ("libinput" ,libinput-minimal)
       ("libjpeg" ,libjpeg)
       ("libmng" ,libmng)
       ("libpci" ,pciutils)
       ("libpng" ,libpng)
       ("libtiff" ,libtiff)
       ("libwebp" ,libwebp)
       ("libx11" ,libx11)
       ("libxcomposite" ,libxcomposite)
       ("libxcursor" ,libxcursor)
       ("libxext" ,libxext)
       ("libxfixes" ,libxfixes)
       ("libxi" ,libxi)
       ("libxinerama" ,libxinerama)
       ("libxkbcommon" ,libxkbcommon)
       ("libxml2" ,libxml2)
       ("libxrandr" ,libxrandr)
       ("libxrender" ,libxrender)
       ("libxslt" ,libxslt)
       ("libxtst" ,libxtst)
       ("mtdev" ,mtdev)
       ("mariadb" ,mariadb)
       ("nss" ,nss)
       ("openssl" ,openssl)
       ("postgresql" ,postgresql)
       ("pulseaudio" ,pulseaudio)
       ("pcre2" ,pcre2)
       ("re2c" ,re2c)
       ("sqlite" ,sqlite-with-column-metadata)
       ("udev" ,eudev)
       ("unixodbc" ,unixodbc)
       ("wayland" ,wayland)
       ("xcb-util" ,xcb-util)
       ("xcb-util-image" ,xcb-util-image)
       ("xcb-util-keysyms" ,xcb-util-keysyms)
       ("xcb-util-renderutil" ,xcb-util-renderutil)
       ("xcb-util-wm" ,xcb-util-wm)
       ("zlib" ,zlib)))
    (native-inputs
     `(("bison" ,bison)
       ("flex" ,flex)
       ("gcc" ,gcc-9)
       ("gcc-toolchain" ,gcc-toolchain-9)
       ("gperf" ,gperf)
       ("perl" ,perl)
       ("pkg-config" ,pkg-config)
       ("python" ,python-2)
       ("ruby" ,ruby)
       ("vulkan-headers" ,vulkan-headers)
       ("which" ,(@ (gnu packages base) which))))
    (arguments
     `(#:parallel-build? #t ; was #f: Triggers race condition in qtbase module on Hydra.
       #:phases
       (modify-phases %standard-phases
         (add-after 'configure 'patch-bin-sh
           (lambda _
             (substitute* '("qtbase/configure"
                            "qtbase/mkspecs/features/qt_functions.prf"
                            "qtbase/qmake/library/qmakebuiltins.cpp")
                          (("/bin/sh") (which "sh")))
             #t))
         (replace 'configure
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out      (assoc-ref outputs "out"))
                   (examples (assoc-ref outputs "examples")))
               (substitute* '("configure" "qtbase/configure")
                 (("/bin/pwd") (which "pwd")))
               (substitute* "qtbase/src/corelib/global/global.pri"
                 (("/bin/ls") (which "ls")))
               ;; do not pass "--enable-fast-install", which makes the
               ;; configure process fail
               (invoke
                 "./configure"
                 "-verbose"
                 "-prefix" out
                 "-docdir" (string-append out "/share/doc/qt5")
                 "-headerdir" (string-append out "/include/qt5")
                 "-archdatadir" (string-append out "/lib/qt5")
                 "-datadir" (string-append out "/share/qt5")
                 "-examplesdir" (string-append
                                  examples "/share/doc/qt5/examples") ; 151MiB
                 "-opensource"
                 "-confirm-license"

                 ;; These features require higher versions of Linux than the
                 ;; minimum version of the glibc.  See
                 ;; src/corelib/global/minimum-linux_p.h.  By disabling these
                 ;; features Qt5 applications can be used on the oldest
                 ;; kernels that the glibc supports, including the RHEL6
                 ;; (2.6.32) and RHEL7 (3.10) kernels.
                 "-no-feature-getentropy"  ; requires Linux 3.17
                 "-no-feature-renameat2"   ; requires Linux 3.16

                 ;; Do not build examples; for the time being, we
                 ;; prefer to save the space and build time.
                 "-no-compile-examples"
                 ;; Most "-system-..." are automatic, but some use
                 ;; the bundled copy by default.
                 "-system-sqlite"
                 "-system-harfbuzz"
                 "-system-pcre"
                 ;; explicitly link with openssl instead of dlopening it
                 "-openssl-linked"
                 ;; explicitly link with dbus instead of dlopening it
                 "-dbus-linked"
                 ;; don't use the precompiled headers
                 "-no-pch"
                 ;; drop special machine instructions not supported
                 ;; on all instances of the target
                 ,@(if (string-prefix? "x86_64"
                                       (or (%current-target-system)
                                           (%current-system)))
                       '()
                       '("-no-sse2"))
                 "-no-mips_dsp"
                 "-no-mips_dspr2"))))
           (add-after 'install 'patch-mkspecs
             (lambda* (#:key outputs #:allow-other-keys)
               (let* ((out (assoc-ref outputs "out"))
                      (archdata (string-append out "/lib/qt5"))
                      (mkspecs (string-append archdata "/mkspecs"))
                      (qt_config.prf (string-append
                                      mkspecs "/features/qt_config.prf")))
                 ;; For each Qt module, let `qmake' uses search paths in the
                 ;; module directory instead of all in QT_INSTALL_PREFIX.
                 (substitute* qt_config.prf
                   (("\\$\\$\\[QT_INSTALL_HEADERS\\]")
                    "$$clean_path($$replace(dir, mkspecs/modules, ../../include/qt5))")
                   (("\\$\\$\\[QT_INSTALL_LIBS\\]")
                    "$$clean_path($$replace(dir, mkspecs/modules, ../../lib))")
                   (("\\$\\$\\[QT_HOST_LIBS\\]")
                    "$$clean_path($$replace(dir, mkspecs/modules, ../../lib))")
                   (("\\$\\$\\[QT_INSTALL_BINS\\]")
                    "$$clean_path($$replace(dir, mkspecs/modules, ../../bin))"))

                 ;; Searches Qt tools in the current PATH instead of QT_HOST_BINS.
                 (substitute* (string-append mkspecs "/features/qt_functions.prf")
                   (("cmd = \\$\\$\\[QT_HOST_BINS\\]/\\$\\$2")
                    "cmd = $$system(which $${2}.pl 2>/dev/null || which $${2})"))

                 ;; Resolve qmake spec files within qtbase by absolute paths.
                 (substitute*
                     (map (lambda (file)
                            (string-append mkspecs "/features/" file))
                          '("device_config.prf" "moc.prf" "qt_build_config.prf"
                            "qt_config.prf" "winrt/package_manifest.prf"))
                   (("\\$\\$\\[QT_HOST_DATA/get\\]") archdata)
                   (("\\$\\$\\[QT_HOST_DATA/src\\]") archdata))
                 #t)))
           (add-after 'unpack 'patch-paths
             ;; Use the absolute paths for dynamically loaded libs, otherwise
             ;; the lib will be searched in LD_LIBRARY_PATH which typically is
             ;; not set in guix.
             (lambda* (#:key inputs #:allow-other-keys)
               ;; libresolve
               (let ((glibc (assoc-ref inputs ,(if (%current-target-system)
                                                   "cross-libc" "libc"))))
                 (substitute* '("qtbase/src/network/kernel/qdnslookup_unix.cpp"
                                "qtbase/src/network/kernel/qhostinfo_unix.cpp")
                   (("^\\s*(lib.setFileName\\(QLatin1String\\(\")(resolv\"\\)\\);)" _ a b)
                  (string-append a glibc "/lib/lib" b))))
               ;; X11/locale (compose path)
               (substitute* "qtbase/src/plugins/platforminputcontexts/compose/generator/qtablegenerator.cpp"
                 ;; Don't search in /usr/…/X11/locale, …
                 (("^\\s*m_possibleLocations.append\\(QStringLiteral\\(\"/usr/.*/X11/locale\"\\)\\);" line)
                  (string-append "// " line))
                 ;; … but use libx11's path
                 (("^\\s*(m_possibleLocations.append\\(QStringLiteral\\()X11_PREFIX \"(/.*/X11/locale\"\\)\\);)" _ a b)
                  (string-append a "\"" (assoc-ref inputs "libx11") b)))
               ;; libGL
               (substitute* "qtbase/src/plugins/platforms/xcb/gl_integrations/xcb_glx/qglxintegration.cpp"
                 (("^\\s*(QLibrary lib\\(QLatin1String\\(\")(GL\"\\)\\);)" _ a b)
                  (string-append a (assoc-ref inputs "mesa") "/lib/lib" b)))
               ;; libXcursor
               (substitute* "qtbase/src/plugins/platforms/xcb/qxcbcursor.cpp"
                 (("^\\s*(QLibrary xcursorLib\\(QLatin1String\\(\")(Xcursor\"\\), 1\\);)" _ a b)
                  (string-append a (assoc-ref inputs "libxcursor") "/lib/lib" b))
                 (("^\\s*(xcursorLib.setFileName\\(QLatin1String\\(\")(Xcursor\"\\)\\);)" _ a b)
                  (string-append a (assoc-ref inputs "libxcursor") "/lib/lib" b)))
               #t)))))
      (native-search-paths
       (list (search-path-specification
              (variable "QMAKEPATH")
              (files '("lib/qt5")))
             (search-path-specification
              (variable "QML2_IMPORT_PATH")
              (files '("lib/qt5/qml")))
             (search-path-specification
              (variable "QT_PLUGIN_PATH")
              (files '("lib/qt5/plugins")))
             (search-path-specification
              (variable "XDG_DATA_DIRS")
              (files '("share")))
             (search-path-specification
              (variable "XDG_CONFIG_DIRS")
              (files '("etc/xdg")))))
      (home-page "https://www.qt.io/")
      (synopsis "Cross-platform GUI library")
      (description "Qt is a cross-platform application and UI framework for
  developers using C++ or QML, a CSS & JavaScript like language.")
      (license (list license:lgpl2.1 license:lgpl3))

    ;; Qt 4: 'QBasicAtomicPointer' leads to build failures on MIPS;
    ;; see <http://hydra.gnu.org/build/112828>.
    ;; Qt 5: assembler error; see <http://hydra.gnu.org/build/112526>.
    (supported-systems (delete "mips64el-linux" %supported-systems))))

(define-public nextcloud-client-qtwebengine
  (package
    (name "nextcloud-client-qtwebengine")
    (version "2.5.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
	     (url "https://github.com/nextcloud/desktop")
	     (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1x6pdmgcwqj2k47phw27ixsnvl1fvzax2k5wh5gzha3mg0wcv7nj"))
;       (patches (search-patches "owncloud-disable-updatecheck.patch"))
;       (patches '("patches/nextcloud-client-qtwebkit-instead-of-qtwebengine.patch"))
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
;       ("qtlinguist" ,qttools)
       ))
    (inputs
     `(("openssl" ,openssl)
       ("qt" ,qt-qtwebengine)
;       ("qtbase" ,qtbase)
;       ("qtkeychain" ,qtkeychain)
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
