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
            (let
                (
                    (lefts (mapcar (lambda (numpair) (first numpair)) numpairs))
                    (rights (mapcar (lambda (numpair) (second numpair)) numpairs))
                )
                (apply '+ (mapcar (lambda (left) (abs (* left (count left rights)))) lefts))
            )
        )
    )
)
