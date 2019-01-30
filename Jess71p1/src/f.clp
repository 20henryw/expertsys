/* Henry Wiese
* 1.24.19
* Collection of functions that calculate a factorial recursively
*
* fact  - basic factorial function with no error checking
* askF  - prompts the user and calculate a factorial on the read value
* cAskF - prompts the user, validates the read value, and then calculates a factorial
*/

(batch utilities.clp)

/* Calculate the factorial of the parameter n
* precondition: n is a non-negative integer
*/
(deffunction fact (?n)
   (if (> ?n 0) then (bind ?out (* ?n (fact (- ?n 1))))
    else (bind ?out 1L)
   )
   
   (return ?out)
)

/* Factorial function that prompts the user for an input, then calls fact on the input
* precondition: user input is a non-negative integer
*/
(deffunction askF ()
   (bind ?f (askQuestion "What non-negative integer do you want to find the factorial of"))
   (return (fact ?f))
)

/* Factorial function that prompts the user for input and validates it as a positive
* integer before calling fact on the input.
* if the input is not a number return -2
* if the input is negative return -1
* non-integer numbers are truncated and then inputted into fact
*/
(deffunction cAskF ()
   (bind ?f (askQuestion "What non-negative integer do you want to find the factorial of"))
   (if (eq* TRUE (numberp ?f)) then
      (bind ?f (long (integer ?f)))
      (if (>= ?f 0) then 
         (print "Called factorial on ") (print ?f) (print " and returned ")
         (bind ?out (fact ?f)) 
       else 
          (printline "Please input a non-negative integer")
          (bind ?out (cAskF))
       )
    else 
       (printline "Please input a non-negative integer")
       (bind ?out (cAskF))
   )
   (return ?out)
)