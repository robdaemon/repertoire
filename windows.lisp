(in-package #:repertoire)

(cffi:defctype dword :unsigned-long)

(cffi:define-foreign-library winmm
  (:windows "winmm"))

(cffi:use-foreign-library winmm)

(cffi:defcfun "mciSendString" dword
  (command :string)
  (return-string :string)
  (h-return :uint)
  (callback :pointer))
