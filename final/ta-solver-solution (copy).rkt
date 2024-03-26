;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname ta-solver-solution) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
; ;; ta-solver-starter.rkt
;
; ;  PROBLEM 1:
; ;
; ;  Consider a social network similar to Twitter called Chirper. Each user has a name, a note about
; ;  whether or not they are a verified user, and follows some number of people.
; ;
; ;  Design a data definition for Chirper, including a template that is tail recursive and avoids
; ;  cycles.
; ;
; ;  Then design a function called most-followers which determines which user in a Chirper Network is
; ;  followed by the most people.
; ;
; (define-struct user ( name verified? following))
; ;interp.  a user on chirper with account name , wether his profile is verfied or not and a list of others
; ; users he follows
; ;user is (make-user String Boolean (ListOfUsers))
; (define U1 (make-user "Ali" true empty))
; (define U2 (shared
;                ((-0- (make-user "Omar" false (list (make-user "Ali" true (list -0-))))))
;              -0-))
; (define U3
;   (shared ((-A- (make-user "A" true (list -B-)))
;            (-B- (make-user "B" true (list -C-)))
;            (-C- (make-user "C" true (list -A-))))
;     -A-))
; 
; (define U4
;   (shared ((-A- (make-user "A" true (list -B- -D-)))
;            (-B- (make-user "B" true (list -C- -E-)))
;            (-C- (make-user "C" true (list -B-)))
;            (-D- (make-user "D" true (list -E-)))
;            (-E- (make-user "E" true (list -F- -A-)))
;            (-F- (make-user "F" true (list))))
;     -A-)) 
;            
; 
; (check-expect (max-followers (shared ((-A- (make-user "A" true (list -B- -C-)))
;                                       (-B- (make-user "B" true (list -C-)))
;                                       (-C- (make-user "C" true (list -A-))))
;                                -A-))
;               (shared ((-A- (make-user "A" true (list -B- -C-)))
;                        (-B- (make-user "B" true (list -C-)))
;                        (-C- (make-user "C" true (list -A-))))
;                 -C-))
; (check-expect (max-followers (shared ((-A- (make-user "A" true (list -B- -C-)))
;                                       (-B- (make-user "B" true empty))
;                                       (-C- (make-user "C" true (list -B-))))
;                                -A-))
;               (shared ((-A- (make-user "A" true (list -B- -C-)))
;                        (-B- (make-user "B" true empty))
;                        (-C- (make-user "C" true (list -B-))))
;                 -B-))
; (check-expect (max-followers (shared ((-A- (make-user "A" true (list -B- -C-)))
;                                       (-B- (make-user "B" true (list -A-)))
;                                       (-C- (make-user "C" true (list -A-))))
;                                -A-))
;               (shared ((-A- (make-user "A" true (list -B- -C-)))
;                        (-B- (make-user "B" true (list -A-)))
;                        (-C- (make-user "C" true (list -A-))))
;                 -A-))
; (check-expect (max-followers (shared ((-A- (make-user "A" true (list -B- -C- -D-)))
;                                       (-B- (make-user "B" true (list -C- -D-)))
;                                       (-C- (make-user "C" true (list -D-)))
;                                       (-D- (make-user "C" true (list -A-))))
;                                -A-))
;               (shared ((-A- (make-user "A" true (list -B- -C- -D-)))
;                        (-B- (make-user "B" true (list -C- -D-)))
;                        (-C- (make-user "C" true (list -D-)))
;                        (-D- (make-user "C" true (list -A-))))
;                 -D-))
; ;template rules:
; ; structural recursion encapsuled in local with tail recursie and work list accumulators
; 
; ;to-do (listofrooms) that are not visited fn-for-loe
; ;visited? (list of rooms that already visited loe)
; ; rsf is a (listofUserNFollowers) the number of follwers to the user so far
; 
; (define (max-followers u0)
;   
;   (local[(define-struct unf ( u n ))
;          (define (fn-for-user u to-do visited? rsf)
;            (if (member? (user-name u ) visited?)
;                (fn-for-lou to-do visited? rsf)
;                (fn-for-lou (append  (user-following u) to-do)
;                            (cons (user-name u) visited?)
;                            (merge-followers u rsf))))
;                             
;          (define (fn-for-lou to-do visited? rsf)
;            (cond [(empty? to-do) rsf]
;                  [else
;                   (fn-for-user (first to-do )
;                                (rest to-do )
;                                visited?
;                                rsf)]))
;          (define (merge-followers u rsf)
;            (foldr func rsf (user-following u)))
;          (define (func u loun)
;            (cond [(empty? loun) (list (make-unf u 1))]
;                  [else
;                   (if (string=? (user-name u ) (user-name (unf-u (first loun))))
;                       (cons (make-unf u (add1 (unf-n (first loun))))
;                             (rest loun))
;                       (cons (first loun) (func u (rest loun))))]))
;          ;pick the max out of the rsf
;          (define (max rsf tot tot-u)
;            (cond [(empty? rsf) tot-u]
;                  [else
;                   (if (> (unf-n (first rsf)) tot)
;                       (max (rest rsf) (unf-n (first rsf)) (unf-u (first rsf)))
;                       (max (rest rsf) tot tot-u))]))]
;                       
;                        
;     (max (fn-for-user u0 empty empty empty) 0 empty)))

