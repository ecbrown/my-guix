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
       ("gtkspell" ,gtkspell)
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
