(print
    (if (= 0 (length (uiop:command-line-arguments)))
        (list "Usage: script <dat-file>")
        (apply '+
            (mapcar
                (lambda (left right) (abs (- left right)))
                (sort
                    (mapcar
                        (lambda (line) (parse-integer (first (uiop:split-string line :separator " "))))
                        (uiop:read-file-lines (first (uiop:command-line-arguments))))
                    '<)
                (sort
                    (mapcar
                        (lambda (line) (parse-integer (first (last (uiop:split-string line :separator " ")))))
                        (uiop:read-file-lines (first (uiop:command-line-arguments))))
                    '<)
            )
        )
    )
)