;  PROBLEM 2:
;
;  In UBC's version of How to Code, there are often more than 800 students taking
;  the course in any given semester, meaning there are often over 40 Teaching Assistants.
;
;  Designing a schedule for them by hand is hard work - luckily we've learned enough now to write
;  a program to do it for us!
;
;  Below are some data definitions for a simplified version of a TA schedule. There are some
;  number of slots that must be filled, each represented by a natural number. Each TA is
;  available for some of these slots, and has a maximum number of shifts they can work.
;
;  Design a search program that consumes a list of TAs and a list of Slots, and produces one
;  valid schedule where each Slot is assigned to a TA, and no TA is working more than their
;  maximum shifts. If no such schedules exist, produce false.
;
;  You should supplement the given check-expects and remember to follow the recipe!

;; Slot is Natural
;; interp. each TA slot has a number, is the same length, and none overlap
(define-struct ta (name max avail))
;; TA is (make-ta String Natural (listof Slot))
;; interp. the TA's name, number of slots they can work, and slots they're available for
(define SOBA (make-ta "Soba" 2 (list 1 3)))
(define UDON (make-ta "Udon" 1 (list 3 4)))
(define RAMEN (make-ta "Ramen" 1 (list 2)))

(define NOODLE-TAs (list SOBA UDON RAMEN))

(define-struct assignment (ta slot))

;; Assignment is (make-assignment TA Slot)
;; interp. the TA is assigned to work the slot
;; Schedule is (listof Assignment)

; ============================= FUNCTIONS
;; (listof TA) (listof Slot) -> Schedule or false
;; produce valid schedule given TAs and Slots; false if impossible
(check-expect (schedule-tas empty empty) empty)
(check-expect (schedule-tas empty (list 1 2)) false)
(check-expect (schedule-tas (list SOBA) empty) empty)
(check-expect (schedule-tas (list SOBA) (list 1))
              (list (make-assignment SOBA 1)))
(check-expect (schedule-tas (list SOBA) (list 2)) false)
(check-expect (schedule-tas (list SOBA) (list 1 3))
              (list (make-assignment SOBA 1)
                    (make-assignment SOBA 3)))

(check-expect (schedule-tas NOODLE-TAs (list 1 2 3 4))
              (list
               (make-assignment UDON 4)
               (make-assignment SOBA 3)
               (make-assignment RAMEN 2)
               (make-assignment SOBA 1)))

(check-expect (schedule-tas NOODLE-TAs (list 1 2 3 4 5)) false)

