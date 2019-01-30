/* Henry Wiese
* 1.29.19
* Collection of functions to return the Fibonacci sequence
*/

(batch utilities.clp)

/* Return the first n numbers of the fibonnaci sequence
* precondition: n is a positive integer
* loads but errors out when a number is called
*/
(deffunction fibo (?n)
   (bind ?list (create$))
   (for (bind ?i 0) (< ?i ?n) (++ ?i)
      (if (< ?i 2) then
         (bind ?list (create$ 1 ?list))
       else
         (bind ?len (length$ ?list))
	  (bind ?list (create$ (+ (nth$ ?len ?list) (nth$ (- ?len 1) ?list))))
      ) 
   )
   (return ?list)
)
