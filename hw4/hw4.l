; takes one parameter, a proper list L, and returns the number of top-level elements in L
(defun my-length (L)
    (cond ((null L) 0)
        (t (+ 1 (my-length (cdr L))))
    )
)

; takes two parameters, a symbol A and a proper list of symbols L, and returns the list starting where the symbol bound to A was found. it returns nil otherwise.
(defun my-memq (A L)
    (cond 
        ( (null L) nil) ; if L is empty
        ( ( eq A (car L) ) ( append L nil ) ) ; if the symbol is equal to the first element of the list return the list
        ( t ( append ( my-memq A (cdr L) ) nil ) ) ; else continue to recurse on the elements in the list
    )
)

; takes two proper list parameters, L1 and L2, and returns the result of appending the two lists together. use CONS to build the new list
(defun my-append (L1 L2)
    (cond 
        ( (null L1) L2 )
        ( (null L2) L1 )
        ( t ( cons (car L1) (my-append (cdr L1) L2) ) )
    )
)

; takes a proper list L and returns the reverse of L
(defun my-reverse (L)
    (cond 
        ( (null L) nil)
        ( t ( append (my-reverse (cdr L)) (cons (car L) nil) ) ) 
        ; NOTE: the (cons (car L) nil) is meant to create a list from element L
        ; so that the append works properly. try removing cons to see what it looks like
    )
)

; takes a function F and a proper list L and collects the list of results of applying the function F to each element of the list L
(defun my-mapcar (F L)
    (cond
        ( (null L) nil)
        ( t ( cons (apply F (cons (car L) nil)) (my-mapcar F (cdr L)) ) )
    )
)

; takes an S-expression L and returns a full duplicate of it in new storage
(defun my-copy (L)
    (cond
        ( (null L ) nil)
        ( (atom L) L)
        ( t ( cons (car L) (my-copy (cdr L)) ) )
    )
)

; takes a proper list L and a positive integer N and returns the tail of L beginning with the Nth element
(defun my-nth (L N)
    (cond 
        ( (null L) nil)
        ( (eq N 0 ) (cons nil L))
        ( (eq N 1) L)
        ( t (my-nth (cdr L) (- N 1)) )
    ) 
)

; takes an S-expression X and a proper list L and returns a version of L with all top level occurrences of X removed from L, giving a COPY of L with all top level elements equal to X removed
(defun my-remove (X L)
    (cond
        ( (null L) nil )
        ( (equal X (car L)) (my-remove X (cdr L)))  
        ( t ( cons (car L) (my-remove X (cdr L)) ) )
    )
)

; takes three parameters X Y Z. it replaces all occurrences of S-expression X with S-expression Y in S-expression Z
(defun my-subst (X Y Z)
    (cond 
        ( (null Z) nil )
        ( (equal X (car Z)) ( cons Y (my-subst X Y (cdr Z)) ) )
        ( (listp (car Z)) (cons ( my-subst X Y (car Z) ) ( my-subst X Y (cdr Z) )) ) 
        ( t (cons (car Z) ( my-subst X Y (cdr Z) )) )
    )
)

; takes a function FN and a proper list L and returns a subset of the elements of list L that satisfy the function FN (that means returns non-nil when FN is applied to the element)
(defun my-subset (FN L)
    (cond
        ( (null L) nil)
        ( (eq T (apply FN (cons (car L) nil))) ( cons (car L) ( my-subset FN (cdr L) ) ) )
        ( t (my-subset FN (cdr L)) )
    )
)

; takes two proper lists of single digit integers, N1 and N2, which represent large magnitude positive integer numbers called big-nums, and returns a list in this big-num representation corresponding to adding the two big-nums N1 and N2. 
(defun my-add (N1 N2)
    (defun my-add-helper (N1 N2 carry)
        (cond
            ; if both N1 and N2 is empty and has carry
            ( (and (null N1) (null N2) (eq 1 carry)) (cons carry nil) )
            (
                ; if N1 is empty but N2 still has elements and has carry
                (and (null N1) (listp N2) (eq 1 carry)) 
                (cons   
                    (mod ( + (car N2) carry ) 10 ) 
                    (my-add-helper nil (cdr N2) 1)
                )
            )
            (
                ; if N2 is empty but N1 still has elements and has carry
                (and (null N2) (listp N1) (eq 1 carry))
                (cons   
                    (mod ( + (car N1) carry ) 10 ) 
                    (my-add-helper (cdr N1) nil 1)
                )
            )
            ((and (null N1) (listp N2)) N2) ; same as above but no carry
            ((and (null N2) (listp N1)) N1) ; same as above but no carry
            ( 
                ; if the sum exceeds 10
                (> ( + (car N1) (car N2) carry ) 9 ) 
                ; then get the digit (via modulo) and then recurse on 
                ; the remaining digits with 1 as the carry
                (cons 
                    (mod ( + (car N1) (car N2) carry ) 10 ) 
                    (my-add-helper (cdr N1) (cdr N2) 1)
                )
            )
            
            (
                ; else if the sum does not exceed 10 
                t
                ; then recurse on the remaining digits
                ; with 0 as the carry
                (cons 
                    ( + (car N1) (car N2) )
                    (my-add-helper (cdr N1) (cdr N2) 0)
                )
            )
        )
    )
    
    (my-add-helper N1 N2 0)
    
)