(define (schedule-tas tas slot )
  (cond[(empty? slot) empty]
       [(empty? tas) false]
       [else
        (if (valid-slots? tas slot) 
        (exceeded-listofta tas (duplicated-slots(check-avail(filter-all-possible(all-possible tas slot)))))
        false)]))

;----------
;tas slots -> Schedule or false
;produce all the possible schedule from the given tas and slots 
(check-expect (all-possible (list SOBA ) (list 1))(list (make-assignment SOBA 1)))
(check-expect (all-possible (list SOBA UDON) (list 1 3))
              (list (make-assignment SOBA 1)
                    (make-assignment SOBA 3)
                    (make-assignment UDON 1)
                    (make-assignment UDON 3)))

(check-expect (all-possible NOODLE-TAs (list 1 2 ))
              (list (make-assignment SOBA 1)
                    (make-assignment SOBA 2)
                    (make-assignment UDON 1)
                    (make-assignment UDON 2)
                    (make-assignment RAMEN 1)
                    (make-assignment RAMEN 2)))

(define (all-possible tas slots)
  (local [(define (fn-for-tas tas slots)
            (cond [(empty? tas) empty]
                  [else
                   (append (map
                            (lambda (s) (make-assignment (first tas) s))
                            slots)
                           (fn-for-tas (rest tas) slots))]))]
    (fn-for-tas tas slots)))

; ListOfAssignment -> ListOfAssignment
;filtring all the duplicated elements in the list
(check-expect (filter-all-possible
               (list (make-assignment SOBA 1)
                     (make-assignment UDON 1)
                     (make-assignment SOBA 1)
                     (make-assignment SOBA 2)
                     (make-assignment UDON 2)
                     (make-assignment UDON 2)))
              (list (make-assignment SOBA 1)
                    (make-assignment UDON 1)
                    (make-assignment SOBA 2)
                    (make-assignment UDON 2)))


(define (filter-all-possible loass)
  (local[(define (fn-for-loass loass  visited )
           ;rsf : is the assginment that the fucntion already visited
           (cond[(empty? loass) visited]
                [else
                 (if (member (first loass) visited)
                     (fn-for-loass (rest loass) visited )
                     (fn-for-loass (rest loass) (cons (first loass) visited )))]))]
    (fn-for-loass loass empty)))

;ListOfAssignment -> ListOfAssignment
;;filtring the schedule by removing any ta asggiend to a slot not availb to him
(check-expect (check-avail
               (list (make-assignment SOBA 1)
                     (make-assignment UDON 1)
                     (make-assignment SOBA 2)
                     (make-assignment UDON 2)
                     (make-assignment SOBA 3)
                     (make-assignment UDON 3)
                     (make-assignment RAMEN 2)))
              (list (make-assignment RAMEN 2)
                    (make-assignment UDON 3)
                    (make-assignment SOBA 3)
                    (make-assignment SOBA 1)))

(define (check-avail loass )
  (local[(define (fn-for-loass loass rsf)
           ;rsf : is an accumulator of all the true assignmenet
           (cond [(empty? loass) rsf]
                 [else
                  (if (member (assignment-slot (first loass)) (ta-avail (assignment-ta (first loass))))
                      (fn-for-loass (rest loass) (cons (first loass) rsf))
                      (fn-for-loass (rest loass) rsf))]))]
    (fn-for-loass loass empty)))


;;ListOfAssignment -> ListOfAssignment
;;filtering the schedule from diffrent tas taking the same slot
(check-expect (duplicated-slots
               (list (make-assignment SOBA 1)
                     (make-assignment UDON 1)
                     (make-assignment SOBA 2)
                     (make-assignment UDON 2)
                     (make-assignment SOBA 3)
                     (make-assignment UDON 3)
                     (make-assignment RAMEN 2)))
              (list (make-assignment SOBA 3)
                    (make-assignment SOBA 2)
                    (make-assignment SOBA 1)))

