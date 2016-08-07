;;;; repertoire.asd

(asdf:defsystem #:repertoire
  :description "A music catalog and player"
  :author "Robert Roland <rob.roland@gmail.com>"
  :license "Apache Public License 2.0"
  :depends-on (#:cl-cffi-gtk
               #:cl-unicode
               #:com.gigamonkeys.pathnames
               #:com.gigamonkeys.macro-utilities
               #:id3v2)
  :serial t
  :components ((:file "package")
               (:file "database")
               (:file "mp3database")
               (:file "repertoire")))

