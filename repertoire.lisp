;;;; repertoire.lisp

(in-package #:repertoire)

;;; "repertoire" goes here. Hacks and glory await!

(defun list-songs (tree-view)
  (let ((list-store (make-instance 'gtk-list-store :column-types '("gint" "gchararray" "gchararray" "gchararray" "gchararray")))
        (values
           (select
            :from *mp3s*
            :columns '(:track :artist :album :song)
            :order-by '(:artist :track))))
    (gtk-tree-view-set-model tree-view list-store)
    (map-rows (lambda (row)
                (gtk-list-store-set list-store
                                    (gtk-list-store-append list-store)
                                    (column-value row :track)
                                    (column-value row :artist)
                                    (column-value row :album)
                                    (column-value row :song)))
              values)))

(defun repertoire-ui ()
  (within-main-loop
    (let ((builder (make-instance 'gtk-builder)))
      (gtk-builder-add-from-file builder "C:/Users/robda/Source/lisp/repertoire/repertoire.glade")
      (let ((app-window (gtk-builder-get-object builder "appWindow"))
            (artists-button (gtk-builder-get-object builder "artistsButton"))
            (music-tree (gtk-builder-get-object builder "musicTreeView")))
        (let* ((renderer (gtk-cell-renderer-text-new))
                (column (gtk-tree-view-column-new-with-attributes "Number"
                                                                  renderer
                                                                  "text" 0)))
          (gtk-tree-view-append-column music-tree column))
        (let* ((renderer (gtk-cell-renderer-text-new))
               (column (gtk-tree-view-column-new-with-attributes "Artist"
                                                                 renderer
                                                                 "text" 1)))
          (gtk-tree-view-append-column music-tree column))
        (let* ((renderer (gtk-cell-renderer-text-new))
               (column (gtk-tree-view-column-new-with-attributes "Album"
                                                                 renderer
                                                                 "text" 2)))
          (gtk-tree-view-append-column music-tree column))
        (let* ((renderer (gtk-cell-renderer-text-new))
               (column (gtk-tree-view-column-new-with-attributes "Song"
                                                                 renderer
                                                                 "text" 3)))
          (gtk-tree-view-append-column music-tree column))
        (g-signal-connect app-window "destroy"
                          (lambda (widget)
                            (declare (ignore widget))
                            (leave-gtk-main)))
        (g-signal-connect artists-button "clicked"
                          (lambda (widget)
                            (declare (ignore widget))
                            (list-songs music-tree)))
        (gtk-widget-show-all app-window)))))
