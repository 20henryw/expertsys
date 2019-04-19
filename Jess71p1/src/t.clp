/*
* Henry Wiese
* 4.9.18
*
* With help from Neil Ramaswamy, who helped explain backwards chaining and was the
* subject of many, many yes or no questions.
*
* A collection of functions, facts, and rules that let a user play
* the think of an animal game.
* 
* The program uses backwards chaining to ask the user questions about
* the animal they are thinking of. Each animal has a specific set of
* traits that is not shared by another animal.
*
* Animals that this program can guess:
* Whale, fish, human, pig, cow, bird, eagle, chicken, penguin, zebra,
* horse, snake, cat, dog, lizard, kangaroo, koala, tiger, lion, octopus
*
* guess   - guesses 
* animals -
*/

(clear)
(reset)

(batch utilities.clp)

(do-backward-chaining mammal)    ; is it a mammal
(do-backward-chaining swim)      ; does it normally swim
(do-backward-chaining twoLegs)   ; does it have two legs
(do-backward-chaining fourLegs)  ; does it have four legs
(do-backward-chaining farm)      ; is it farm animal
(do-backward-chaining fly)       ; does it fly
(do-backward-chaining equine)    ; is it equine
(do-backward-chaining striped)   ; is it striped
(do-backward-chaining pet)       ; is it a pet
(do-backward-chaining feline)    ; is it feline
(do-backward-chaining reptile)   ; is it a reptile
(do-backward-chaining mascot)    ; is it the American mascot
(do-backward-chaining pink)      ; is it pink
(do-backward-chaining trunk)     ; does it have a trunk
(do-backward-chaining herbivore) ; is it an herbivore
(do-backward-chaining skeleton)  ; does it have an endoskeleton
(do-backward-chaining marsupial) ; is it a marsupial

(defglobal ?*qNum* = 0) ; The number of questions that have been asked. Initially zero.

(deffunction startsWithVowel (?s)
   (bind ?let (sub-string 1 1 (lowcase ?s)))
   (if (or (eq ?let "a") (eq ?let "e") (eq ?let "i") (eq ?let "o") (eq ?let "u")) then
      (bind ?out TRUE)
    else
      (bind ?out FALSE)
   )
   (return ?out)
)

/*
* Concatenates "I think your animal is a " and ?s and prints the string
* Asserts the fact done to let the system know it has found a solution and
* therefore not triggering the rule (unknown)
*/
(deffunction guess (?s)
   (if (startsWithVowel ?s) then
      (bind ?art "an ") ; ?art means article
    else
      (bind ?art "a ")
   )

   (printline (str-cat "I think your animal is " ?art ?s ". Thanks for playing!"))
   (assert (done))
   (halt)
   (return)
)

/*
* Prints out the instructions of the think of an animal game
* and runs the expert system.
*/
(deffunction animals ()
	(printline "Please answer with yes or no to the questions. If you're unsure, answer with \"?\".")
	; type yes when you are ready to begin at some point
	(run)
	(return)
)

(deffunction validate (?s)
   (bind ?c (sub-string 1 1 (lowcase ?s)))

   (if (eq ?c "y") then
      (bind ?out yes) 
   elif (eq ?c "n") then
      (bind ?out no)
   elif (eq ?c "?") then
      (bind ?out "idk")
   else
      (bind ?out null)
   )
   (return ?out)
)


/*
* Prints the question number and asks the user a question, returning their input.
* If 20 questions have been asked, it will print out a game over statement and
* and halt the system.
*/
(deffunction question (?s)
   (if (>= ?*qNum* 20) then
      (printline "I couldn't guess your animal in twenty questions!")
      (halt)
   )
   (return (askQuestion (str-cat (++ ?*qNum*) ". "?s)))
)

(deffunction assertTrait (?c ?q)
   (bind ?a (validate (question ?q)))
   (while (eq ?a null) do
      (printline "Invalid input received. Please answer with yes, no, or \"?\"")
      (-- ?*qNum*)
      (bind ?a (validate (question ?q)))
   )
   (if (eq ?a "idk") then
      (assert-string (str-cat "(" ?c " yes)"))
      (assert-string (str-cat "(" ?c " no)"))
    else
      (assert-string (str-cat "(" ?c " " ?a ")"))
   )
   (return)
)

/*
* This function was inspired by Neil Ramaswamy, who advocated for extensibility 
* in my program.
*
* Creates a string that is built into a backwrads chained rule for the trait.
* If the fact is needed, it will call (assertTrait)
*
* ?t - trait
* ?q - question
*/
(deffunction buildBackwardsRule (?t ?q)
	(bind ?out "(defrule ")
	(bind ?out (str-cat ?out ?t "Backward"))
	(bind ?out (str-cat ?out "(need-" ?t " ?) => (assertTrait " ?t " \"" ?q "\"))"))
	(build ?out)
	(return)
)

