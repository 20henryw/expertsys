/* Henry Wiese
* 1.24.19
* Calculates the factorial of a number
*/

(batch utilities.clp)

/* Calculate the factorial of the parameter n
* precondition: n is a positive integer
*/
(deffunction fact (?n)
   (if (> ?n 0) then (bind ?out (* ?n (fact (- ?n 1))))
    else (bind ?out 1L)
   )
   
   (return ?out)
)

/* Factorial function that prompts the user for an input, then calls fact on the input
* precondition: user input is a positive integer
*/
(deffunction askF ()
   (bind ?f (askQuestion "What positive integer do you want to find the factorial of"))
   (return (fact ?f))
)

/* Factorial function that prompts the user for input and validates it as a positive
* integer before calling fact on the input.
* Non-integer values are made integers by truncating fractional components
* if the input is not valid return -1
*/
(deffunction cAskF ()
   (bind ?f (askQuestion "What positive integer do you want to find the factorial of"))
   (if (eq* TRUE (numberp ?f)) then
      (bind ?f (long (integer ?f)))
      (if (>= ?f 0) then 
         (bind ?out (fact ?f)) 
       else 
          (bind ?out -1)
      )
    else (bind ?out -2)
   )
   (return ?out)
)