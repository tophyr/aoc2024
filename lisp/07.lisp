(defun cartesian-product (xs ys)
    (loop for x in xs nconc
        (loop for y in ys collect
            (list x y)
        )
    )
)
(defun iota (a b)
    (loop for x from a to b collect x)
)
(defun grid-char (grid pos)
    (if (some (lambda (i) (< i 0)) pos)
        nil
        (nth (first pos) (nth (second pos) grid))
    )
)
(defun match-string (grid start-pos target pos-step)
    (every #'equalp
        (coerce target 'list)
        (mapcar (lambda (pos) (grid-char grid pos))
            (loop for x from 0 to (length target) collect
                (list (+ (first start-pos) (* x (first pos-step))) (+ (second start-pos) (* x (second pos-step))))
            )
        )
    )
)
(defun search-pos (grid pos)
    (length
        (remove-if-not #'identity
            (mapcar (lambda (pos-step) (match-string grid pos "XMAS" pos-step))
                (cartesian-product (iota -1 1) (iota -1 1))
            )
        )
    )
)
(print
    (if (= 0 (length (uiop:command-line-arguments)))
        '"Usage: script <dat-file>"
        (let ((grid (mapcar (lambda (str) (coerce str 'list)) (uiop:read-file-lines (first (uiop:command-line-arguments))))))
            (apply #'+
                (mapcar (lambda (pos) (search-pos grid pos))
                    (cartesian-product
                        (iota 0 (length (nth 0 grid)))
                        (iota 0 (length grid))
                    )
                )
            )
        )
    )
)