; takes two sorted proper lists of integers L1 and L2 and returns the result of merging the two sorted lists of integers similar to how merge-sort might do it. duplicates are allowed
(defun my-merge (L1 L2)
    (cond
        ( (and (null L1) (null L2)) nil)
        ( ( and (null L1) (listp L2) ) L2) ; L1 is empty, L2 is still a list
        ( ( and (listp L1) (null L2 ) ) L1 ) ; L1 is still a list, L2 is empty
        ( 
            ; if L1 element < L2 element
            (< (car L1) (car L2)) 
            ; put the L1 element first and recurse on the remaining L1 and l2
            ( cons (car L1) (my-merge (cdr L1) L2))
        )
        (
            ; else
            t
            ; put the L2 element first and recurse on the remaining L2 and L1
            ( cons (car L2) (my-merge L1 (cdr L2)))
        )
    )
)

; takes two proper lists of atoms L1 and l2 and returns T only if L1 is a sublist of L2
(defun my-sublist (L1 L2)
    (defun my-sublist-helper (L1 L2 POS)
        (cond
            ( (null L1) T) ; this means that all the elements in L1 have been matched with elements in L2
            ( (null L2) nil)
            ; if equal, recurse on the next elements of both L1 and L2
            ( (eq (car L1) (car L2)) (and T (my-sublist-helper (cdr L1) (cdr L2) (+ POS 1))) )
            ; if the match is not consecutive (aka not a subarray)
            ( (> POS 0) nil )
            ; if not equal, recurse on the elements of L2 and keep L1
            ( t (my-sublist-helper L1 (cdr L2) POS) )
        )
    )
    (my-sublist-helper L1 L2 0)
)

; takes an atom A and an association list ALIST and returns the association pair for A in ALIST. If there is no association, it returns nil (so that you can distinguish between an unbound variable and a variable bound to nil).  An association list is a proper list of key/value pairs where the key (always a symbol) is the CAR and the value (any S-expression) is the CDR of that pair. An association list is of the form ((key1 . value1) (key2 . value2) … (keyn . valuen)) Association lists are useful for specifying variables and their bindings. This function will be useful for Homework 5 when we write EVAL.
(defun my-assoc (A ALIST)
    (cond
        ( (null ALIST) nil)
        ( (eq A (car (car ALIST))) (car ALIST) ) ; return the list once the car of a list matches the A atom
        ( t (my-assoc A (cdr ALIST)) )
    )
)

; takes an association list ALIST and an arbitrary S-expression L that returns L with each variable (key) in ALIST replaced with the corresponding value it is bound to in ALIST
(defun my-replace (ALIST L)
    ; passes the atom element and the alist to my-assoc to see if there's a key-value pair that matches
    ; take the cdr to get the "value" from the key-value pair
    (cond 
        ( (null L) nil)
        ; use the original element if no key-value pair found
        ( (null (cdr (my-assoc (car L) ALIST))) (cons 
            (car L)
            (my-replace ALIST (cdr L))
        ))
        ; use the value if a key-value pair found
        (t (cons 
            (cdr (my-assoc (car L) ALIST))
            (my-replace ALIST (cdr L))
        ))
    )
)

