;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname abstraction-quiz-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
;  PROBLEM 1:
;
;  Design an abstract function called arrange-all to simplify the
;  above-all and beside-all functions defined below. Rewrite above-all and
;  beside-all using your abstract function.


;; (listof Image) -> Image 
;; combines a list of images into a single image, each image above the next one
(check-expect (above-all empty) empty-image)
(check-expect (above-all (list (rectangle 20 40 "solid" "red")
                               (star 30 "solid" "yellow")))
              (above (rectangle 20 40 "solid" "red")
                     (star 30 "solid" "yellow")))
(check-expect (above-all (list (circle 30 "outline" "black")
                               (circle 50 "outline" "black")
                               (circle 70 "outline" "black")))
              (above (circle 30 "outline" "black")
                     (circle 50 "outline" "black")
                     (circle 70 "outline" "black")))

;(define (above-all loi) empty-image)  ;stub

(define (above-all loi)
  (arrange-all above empty-image loi))



;; (listof Image) -> Image
;; combines a list of images into a single image, each image beside the next one
(check-expect (beside-all empty) (rectangle 0 0 "solid" "white"))
(check-expect (beside-all (list (rectangle 50 40 "solid" "blue")
                                (triangle 30 "solid" "pink")))
              (beside (rectangle 50 40 "solid" "blue")
                      (triangle 30 "solid" "pink")))
(check-expect (beside-all (list (circle 10 "outline" "red")
                                (circle 20 "outline" "blue")
                                (circle 10 "outline" "yellow")))
              (beside (circle 10 "outline" "red")
                      (circle 20 "outline" "blue")
                      (circle 10 "outline" "yellow")))

;(define (beside-all loi) empty-image)  ;stub

(define (beside-all loi)
  (arrange-all beside empty-image loi))


(check-expect (arrange-all above empty-image
                           (list (square 10 "solid" "pink")
                                 (triangle 20 "solid" "red")))
              (above (square 10 "solid" "pink")
                     (triangle 20 "solid" "red")))
(check-expect (arrange-all cons empty (list "a" "b" "c"))
              (cons "a" (cons "b" (cons "c" empty))))
(check-expect (arrange-all + 0 (list 1 2 3 4 5)) 15)

(define (arrange-all fun base loi)
  (cond [(empty? loi) base]
        [else
         (fun (first loi)
              (arrange-all fun base (rest loi)))]))
 

;  PROBLEM 2:
;
;  Finish the design of the following functions, using built-in abstract functions.
;
;; Function 1
;; ==========

;; (listof String) -> (listof Natural)
;; produces a list of the lengths of each string in los
(check-expect (lengths empty) empty)
(check-expect (lengths (list "apple" "banana" "pear")) (list 5 6 4))

(define (lengths lst) (map string-length lst))

;; Function 2
;; ==========

;; (listof Natural) -> (listof Natural)
;; produces a list of just the odd elements of lon
(check-expect (odd-only empty) empty)
(check-expect (odd-only (list 1 2 3 4 5)) (list 1 3 5))

(define (odd-only lon) (filter odd? lon))

;; Function 3
;; ==========

