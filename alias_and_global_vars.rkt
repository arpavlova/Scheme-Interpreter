#lang r5rs
(#%provide (all-defined))

;===============================================================
(define first-frame car)
;===============================================================
(define rest-frames cdr)
;===============================================================
(define get-quotation cadr)
;===============================================================
(define condition-if cadr)
;===============================================================
(define if-consequent caddr)
;===============================================================
(define if-else cadddr)
;===============================================================
(define build-in-var
  (list (cons '+ (cons 'build-in-procedure +))
        (cons '- (cons 'build-in-procedure -))
        (cons '* (cons 'build-in-procedure *))
        (cons '/ (cons 'build-in-procedure /))
        (cons '> (cons 'build-in-procedure >))
        (cons '< (cons 'build-in-procedure <))
        (cons '= (cons 'build-in-procedure =))
        (cons '>= (cons 'build-in-procedure >=))
        (cons '<= (cons 'build-in-procedure <=))
        (cons 'abs (cons 'build-in-procedure abs))
        (cons 'sqrt (cons 'build-in-procedure sqrt))
        (cons 'expt (cons 'build-in-procedure expt))
        (cons 'log (cons 'build-in-procedure log))
        (cons 'sin (cons 'build-in-procedure sin))
        (cons 'cos (cons 'build-in-procedure cos))
        (cons 'tan (cons 'build-in-procedure tan))
        (cons 'floor (cons 'build-in-procedure floor))
        (cons 'round (cons 'build-in-procedure round))
        (cons 'ceiling (cons 'build-in-procedure ceiling))
        (cons 'number? (cons 'build-in-procedure number?))
        (cons 'integer? (cons 'build-in-procedure integer?))
        (cons 'zero? (cons 'build-in-procedure zero?))
        (cons 'positive? (cons 'build-in-procedure positive?))
        (cons 'negative? (cons 'build-in-procedure negative?))
        (cons 'cons (cons 'build-in-procedure cons))
        (cons 'cdr (cons 'build-in-procedure cdr))
        (cons 'car (cons 'build-in-procedure car))
        (cons 'list (cons 'build-in-procedure list))
        (cons 'null? (cons 'build-in-procedure null?))
        (cons 'equal? (cons 'build-in-procedure equal?))
        (cons 'not (cons 'build-in-procedure not))))
;===============================================================
(define environment (list build-in-var))
;===============================================================