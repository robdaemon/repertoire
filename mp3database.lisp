(in-package #:repertoire)

(defparameter *mp3-schema*
  (make-schema
   '((:file     string)
     (:genre    interned-string "Unknown")
     (:artist   interned-string "Unknown")
     (:album    interned-string "Unknown")
     (:song     string)
     (:track    number 0)
     (:year     number 0)
     (:id3-size number))))

(defparameter *mp3s* (make-instance 'table :schema *mp3-schema*))

(defun file->row (file)
  (let ((id3 (id3v2:read-mp3-file file)))
    (list
     :file     (namestring (truename file))
     :genre    (id3v2:mp3-genre id3)
     :artist   (id3v2:mp3-artist id3)
     :album    (id3v2:mp3-album id3)
     :song     (id3v2:mp3-name id3)
     :track    (parse-track (id3v2:mp3-track id3))
     :year     (parse-year (id3v2:mp3-year id3))
     :id3-size (id3v2:mp3-length id3))))

(defun parse-track (track)
  (when track (parse-integer track :end (position #\/ track))))

(defun parse-year (year)
  (when year (parse-integer year)))

(defun load-database (dir db)
  (let ((count 0))
    (com.gigamonkeys.pathnames:walk-directory
     dir
     #'(lambda (file)
         (princ #\.)
         (incf count)
         (insert-row (file->row file) db))
     :test #'mp3-p)
    (format t "~&Loaded ~d files into database." count)))

(defun mp3-p (file)
  (and
   (not (com.gigamonkeys.pathnames:directory-pathname-p file))
   (string-equal "mp3" (pathname-type file))))
