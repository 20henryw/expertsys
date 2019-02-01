/* Henry Wiese
* 1.29.19
* Collection of functions to generate the first n numbers of the fibonacci sequence
*
* fibo         - returns first n numbers of the fibonacci sequence
* isPosInteger - returns TRUE if the input is a positive integer value, else FALSE
* fibonacci    - validates input with isPosInteger, then calls fibo
* fib          - prompts user for input, runs fibonacci
*/

(batch utilities.clp)

/* Return the first n numbers of the fibonnaci sequence
* precondition: n is a positive integer value
*/
(deffunction fibo (?n)
   (bind ?list (create$))
   (for (bind ?i 0) (< ?i ?n) (++ ?i)
      (if (< ?i 2) then
         (bind ?list (create$ ?list 1))
       else
         (bind ?len (length$ ?list))
	 (bind ?list (create$ ?list (+ (nth$ ?len ?list) (nth$ (- ?len 1) ?list))))
      ) 
   )
   (return ?list)
)

/* Returns true if the input is a positive integer value (any representation)
*/
(deffunction isPosInteger (?n)
   (if (eq* TRUE (numberp ?n)) then ; is a number
      (if (> ?n 0) then             ; is positive
         (bind ?nInt (integer ?n))
         (if (= ?n ?nInt) then      ; is an integer value
            (bind ?out TRUE)
          else
            (bind ?out FASLE)
         )
       else
         (bind ?out FALSE)
      )
    else
      (bind ?out FALSE)
   )
   (return ?out)
)

/* Returns the first n number of the fibonacci sequence.
* The number is validated by isPosInteger before calling fibo
*/
(deffunction fibonacci (?n)
   (if (eq* TRUE (isPosInteger ?n)) then
      (bind ?out (fibo ?n))
    else
      (bind ?out FALSE)
   )
   (return ?out)
)

/* Prompts user for a number, then calls fibonacci on the read value. 
* Will print out a list of fibonacci values or an error message for invalid input.
*/
(deffunction fib ()
   (bind ?n (ask "Input a positive integer value: "))
   (bind ?v (fibonacci ?n))
   (if (eq* FALSE ?v) then 
      (bind ?out FALSE) (printline "Non-valid input received")
    else (bind ?out ?v)
   )
   (return ?out)
)