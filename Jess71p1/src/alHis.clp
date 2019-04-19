/* 
* Henry Wiese
* 2.5.29
*
* Collection of functions that count the number of letters in an input string
* and create an alphabetic histogram listing the number of times each
* letter appears.
*
* slice$    - returns a list of characters of non whitespace chars of a string
* lowslice$ - slice$, but returns lowercase letters
* alHis     - Outputs the alphabetic histogram of chars in a string
*/

(batch utilities.clp)
(bind ?NUM_LETTERS 256) ; letters in the ascii character set

/* 
* Removes whitespace from a list of text and returns a list of 
* the characters.
*
* Takes a string, and iterates through it adding chars to a list.
* Gets a character from the input string using sub-string, explodes it,
* then adds it to a list. Whitespace is removed by explode$.
* this function handles semicolons properly
* 
* precondition: ?t is a string
*/
(deffunction slice$ (?t)
   (bind ?strlen (str-length ?t))
   (bind ?l (create$))
   (for (bind ?i 1) (<= ?i ?strlen) (++ ?i) ;start at 1 to make sub-string cleaner
      (bind ?l (create$ ?l (explode$ (sub-string ?i ?i ?t))))
   )
   (return ?l)
)

/* 
* Converts a string to lowercase, then calls slice$ on the string
* precondition: ?t is a string
*/
(deffunction lowslice$ (?t)
   (return (slice$ (lowcase ?t)))
)


/*
* Takes a string, counts the number of each ascii character and stores the count
* in a list, and then iterates through the list and prints out the number of
* alphabetic characters in the input string
*
* precondition: ?t is a string in ascii encoding
*/
(deffunction alHis (?t)
   (bind ?t (slice$ ?t))
   (bind ?l (create$))

   (for (bind ?i 0) (< ?i ?NUM_LETTERS) (++ ?i) ; creates list w/ 1 element per char
      (bind ?l (create$ ?l 0))
   )

   (foreach ?c ?t
      (bind ?cAsc (asc ?c))
      (bind ?l (replace$ ?l ?cAsc ?cAsc (+ 1 (nth$ ?cAsc ?l))))
   )

   ; the following magic numbers are only used here
   ; 97 is ascii small a
   ; 122 is ascii small z
   ; 32 is the difference between ascii small a and big A
   (for (bind ?i 97) (<= ?i 122) (++ ?i)
      (printline (format nil "%c: %d" ?i (+ (nth$ ?i ?l) (nth$ (- ?i 32) ?l))))
   )

   (return)
)
   
   