(define (duplicated-slots loass)
  (local [(define (fn-for-loass loass visited rsf)
            ; visited:  is a list of all the visited slots
            ;rsf: result so far of the valid assignemnts
            (cond [(empty? loass) rsf]
                  [else
                   (if (member (assignment-slot (first loass)) visited)
                       (fn-for-loass (rest loass) visited rsf)
                       (fn-for-loass (rest loass)
                                     (cons (assignment-slot (first loass)) visited)
                                     (cons (first loass) rsf)))]))]
    (fn-for-loass loass empty empty)))
                  
;(lsitofTA) ListOfAssignment -> ListOfAssignment
;removing any ta assgined to slot more than its max-work
(check-expect (exceeded SOBA
                        (list (make-assignment SOBA 1)
                              (make-assignment UDON 1)
                              (make-assignment SOBA 2)
                              (make-assignment UDON 2)
                              (make-assignment SOBA 3)
                              (make-assignment UDON 3)
                              (make-assignment RAMEN 2)))
              (list (make-assignment SOBA 1)
                    (make-assignment SOBA 2)))                                       

(define (exceeded ta loass)
  ;acc: is accumulator of how many times did the ta assigned to slot
  ;rsf: list of all the valid assignment 
  ;   (local [(define (fn-for-loass ta loass acc rsf ) 
;             (cond [(empty? loass) rsf]
;                   [else
;                    (if (equal? ta (assignment-ta (first loass)))
;                        (if (< acc (ta-max (assignment-ta (first loass))))
;                            (fn-for-loass ta (rest loass) (add1 acc) (cons (first loass) rsf))
;                            (fn-for-loass ta (rest loass) acc rsf))
;                        (fn-for-loass ta (rest loass) acc rsf))]))]
;     (fn-for-loass ta loass 0 empty)))
  (local [(define (fn-for-loass ta loass acc  ) 
            (cond [(empty? loass) loass]
                  [else
                   (if (equal? ta (assignment-ta (first loass)))
                       (if (< acc (ta-max (assignment-ta (first loass))))
                           (cons (first loass) (fn-for-loass ta (rest loass) (add1 acc)))
                           (fn-for-loass ta (rest loass) acc ))
                       (fn-for-loass ta (rest loass) acc ))]))]
    (fn-for-loass ta loass 0 )))


(check-expect (exceeded-listofta
               (list SOBA UDON RAMEN)
               (list (make-assignment SOBA 1)
                     (make-assignment UDON 1)
                     (make-assignment SOBA 2)
                     (make-assignment UDON 2)
                     (make-assignment SOBA 3)
                     (make-assignment UDON 3)
                     (make-assignment RAMEN 2)))
              (list (make-assignment SOBA 1)
                    (make-assignment SOBA 2)
                    (make-assignment UDON 1)
                    (make-assignment RAMEN 2)))

(define (exceeded-listofta lota loass)
  (cond[(empty? lota) empty]
       [else
        (append (exceeded (first lota) loass) (exceeded-listofta  (rest lota ) loass))]))


;check if the given slots are valid to all ta
(check-expect (valid-slot? NOODLE-TAs 5) false)
(check-expect (valid-slot? NOODLE-TAs 12) false)
(check-expect (valid-slot? NOODLE-TAs 1) true)
(check-expect (valid-slot? NOODLE-TAs 2) true)

; tas Natural -> Boolean
(define (valid-slot? tas n)
  (cond [(empty? tas) false]
        [else
         (if (member? n (ta-avail (first tas)))
             true
             (valid-slot? (rest tas) n))]))
                

;tas slots -> BOOLEAN
(check-expect (valid-slots? NOODLE-TAs (list 1 2 3 4 5)) false)
(check-expect (valid-slots? NOODLE-TAs (list 1 2 3 4 )) true)
(define (valid-slots? tas slots)
  (cond [(empty? slots) true]
        [else
         (if (valid-slot? tas (first slots))
             (valid-slots? tas (rest slots))
             false)]))
