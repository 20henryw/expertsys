(deftemplate Letter (slot c) (slot p))

(assert (Letter (c D) (p 1)))
(assert (Letter (c A) (p 2)))
(assert (Letter (c C) (p 3)))
(assert (Letter (c A) (p 4)))
(assert (Letter (c !)))


(defrule rule-1 "Enumerate the letters"
   (Letter (c ?l1)) (Letter (c ?l2)) (Letter (c ?l3)) (Letter (c ?l4))
=>
   (printout t ?l1 ?l2 ?l3 ?l4 " ")
)

(defrule rule-2 "Enumerate the letters"
   (Letter (c ?l1)) (Letter (c ?l2 &~ ?l1))
=>
   (printout t ?l1 ?l2 " ")
)

;dynamically created rule
;only need string length to make all the rules
(bind ?rule "(defrule rulename
   (Letter (c? cl) (p ?pl)) (Letter (c? c2) (p ?p2 &~ ?p1)) ;loop
=>
   (printout t ?c1?c2 \" \") ;loop
)"
)

(build ?rule)