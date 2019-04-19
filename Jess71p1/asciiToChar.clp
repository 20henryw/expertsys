/*
** ASCII functions for ATCS Expert Systems
**
** Dr. Eric R. Nelson
** February 6, 2019
*/ 


/*
** returns a mixed-type list of the ascii characters understood by JESS
** Control characters are represented as tokes such as NUL CR LF
** Printable characters are represented as strings
*/
(deffunction asciiList$ ()
   (return (create$
            NUL SOH STX ETX EOT ENQ ACK BEL BS "	" LF VT FF CR SO SI DLE DC1 DC2 DC3 DC4 NAK SYN ETB CAN EM SUB ESC FS GS RS US
            " " "!" "\"" "#" "$" "%" "&" "'" "(" ")" "*" "+" "," "-" "." "/"
            "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"
            ":" ";" "<" "=" ">" "?" "@"
            "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"
            "[" "\\" "]" "^" "_" "`"
            "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
            "{" "|" "}" "~" DEL
            "€" " " "‚" "ƒ" "„" "…" "†" "‡" "ˆ" "‰" "Š" "‹" "Œ" " " "Ž" " " " "
            "‘" "’" "\"" "”" "•" "–" "—" "˜" "™"
            "š" "›" "œ" " " "ž" "Ÿ" " " "¡" "¢" "£" "¤" "¥" "¦" "§" "¨" "©" "ª" "«" "¬" "­" "®" "¯" "°" "±" "²" "³" "´" "µ" "¶" "·" "¸"
            "¹" "º" "»" "¼" "½" "¾" "¿" "À" "Á" "Â" "Ã" "Ä" "Å" "Æ" "Ç" "È" "É" "Ê" "Ë" "Ì" "Í" "Î" "Ï" "Ð" "Ñ" "Ò" "Ó" "Ô" "Õ" "Ö" "×"
            "Ø" "Ù" "Ú" "Û" "Ü" "Ý" "Þ" "ß" "à" "á" "â" "ã" "ä" "å" "æ" "ç" "è" "é" "ê" "ë" "ì" "í" "î" "ï" "ð" "ñ" "ò" "ó" "ô" "õ" "ö"
            "÷" "ø" "ù" "ú" "û" "ü" "ý" "þ" "ÿ"
           ) ;create$
   ) ; return
) ; deffunction asciiList

/*
** Returns the ASCII character (as JESS understands them) for the given integer value
** Printable characters including space and TAB are returned as strings
** Control characters are returned as tokens of their code such as NUL BRK ESC
** Quotes and \ are escaped, so \" and \\ strings are returned
** If the argument is outside the range 0 to 255 then NIL is returned
** 
** Precondition: The argument must be a number. Non-integer values are simply cast as integers
**
*/
(deffunction asciiToChar (?ascii)
   (bind ?ascii (integer ?ascii))            ; don't want to crash if passes 64.5 for example, just truncate

   (if (or (< ?ascii 0) (> ?ascii 255)) then ; return NIL if value is out of the range 0 to 255
      (bind ?ret NIL)
    else
      (++ ?ascii)                            ; ASCII is zero index but lists are 1 indexed
      (bind ?ret (nth$ ?ascii (asciiList$))) ; get the character from the list of available characters
   )

   (return ?ret)
)