;; (listof Natural -> Boolean
;; produce true if all elements of the list are odd
(check-expect (all-odd? empty) true)
(check-expect (all-odd? (list 1 2 3 4 5)) false)
(check-expect (all-odd? (list 5 5 79 13)) true)

(define (all-odd? lon) (andmap odd? lon))

;; Function 4
;; ==========

;; (listof Natural) -> (listof Natural)
;; subtracts n from each element of the list
(check-expect (minus-n empty 5) empty)
(check-expect (minus-n (list 4 5 6) 1) (list 3 4 5))
(check-expect (minus-n (list 10 5 7) 4) (list 6 1 3))

(define (minus-n lon n) (map (λ (x) (- x n)) lon))

;  PROBLEM 3
;
;  Consider the data definition below for Region.
;  Design an abstract fold function for region,
;  and then use it do design a function that produces
;  a list of all the names of all the
;  regions in that region.
;
;  For consistency when answering the multiple choice questions,
;  please order the arguments in your
;  fold function with combination functions first, then bases, then region.
;  Please number the bases
;  and combination functions in order of where they appear in the function.
;
;  So (all-regions CANADA) would produce
;  (list "Canada" "British Columbia" "Vancouver" "Victoria"
;        "Alberta" "Calgary" "Edmonton")


(define-struct region (name type subregions))
;; Region is (make-region String Type (listof Region))
;; interp. a geographical region

;; Type is one of:
;; - "Continent"
;; - "Country"
;; - "Province"
;; - "State"
;; - "City"
;; interp. categories of geographical regions

(define VANCOUVER (make-region "Vancouver" "City" empty))
(define VICTORIA (make-region "Victoria" "City" empty))
(define BC (make-region "British Columbia" "Province" (list VANCOUVER VICTORIA)))
(define CALGARY (make-region "Calgary" "City" empty))
(define EDMONTON (make-region "Edmonton" "City" empty))
(define ALBERTA (make-region "Alberta" "Province" (list CALGARY EDMONTON)))
(define CANADA (make-region "Canada" "Country" (list BC ALBERTA)))

#;
(define (fn-for-region r)
  (local [(define (fn-for-region r)
            (... (region-name r)
                 (fn-for-type (region-type r))
                 (fn-for-lor (region-subregions r))))

          (define (fn-for-type t)
            (cond [(string=? t "Continent") (...)]
                  [(string=? t "Country") (...)]
                  [(string=? t "Province") (...)]
                  [(string=? t "State") (...)]
                  [(string=? t "City") (...)]))

          (define (fn-for-lor lor)
            (cond [(empty? lor) (...)]
                  [else
                   (... (fn-for-region (first lor))
                        (fn-for-lor (rest lor)))]))]
    (fn-for-region r)))


(check-expect (fold-region
               make-region
               cons
               empty
               "Continent" "Country" "Province" "State" "City"
               CANADA)
              CANADA)  
; fun-reg: Str X Y -> Z
; fun-lor: Z Y -> Y
; base-lor: Y 
; b1-b5: X
; (Str X Y -> Z) (Z Y -> Y) Y X X X X X Region -> Z
(define (fold-region fun-reg fun-lor base-lor b1 b2 b3 b4 b5 r)
  (local [(define (fn-for-region r) ; Z
            (fun-reg (region-name r) ; Str
                     (fn-for-type (region-type r)) ; X
                     (fn-for-lor (region-subregions r)))) ; Y

          (define (fn-for-type t)
            (cond [(string=? t "Continent") b1] ;X
                  [(string=? t "Country") b2] ;X
                  [(string=? t "Province") b3] ;X
                  [(string=? t "State") b4] ;X
                  [(string=? t "City") b5])) ;X

          (define (fn-for-lor lor)
            (cond [(empty? lor) base-lor]
                  [else
                   (fun-lor (fn-for-region (first lor)) ; Z
                            (fn-for-lor (rest lor)))]))] ; Y
    (fn-for-region r)))


(check-expect (all-names CANADA)
              (list "Canada" "British Columbia" "Vancouver" "Victoria"
                    "Alberta" "Calgary" "Edmonton"))
; (Str X Y -> Z) (Z Y -> Y) Y X X X X X Region -> Z
; Z = (listof Str)
; (Str X Y -> (listof Str)) ((listof Str) Y -> Y) Y X X X X X Region -> (listof Str)
; Y = (listof Str)
; (Str X Y -> (listof Str))
; ((listof Str) (listof Str) -> (listof Str))
; (listof Str) X X X X X Region -> (listof Str)
(define (all-names r)
  (fold-region
   (λ (str type los) (cons str los))
   append ;(λ (los1 los2) (append los1 los2))
   empty 
   0 0 0 0 0 ; can be whatever
   r))

; Let's write a function that returns the names of only Provinces and States.
(check-expect (all-prov-states CANADA)
              (list "British Columbia" "Alberta"))

(define (all-prov-states r)
  (fold-region
   (λ (str type los)
     (if type
         (cons str los)
         los))
   append
   empty
   false false true true false
   r))
 