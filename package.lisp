;;;; package.lisp

(defpackage #:repertoire
  (:use #:cl
        #:gtk #:gdk #:gdk-pixbuf #:gobject
        #:glib #:gio #:pango #:cairo #:cffi)
  (:export #:repertoire-ui))

