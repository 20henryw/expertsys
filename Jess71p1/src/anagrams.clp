/* Henry Wiese
* 2.27.19
*
* A collection of facts, rules, and functions  to create anagrams.
* 9 is the max num of letters the system can run with, 10 will not batch in
*
* slice$       - returns a list of characters of non whitespace chars of a string
* assertLetter - asserts a char and position as a Letter fact
* assertList   - asserts a list of chars as individual Letter facts
* assertString - asserts a string as individual Letter facts
* isLEQNine    - returns true if the input is <= 9
* start        - creates anagrams of a user inputted string
*/

(clear)
(reset)

(batch utilities.clp)
(defglobal ?*MAX_LETTERS* = 9) ;9 is the max number of letters the system can handle

(deftemplate Letter (slot c) (slot p))


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
* Accepts a letter and a position and asserts a Letter fact with the inputs
*/
(deffunction assertLetter (?c ?p)
   (assert (Letter (c ?c) (p ?p)))
   (return)
)

/*
* Calls assertLetter on each character in the list, giving each Letter
* a unique position.
* precondition: ?l is a list
*/
(deffunction assertList (?l)
   (bind ?len (length$ ?l))
   (for (bind ?i 1) (<= ?i ?len) (++ ?i)
      (assert (Letter (c (nth$ ?i ?l)) (p ?i)))
   )
   (return)
)

/*
* Calls slice$ on the string to get a list of chars, then asserts that list
* with assertList
* precondition: ?s is a string
*/
(deffunction assertString (?s)
   (bind ?l (slice$ ?s))
   (assertList ?l)
   
   (return)
)

/*
* returns true if ?s is <= 9
* precondition: ?s is a string
*/
(deffunction isLEQNine (?s)
    return (<= (str-length ?s) ?*MAX_LETTERS*)
)

/*
* Dynamically creates facts and rules which are used to return anagrams of the 
* input string.
*
* First resets the fact space, then prompts the user for a string, 
* and then validates the string as <= MAX_LETTERS.
* Next, it creates facts by calling assertString on the input.
* Then it creates strings to build the anagram rule. A nested for loop iterates
* through the length of the string to build the LHS and RHS. The created strings
* are then concatenated to complete the rule, and then (build) is called on the
* string.
* Once everything is created, the system is run.
*/
(deffunction start ()   
   (reset)
   (bind ?s (ask "Enter a Word: "))
   
   (while (= FALSE (isLEQNine ?s)) then ;validates input
      (printline "Inavlid input received. String length is greater than nine.")
      (bind ?s (askline "Enter a word with up to nine characters: "))
   )

   (assertString ?s)
   (bind ?len (str-length ?s))
   (bind ?rule "(defrule anagram ")
   (bind ?LHS "")
   (bind ?RHS " => (printout t ")

   (for (bind ?i 1) (<= ?i ?len) (++ ?i)
      (bind ?LHS (str-cat ?LHS "(Letter (c ?l" ?i ") (p ?p" ?i))
      (bind ?RHS (str-cat ?RHS "?l" ?i " "))

      (for (bind ?j 1) (< ?j ?i) (++ ?j)
         (bind ?LHS (str-cat ?LHS " &~?p" ?j))
      )

      (bind ?LHS (str-cat ?LHS ")) "))
   )
   (bind ?RHS (str-cat ?RHS "\" \"))"))
   (bind ?out (str-cat ?rule ?LHS ?RHS))
   (build ?out)

   (return (run))   
)