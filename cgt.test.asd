(asdf:defsystem #:cgt.test
  :depends-on (#:fiveam #:cgt)
  :serial t
  :pathname "cgt"
  :components ((:file "test")))
