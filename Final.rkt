#lang r5rs
(#%provide (all-defined))
(#%require "recognizer_predicates.rkt")
(#%require "helpers.rkt")
(#%require "alias_and_global_vars.rkt")

;===============================================================
(define (my-eval expr env)
  (establish-expr (make-sequence-expr expr) env))
;===============================================================
(define (make-sequence-expr expr)
  (if (list-of-expressions expr) (append (list 'start) expr) expr))
;=============================================================== 
(define (establish-expr expr env)
  (cond
    ((atom? expr) expr)
    ((var? expr) (bind-with-val expr env))
    ((start? expr) (execute-start (cdr expr) env))
    ((if? expr) (execute-if expr env))
    ((define? expr) (add-definition expr env))
    ((set!? expr) (change-binding expr env))
    ((begin? expr) (execute-begin (cdr expr) env))
    ((cond? expr) (execute-cond expr env))
    ((quote? expr) (get-quotation expr))
    ((lambda? expr) (execute-lambda expr env))
    ((pair? expr) (execute (establish-expr (car expr) env) (get-actual-params expr env)))
    (else (error "UNKNOWN EXPRESSION IN 'ESTABLISH" expr))))
;===============================================================
(define (execute proc actual-params)
  (cond
    ((build-in-procedure? proc) (execute-build-in-procedure proc actual-params))
    ((compound-procedure? proc) (execute-compound-procedure proc actual-params))
    (else (error "UNKNOWN PROCEDEURE IN 'EXECUTE!" proc))))
;===============================================================
(define (get-actual-params proc env)
  (map (lambda(i) (establish-expr i env)) (cdr proc)))
;===============================================================
(define (execute-build-in-procedure proc actual-params)
  (apply (cdr proc) actual-params))
;===============================================================
(define (execute-compound-procedure proc actual-params)
  (establish-expr (caddr proc) (append (list (make-tuples-list (cadr proc) actual-params)) (cadddr proc))))
;===============================================================
(define (bind-with-val expr environment)
  (define (look-through-frames env)
    (cond
      ((null? env) (error "UNBOUND VARIABLE!" expr))
      ((let* ((curr-frame (first-frame env)) (val (filter (lambda (i) (equal? (car i) expr)) curr-frame)))
         (if (null? val) (look-through-frames (cdr env)) (if (null? (cddr (car val))) (car (cdr (car val))) (cdr (car val))))))))
  (look-through-frames environment))
;===============================================================
(define (execute-start expr env)
  (cond
    ((null? expr) 'all-done)
    ((or (define? (car expr)) (set!? (car expr))) (begin (establish-expr (car expr) env) (execute-start (cdr expr) env)))
    (else (begin (custom-display (establish-expr (car expr) env)) (establish-expr (car expr) env)))))
;===============================================================
(define (execute-if if-statement environment)
  (define len (length (cdr if-statement)))
  (cond
    ((> len 3) (error "TOO MANY ARGUMENTS IN 'IF STATEMENT" if-statement))
    ((< len 3) (error "TOO FEW ARGUMENTS IN 'IF STEMENTS" if-statement))
    (else
     (if (true? (establish-expr (condition-if if-statement) environment))
         (establish-expr (if-consequent if-statement) environment)
         (establish-expr (if-else if-statement) environment)))))
;===============================================================
(define (add-definition expr env)
  (define current-frame (first-frame env))
  (define var (get-var expr))
  (define val (get-val expr))
  (if (already-def-in-frame? var current-frame) (error "IDENTIFIER ALREADY DEFINED!" expr)
      (let ((evalueted-value (establish-expr val env)))
        (if (pair? evalueted-value) (set-car! env (append (list (cons var evalueted-value)) current-frame))
            (set-car! env (append (list (list var (establish-expr val env))) current-frame))))))
;===============================================================    
(define (change-binding expr environment)
  (define var (get-var expr))
  (define val (get-val expr))
  (define (look-through-frames env)
    (cond
      ((null? environment) (error "UNBOUND IDENTIFIER IN 'SET!" expr))
      ((not (already-def-in-frame? var (first-frame env))) (look-through-frames (rest-frames env)))
      (else (map (lambda (i) (if (equal? (car i) var) (set-cdr! i (cons val '())) i)) (first-frame env)))))
  (look-through-frames environment))
;===============================================================
(define (execute-begin for-execution env)
  (cond
    ((null? (cdr for-execution)) (establish-expr (car for-execution) env))
    (else
     (establish-expr (car for-execution) env)
     (execute-begin (cdr for-execution) env))))
;===============================================================      
(define (execute-cond expr env)
  (define clauses (cdr expr))
  (cond
    ((null? clauses) #f)
    ((null? (cdr (car clauses))) (error "NO CONSEQUENT IN COND EXPRESSION" expr))
    ((equal? (caar clauses) 'else) (if (null? (cdr clauses)) (establish-expr (cadr (car clauses)) env) (error "ELSE IS NOT LAST CLAUS IN COND EXPRESSION")))
    ((true? (establish-expr (caar clauses) env)) (establish-expr (cadr (car clauses)) env))
    (else (execute-cond (cdr expr) env))))
;===============================================================
(define (execute-lambda expr env)
  (list 'compound-procedure (cadr expr) (caddr expr) env))
;===============================================================
(define (read-eval-print-loop)
  (custom-display "enter some code (:")
  (define input-text (read))
  (if (eof-object? input-text)
      (display "see you soon")
      (begin
        (display "the desired result is: ")
        (custom-display (my-eval input-text environment))
        (read-eval-print-loop))))

(read-eval-print-loop)