/*
* The idea for extensibility came from Neil Ramaswamy
*/
(buildBackwardsRule mammal    "Is it a mammal")
(buildBackwardsRule swim      "Does it normally swim")
(buildBackwardsRule twoLegs   "Does it have only two legs")
(buildBackwardsRule fourLegs  "Does it have only four legs")
(buildBackwardsRule farm      "Is it a farm animal")
(buildBackwardsRule fly       "Does it fly")
(buildBackwardsRule equine    "Is it equine")
(buildBackwardsRule striped   "Is it striped")
(buildBackwardsRule pet       "Is it a pet")
(buildBackwardsRule feline    "Is it feline")
(buildBackwardsRule reptile   "Is it a reptile")
(buildBackwardsRule mascot    "Is it the American mascot")
(buildBackwardsRule pink      "Is it pink")
(buildBackwardsRule trunk     "Is it a mammal")
(buildBackwardsRule herbivore "Is it a mammal")
(buildBackwardsRule skeleton  "Does it have an endoskeleton")
(buildBackwardsRule marsupial "Is it a marsupial")

(defrule mammalYes "if mammal is yes, assert no to conflicting traits"
   (mammal yes)
   =>
   (printline "asserting reptile to no")
   (assert reptile no)
)

(defrule whale "matches traits to a whale"
   (mammal yes)
   (swim yes)
   =>
   (guess "whale")
)

(defrule fish "matches traits to a fish"
   (mammal no)
   (skeleton yes)
   (swim yes)
   =>
   (guess "fish")
)

(defrule human "matches traits to a human"
   (mammal yes)
   (twoLegs yes)
   =>
   (guess "human")
)

(defrule pig "matches traits to a pig"
   (mammal yes)
   (farm yes)
   (pink yes)
   =>
   (guess "pig")
)

(defrule cow "matches traits to a cow"
   (mammal yes)
   (farm yes)
   (pink no)
   (equine no)
   =>
   (guess "cow")
)

(defrule bird "matches traits to a bird"
   (mammal no)
   (fly yes)
   (farm no)
   (not (mascot yes))
   =>
   (guess "bird")
)

(defrule eagle "matches traits to an eagle"
   (mammal no)
   (fly yes)
   (farm no)
   (mascot yes)
   (not (mascot no))
   =>
   (guess "eagle")
)

(defrule chicken "matches traits to a chicken"
   (mammal no)
   (farm yes)
   =>
   (guess "chicken")
)

(defrule penguin "matches traits to a penguin"
   (mammal no)
   (twoLegs yes)
   (swim yes)
   =>
   (guess "penguin")
)

(defrule zebra "matches traits to a zebra"
   (mammal yes)
   (equine yes)
   (striped yes)
   =>
   (guess "zebra")
)

(defrule horse "matches traits to a horse"
   (mammal yes)
   (equine yes)
   (striped no)
   =>
   (guess "horse")
)

(defrule snake "matches traits to a snake"
   (mammal no)
   (reptile yes)
   (fourLegs no)
   (twoLegs no)
   =>
   (guess "snake")
)

(defrule cat "matches traits to a cat"
   (mammal yes)
   (pet yes)
   (feline yes)
   =>
   (guess "cat")
)

(defrule dog "matches traits to a dog"
   (mammal yes)
   (pet yes)
   (equine no)
   (feline no)
   =>
   (guess "dog")
)

(defrule lizard "matches traits to a lizard"
   (mammal no)
   (fourLegs yes)
   (reptile yes)
   =>
   (guess "lizard")
)

(defrule kangaroo "matches traits to a kangaroo"
   (mammal yes)
   (marsupial yes)
   (twoLegs yes)
   =>
   (guess "kangaroo")
)

(defrule koala "matches traits to a koala"
   (mammal yes)
   (marsupial yes)
   (fourLegs yes)
   =>
   (guess "koala")
)

(defrule tiger "matches traits to a tiger"
   (mammal yes)
   (feline yes)
   (pet no)
   (striped yes)
   =>
   (guess "tiger")
)

(defrule lion "matches traits to a lion"
   (mammal yes)
   (feline yes)
   (pet no)
   (striped no)
   =>
   (guess "lion")
)

(defrule octopus "matches traits to an octopus"
   (mammal no)
   (skeleton no)
   =>
   (guess "octopus")
)

(defrule elephant "matches traits to an elephant"
   (mammal yes)
   (farm no)
   (trunk yes)
   (herbivore yes)
   =>
   (guess "elephant")
)

(defrule anteater "matches traits to an anteater"
   (mammal yes)
   (farm no)
   (trunk yes)
   (herbivore no)
   =>
   (guess "anteater")
)



(defrule unknown "finishes the game if the animal cannot be guessed"
	(declare (salience -1000))
	(not (done))
	=>
	(printline "I can't think of your animal! You must know a lot of animals.")
)


;(animals)

