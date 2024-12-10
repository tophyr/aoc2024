(print
    (if (= 0 (length (uiop:command-line-arguments)))
        (list "Usage: script <dat-file>")
        (let
            (
                (numpairs
                    (mapcar
                        (lambda (line)
                            (mapcar
                                (lambda (str) (parse-integer str))
                                (remove-if
                                    (lambda (str) (= 0 (length str)))
                                    (uiop:split-string line :separator " ")
                                )
                            )
                        )
                        (uiop:read-file-lines (first (uiop:command-line-arguments)))
                    )
                )
            )
            (apply '+
                (mapcar
                    (lambda (left right) (abs (- left right)))
                    (sort (mapcar (lambda (numpair) (first numpair)) numpairs) '<)
                    (sort (mapcar (lambda (numpair) (second numpair)) numpairs) '<)
                )
            )
        )
    )
)
