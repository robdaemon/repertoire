;;;; repertoire.lisp

(in-package #:repertoire)

;;; "repertoire" goes here. Hacks and glory await!

(defun list-files (tree-view)
  (let ((list-store (make-instance 'gtk-list-store :column-types '("gint" "gchararray"))))
    (gtk-tree-view-set-model tree-view list-store)
    (com.gigamonkeys.pathnames:walk-directory
     #p"c:/users/robda/Desktop/house"
     (lambda (fname)
       (gtk-list-store-set list-store
                           (gtk-list-store-append list-store)
                           0
                           (namestring fname))))))

(defun repertoire-ui ()
  (within-main-loop
    (let ((builder (make-instance 'gtk-builder)))
      (gtk-builder-add-from-file builder "C:/Users/robda/Source/lisp/repertoire/repertoire.glade")
      (let ((app-window (gtk-builder-get-object builder "appWindow"))
            (go-button (gtk-builder-get-object builder "goButton"))
            (music-tree (gtk-builder-get-object builder "musicTreeView")))
        (let* ((renderer (gtk-cell-renderer-text-new))
                (column (gtk-tree-view-column-new-with-attributes "Number"
                                                                  renderer
                                                                  "text" 0)))
          (gtk-tree-view-append-column music-tree column))
        (let* ((renderer (gtk-cell-renderer-text-new))
               (column (gtk-tree-view-column-new-with-attributes "Filename"
                                                                 renderer
                                                                 "text" 1)))
          (gtk-tree-view-append-column music-tree column))
        (g-signal-connect app-window "destroy"
                          (lambda (widget)
                            (declare (ignore widget))
                            (leave-gtk-main)))
        (g-signal-connect go-button "clicked"
                          (lambda (widget)
                            (declare (ignore widget))
                            (list-files music-tree)))
        (gtk-widget-show-all app-window)))))
