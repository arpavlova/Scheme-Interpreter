#lang r5rs
(#%require "Final.rkt")
(#%require "helpers.rkt")
(#%require "alias_and_global_vars.rkt")
;output #t
;==============================================================
(custom-display (equal? (my-eval '(+ 3 4) environment) 7))
(custom-display (equal? (my-eval '(+ 8 4) environment) 12))
(custom-display (equal? (my-eval '(not #f) environment) #t))
(custom-display (equal? (my-eval '(not #t) environment)#f))
(my-eval '(define (sum x y) (+ x y)) environment)
(custom-display (equal? (my-eval '(sum 1 2) environment) 3))
(custom-display (equal? (my-eval '#t environment) #t))
;==============================================================

;output 7
;==============================================================
(define code '((define (h x) (+ x 2))
                  (define z 5)
                  ((if (null? '()) h g) z)))
(my-eval code environment)
;==============================================================


;output #t
;==============================================================
(define code1 '(begin
                 (define a 5)
                 (define (myFun x) (lambda (y) (/ (+ x y) 2)))
                 (define b 9)
                 ((myFun 7) a)))
(custom-display (equal? (my-eval code1 environment) 6))
;==============================================================

;output #t
;==============================================================
(define code2 '(begin
                  (define (f x) (+ x 2))
                  (define x 5)
                  ((if (null? '()) f g) x)))
(custom-display (equal? (my-eval code2 environment) 7))
;==============================================================


;output #t
;==============================================================
(my-eval '(define code3 (list 1 2)) environment)
(define code4 '(list code3 (list 3 4)))
(custom-display (equal? (my-eval code4 environment) '((1 2) (3 4))))
;==============================================================


;output #t
;==============================================================
(define code6 '(define code5 (cons (list 1 2) (list 'a 'b))))
(my-eval code6 environment)
(define code7 '(car code5))
(define code8 '(cdr code5))
(custom-display (equal? (my-eval code7 environment) '(1 2)))
(custom-display (equal? (my-eval code8 environment) '(a b)))
;==============================================================

;output #t
;==============================================================
(define code9 '(begin
                 (define (myFun1) 'agi)
                 (define num 5)
                 (if (> num 6) 'no (cond
                                     ((equal? num 6) 'no1)
                                     ((equal? (+ num 1) 6) (myFun1))
                                     (else 'nz)))))
(custom-display (equal? (my-eval code9 environment) 'agi))
;==============================================================

;output #t
;==============================================================
(define code10 '(begin
                 (define (myFun2) 'agi)
                 (define num1 5)
                 (if (> num1 6) 'no (cond
                                     ((equal? num1 6) 'no1)
                                     ((equal? (+ num1 2) 6) (myFun2))
                                     (else 'nz)))))
(custom-display (equal? (my-eval code10 environment) 'nz))
;==============================================================

;output #t
;==============================================================
(custom-display (equal? (my-eval 'num environment) 5))
;==============================================================

;output 22
;==============================================================
(define set!-code '(begin
                     (define years 21)
                     (define (agi) years)
                     (agi)
                     (set! years 22)
                     (agi)))
(custom-display (my-eval set!-code environment))
;==============================================================

;output #t
;==============================================================
(my-eval '(define var 5) environment)
(my-eval '(set! var 7) environment)
(custom-display (equal? (my-eval 'var environment) 7))

;==============================================================

;output "NO CONSEQUENT IN COND EXPRESSION" error
;==============================================================
(define code11 '(begin
                 (define (myFun3) 'agi)
                 (define num2 5)
                 (if (> num2 6) 'no (cond
                                     ((= num2 6) 'no1)
                                     ((= (+ num2 1) 6))
                                     (else 'nz)))))
(custom-display (my-eval code11 environment))
;==============================================================


;output "TOO FEW ARGUMENTS IN 'IF STEMENTS" error
;==============================================================
(define code12 '(if (> 3 4)))
(custom-display (my-eval code12 environment))
;==============================================================

;output "TOO FEW ARGUMENTS IN 'IF STEMENTS" error
;==============================================================
(define code13 '(if (> 3 4) 6))
(custom-display (my-eval code13 environment))
;==============================================================