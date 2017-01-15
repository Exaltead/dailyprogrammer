; compliable with clisp

(defun count_chars (letter word)
  "Counts the frequency of the letter"
  (let ((frequency 0))
    (dotimes (n (length word))
      (if (char= (char word n) letter)
        (setf frequency (+ frequency 1))))
    (return-from count_chars frequency)))


(defun scrabble (palet word)
  "Tests if the word can be made with the given palet"
  (dotimes (i (length word))
    (let ((letter (char word i)))
      (if (> (count_chars letter word) (count_chars letter palet))
      (return-from scrabble nil))))
  (return-from scrabble t))

(defun test-if-possible (input1 input2 function)
  (if (funcall function input1 input2)
  (format t "~a can be done with ~a~%" input2 input1)
  (format t "~a can be not done with ~a~%" input2 input1)))

; Testing
(test-if-possible "ladilmy" "daily" 'scrabble)
(test-if-possible "eerriin" "eerie" 'scrabble)
(test-if-possible "orrpgma" "program" 'scrabble)
(test-if-possible "orppgma" "program" 'scrabble)
;(write (count_chars #\a "aaaaaa"))
;(write (count_chars #\a "abdc"))
;(write (count_chars #\a "fghjk"))

;(write-line (with-output-to-string (*trace-output*)
;  (time (count_chars #\a "aaaaaaubgvkuherbvhbkusrbvkubreakbfbweolbdewbfncnoijaadaadadawsdveafcadc"))))
