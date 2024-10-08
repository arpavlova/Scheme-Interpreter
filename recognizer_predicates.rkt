#lang r5rs
(#%provide (all-defined))
;===============================================================
(define (build-in-procedure? expr)
  (proc-type? 'build-in-procedure expr))
;===============================================================
(define (compound-procedure? expr)
  (proc-type? 'compound-procedure expr))
;===============================================================
(define (atom? expr)
  (cond
    ((number? expr) #t)
    ((equal? expr #t) #t)
    ((equal? expr #f) #t)
    (else #f)))
;===============================================================
(define var? symbol?)
;===============================================================
(define (proc-type? type expr)
  (and (pair? expr) (equal? (car expr) type)))
;===============================================================
(define (start? expr)
  (proc-type? 'start expr))
;===============================================================
(define (if? expr)
  (proc-type? 'if expr))
;===============================================================
(define (define? expr)
  (proc-type? 'define expr))
;===============================================================
(define proc? pair?)
;===============================================================
(define (set!? expr)
  (proc-type? 'set! expr))
;===============================================================
(define (begin? expr)
  (proc-type? 'begin expr))
;===============================================================
(define (cond? expr)
  (proc-type? 'cond expr))
;===============================================================
(define (quote? expr)
  (proc-type? 'quote expr))
;===============================================================
(define (lambda? expr)
  (proc-type? 'lambda expr))
;===============================================================
(define (build-in-proc? proc)
  (proc-type? 'build-in proc))
;===============================================================
(define (true? proposition)
  (not (equal? proposition #f)))
;===============================================================