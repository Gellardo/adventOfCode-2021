#lang racket

(define (position-update pos line)
  ;(printf "~s ~s\n" (~s pos) (~s line))
  (cond
    [(string-prefix? line "forward ") (cons (+ (car pos) (string->number (substring line 8))) (cdr pos))]
    [(string-prefix? line "up ") (cons (car pos) (- (cdr pos) (string->number (substring line 3))))]
    [(string-prefix? line "down ") (cons (car pos) (+ (cdr pos) (string->number (substring line 5))))]
    [else (printf "unknown action '~s'" line)]))
(define (recurse pos in)
  (let ([line (read-line in)])
    (if (eof-object? line) pos (recurse (position-update pos line) in))))
(call-with-input-file "day2.txt"
                      (lambda (in)
                        (define pos (cons 0 0))
                        (let ([final (recurse pos in)])
                          (printf "part 1: ~s\n" (* (car final) (cdr final))))))

(define (correct-position-update pos-aim line)
  (let ([pos (car pos-aim)] [aim (cdr pos-aim)])
    ;(printf "~s ~s ~s\n" (~s pos) (~s aim) (~s line))
    (cond
      [(string-prefix? line "forward ")
        (let ([x (string->number (substring line 8))])
          (cons (cons (+ (car pos) x) (+ (cdr pos) (* x aim))) aim))]
      [(string-prefix? line "up ") (cons pos (- aim (string->number (substring line 3))))]
      [(string-prefix? line "down ") (cons pos (+ aim (string->number (substring line 5))))]
      [else (printf "unknown action ~s\n" line)])))
(define (correct-recurse pos-aim in)
  (let ([line (read-line in)])
    (if (eof-object? line) pos-aim (correct-recurse (correct-position-update pos-aim line) in))))
(call-with-input-file "day2.txt"
                      (lambda (in)
                        (define pos (cons 0 0))
                        (define aim 0)
                        (let ([final (car (correct-recurse (cons pos aim) in))])
                          (printf "part 2: ~s\n" (* (car final) (cdr final))))))
; alternatively use current-input-port to read from stdin
