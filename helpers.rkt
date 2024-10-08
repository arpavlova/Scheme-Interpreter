#lang r5rs
(#%provide (all-defined))

;=============================================================== 
(define (error message expr)
  (display "Error: ")
  (display message)
  (newline)
  (display expr)
  (newline)
  (/ 5 0))
  ;(newline)
  ;(display environment))
;===============================================================
(define (custom-display expr)
     (display expr)
     (newline))
;===============================================================
(define (list-of-expressions input)
  (and (pair? input) (not (symbol? (car input)))))
;===============================================================
(define (make-tuples-list keys values)
  (cond
    ((and (null? keys) (not (null? values))) (error "TOO MANY ARGUMENTS IN PROCEDURE"))
    ((and (null? values) (not (null? keys))) (error "TOO FEW ARGUMENTS IN PROCEDURE"))
    ((and (null? values) (null? keys)) '())
    (else (append (list (list (car keys) (car values))) (make-tuples-list (cdr keys) (cdr values))))))
;===============================================================
(define (filter pred lst)
  (cond ((null? lst) '())
        ((pred (car lst)) (cons (car lst) (filter pred (cdr lst))))
        (else (filter pred (cdr lst)))))
;===============================================================
(define (already-def-in-frame? var frame)
  (not (null? (filter (lambda (i) (equal? var (car i))) frame))))
;===============================================================
(define (get-var expr)
  (if (symbol? (cadr expr)) (cadr expr) (caadr expr)))
;===============================================================
(define (get-val expr)
  (if (symbol? (cadr expr)) (caddr expr)
      (cons 'lambda (cons (cdadr expr) (cddr expr)))))
;===============================================================