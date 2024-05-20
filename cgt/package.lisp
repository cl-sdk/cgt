(defpackage #:cgt
  (:use #:cl)
  (:export
   #:def-object
   #:create-class-for-object
   #:symbolicate))

(in-package #:cgt)

(defun symbolicate (name &optional (package *package*))
  (intern (string-upcase name) package))

(defparameter *allowed-class-properties*
  (list :initarg :initform :reader :accessor :writer :type))

(defmacro create-class-for-object (name properties &optional defclass-stuff)
  (let ((class-properties
          (mapcar (lambda (property)
                    (list* (car property)
                           (loop :for (x . y) :in (alexandria:plist-alist (cdr property))
                                 :if (member x *allowed-class-properties*)
                                   :nconc (list x y))))
                  properties)))
    `(defclass ,name () ,class-properties)))

(defmacro def-object (name (&optional defclass-stuff) &body body)
  (declare (ignore defclass-stuff))
  (destructuring-bind (properties generators)
      body
    `(prog1 (create-class-for-object ,name ,properties)
       ,@(mapcar (lambda (spec)
                   (destructuring-bind (category (generator &rest args))
                       spec
                     (declare (ignore category))
                     (funcall generator name properties args)))
                 generators))))