(defun testallhw4 ()
    (PRINT (MY-LENGTH NIL))
    (PRINT (MY-LENGTH '(B (A B C))))
    (PRINT (MY-LENGTH '(A (((B))) C)))
    (PRINT (MY-LENGTH '(A B C)))
(TERPRI)
    (PRINT (MY-MEMQ 'A NIL))
    (PRINT (MY-MEMQ 'B '(A B C)))
    (PRINT (MY-MEMQ 'D '(A B C D E F G)))
    (PRINT (MY-MEMQ 'D '(A B C D)))
    (PRINT (MY-MEMQ 'D '(A B C)))
(TERPRI)
    (PRINT (MY-APPEND '(A B C) '(D E F)))
    (PRINT (MY-APPEND '((A) (B) (C)) '((D) (E) (F))))
    (PRINT (MY-APPEND NIL '(D E F)))
    (PRINT (MY-APPEND '(A B C) NIL))
(TERPRI)
    (PRINT (MY-REVERSE NIL))
    (PRINT (MY-REVERSE '(A)))
    (PRINT (MY-REVERSE '(1 2 3 4 5)))
    (PRINT (MY-REVERSE '((1 2 3) 4 ((5 6)))))
(TERPRI)
    (PRINT (MY-MAPCAR 'CAR '((A B C) (X Y Z) (1 2 3))))
    (PRINT (MY-MAPCAR 'CDR '((A B C) (X Y Z) (1 2 3))))
    (PRINT (MY-MAPCAR '1+ '(1 3 5 7)))
    (PRINT (MY-MAPCAR 'ATOM '(A (B) C (D) E)))
(TERPRI)
    (PRINT (MY-COPY '(A B ((C 1)) 2 3)))
    (PRINT (MY-COPY '(1 2 3)))
    (PRINT (MY-COPY '(A B . C)))
    (PRINT (EQ (SETQ L '(A (B) C)) (MY-COPY L)))
(TERPRI)
    (PRINT (MY-NTH '(A B C D E) 1))
    (PRINT (MY-NTH '(A B C D E) 3))                
    (PRINT (MY-NTH '(A B C D E) 30))               
    (PRINT (MY-NTH '(A B C D E) 0))
(TERPRI)
    (PRINT (MY-REMOVE '(A B) '(A B (A B) A A B (A B))))
    (PRINT (MY-REMOVE 'A '(A B (A B) A B)))
(TERPRI)
    (PRINT (MY-SUBST 'B 'A '(A B (A B) (C (A B)))))
(TERPRI)
    (PRINT (MY-SUBSET 'ATOM '(A (B) (C D) E F G)))
    (PRINT (MY-SUBSET 'LISTP '(A (B) (C D) E F G)))
(TERPRI)
    (PRINT (MY-ADD '(0) '(0)))
    (PRINT (MY-ADD '(1) '(1)))
    (PRINT (MY-ADD '(9) '(9)))
    (PRINT (MY-ADD '(1 1 1 1 1 1 1 1 1 1) '(9 9 9 9 9 9 9 9 9 9)))
    (PRINT (MY-ADD '(1) '(9 9 9 9 9 9 9 9 9 9)))
    (PRINT (MY-ADD '(9 9 9 9 9 9 9 9 9 9) '(1)))
(TERPRI)
    (PRINT (MY-MERGE '(1 3 5 7 9) '(2 4 6 8 10)))
    (PRINT (MY-MERGE '(1 2 3 7 8 9) '(4 5 6 10)))
    (PRINT (MY-MERGE '(1 2 3) '(4 5 6 7 8 9 10)))
    (PRINT (MY-MERGE '(1 3 5 6 7 8 9 10) '(2 4)))
    (PRINT (MY-MERGE NIL '(1 2 3 4 5 6 7 8 9 10)))
(TERPRI)
    (PRINT (MY-SUBLIST '(1 2 3) '(1 2 3 4 5)))
    (PRINT (MY-SUBLIST '(3 4 5) '(1 2 3 4 5)))
    (PRINT (MY-SUBLIST '(C D) '(A B C D E)))
    (PRINT (MY-SUBLIST '(3 4) '(1 2 3 5 6)))
    (PRINT (MY-SUBLIST '(1 2 3 4 5) '(3 4 5)))
    (PRINT (MY-SUBLIST '(2 4) '(1 2 3 4 5)))
    (PRINT (MY-SUBLIST '(1 3 5) '(1 2 3 4 5)))
(TERPRI)
    (PRINT (MY-ASSOC 'A NIL))
    (PRINT (MY-ASSOC 'A '((A . B)(C E F)(B))))
    (PRINT (MY-ASSOC 'C '((A . B)(C E F)(B))))
    (PRINT (MY-ASSOC 'B '((A . B)(C E F)(B))))
    (PRINT (MY-ASSOC 'F '((A . B)(C E F)(B))))
(TERPRI)
    (PRINT (MY-REPLACE '((G . C)(C . G)(T . A)(A . U)) '(G A T C)))
    (PRINT (MY-REPLACE '((G . C)(C . G)(T . A)(A . U)) '(G A T C C T C C A T A T A C A A C G G T)))
    (PRINT (MY-REPLACE '((G . C)(C . G)(T . A)(A . U)) '(G (A) T C C (T) C C A (T) A T A C A A (C) G G T)))
    (PRINT (MY-REPLACE '((G . C)(C . G)(T . A)(A . U)) '(G A X C C X C C A X A T A C A X C G X T)))
(TERPRI)
    (PRINT (MY-REPLACE '((UCB . UCLA)(UCSD . UCI)(BASKETBALL . TENNIS)) '(UCSD IS PLAYING BASKETBALL AGAINST UCB)))
    (PRINT (MY-REPLACE '((UCB . UCLA)(UCSD . UCI)(BASKETBALL . TENNIS)) '(UCR IS PLAYING FOOTBALL AGAINST UCSC)))

T
)
