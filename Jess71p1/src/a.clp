/* 
* Henry Wiese
* 2.5.29
*
* Collection of functions to count the number of letters in a paragraph of text,
* and then creates an alphabetic histogram listing the number of times each
* letter appears.
*/

(batch utilities.clp)
(bind ?NUM_LETTERS 26)

/* 
* Removes whitespace from a list of text and returns a list of 
* the characters.
*
* Takes a string, and iterates through it adding characters to a list.
* Gets a character from the input string using sub-string, explodes,
* then adds it to a list. Whitespace is removed in the list created by explode$
* 
* precondition: ?t must be a string
*/
(deffunction slice (?t)
   (bind ?strlen (str-length ?t))
   (bind ?l (create$))
   (for (bind ?i 1) (<= ?i ?strlen) (++ ?i) ;start at 1 to make sub-string cleaner
      (bind ?l (create$ ?l (explode$ (sub-string ?i ?i ?t))))
   )
   (return ?l)
)

/* 
* Converts a string to lowercase, then calls slice on the string
*/
(deffunction lowSlice (?t)
   (return (slice (lowcase ?t)))
)

/* 
* Takes a string, converts it to a list of characters with lowSlice, counts the number 
* of each character in the alphabet, and returns a list of the counts of each letter 
* in alphabetical order.
* 
* Create a 26 long list, then the index is for each character
*/
(deffunction alHis (?t)
   (bind ?t (lowSlice ?t))
   (bind ?l (create$)) 
   (for (bind ?i 0) (< ?i ?NUM_LETTERS) (++ ?i) ; creates list w/ 1 element per letter
      (bind ?l (create$ ?l 0))
   )

   (foreach ?c ?t
      (bind ?cAsc (asc ?c))
      (if  (and (>= ?cAsc (asc a)) (<= ?cAsc (asc z))) then
    
         (bind ?ind (- (asc ?c) (- (asc a) 1)))   ; index of char in the char array
         (bind ?l (replace$ ?l ?ind ?ind (+ 1 (nth$ ?ind ?l))))
      )
   )


   (for (bind ?i 1) (<= ?i ?NUM_LETTERS) (++ ?i) ; 
      (printline (nth$ ?i ?l))
   )
   (return)
)