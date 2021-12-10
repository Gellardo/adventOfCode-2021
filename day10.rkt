#lang racket


; (define (stuff param1) () () ())
; (first list) (rest list)
; (cond [(empty? x) ()] [(cons? x) ()] [else ()])

(define (check-line line stack)
  ; check line for unbalanced parents,
  ; returns first faulty closing parent, else remaining list of closing parents
  (cond
    [(empty? line) stack]
    [(eq? (first line) #\() (check-line (rest line) (cons #\) stack))]
    [(eq? (first line) #\[) (check-line (rest line) (cons #\] stack))]
    [(eq? (first line) #\{) (check-line (rest line) (cons #\} stack))]
    [(eq? (first line) #\<) (check-line (rest line) (cons #\> stack))]
    [else (cond [(empty? stack)
                 ;(printf "empty stack\n")
                 (first line)]
                [(eq? (first line) (first stack)) (check-line (rest line) (rest stack))]
                [else
                 ;(printf "unmatched closing paren: ~s != ~s\n" (first line) (first stack))
                 (first line)])]))

(require rackunit)
(test-case "invalid lines"
           (check-equal? (check-line (string->list "]") '()) #\])
           (check-equal? (check-line (string->list "(>") '()) #\>))
(test-case "valid lines"
           (check-equal? (check-line (string->list "([{<>}])") '()) '())
           (check-equal? (check-line (string->list "([{<>}])(<") '()) (list #\> #\))))

(define (parent->num x)
  (cond
    [(eq? x #\)) 3]
    [(eq? x #\]) 57]
    [(eq? x #\}) 1197]
    [(eq? x #\>) 25137]
    ))
(test-equal? "parent->num works as expected" (parent->num #\)) 3)

(define (checksum-illegal lines)
  (foldr + 0 (map parent->num (filter char? (map (curryr check-line '()) (map string->list lines))))))
(test-equal? "checksum-illegal" (checksum-illegal (list "()" "(<)" "[]]")) 60)

(printf "part 1: ~s\n" (checksum-illegal (file->lines "day10.txt")))

(test-equal? "correct stack"
             (list->string
              (append (string->list "(<[{")
                      (check-line (string->list "(<[{") '())))
             "(<[{}]>)")

(define (autocorrect-score lines)
  ((curryr sort >) (map (curry foldl correction-score 0) (filter cons? (map (curryr check-line '()) (map string->list lines))))))
(define (parent->ascore x)
  (cond
    [(eq? x #\)) 1]
    [(eq? x #\]) 2]
    [(eq? x #\}) 3]
    [(eq? x #\>) 4]
    ))
(define (correction-score e acc)
  ;(printf "test ~s +  5*~s\n" e acc)
  (+ (parent->ascore e) (* 5 acc)))
(test-equal? "correction-scoring" (foldl correction-score 0 (string->list ")}>]})")) 5566)
(test-equal? "autocorrect-score" (autocorrect-score (list "({[<{(")) (list 5566))

(define (median lst)
  ; assumes uneven length (guaranteed by the task)
  (let ([len (length lst)])
    (list-ref lst (+ (quotient len 2)))))
(test-equal? "median?" (median (list 4 2 5 7 8)) 5)

(printf "part 2: ~s\n" (median (autocorrect-score (file->lines "day10.txt"))))
