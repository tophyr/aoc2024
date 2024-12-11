(print
    (if (= 0 (length (uiop:command-line-arguments)))
        (list "Usage: script <dat-file>")
        (let
            (
                (reports
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
            (length
                (remove-if-not
                    (lambda (report) (or
                            (every (lambda (a b) (and (> a b) (<= (- a 3) b))) report (rest report))
                            (every (lambda (a b) (and (< a b) (>= (+ a 3) b))) report (rest report))
                        )
                    )
                    reports
                )
            )
        )
    )
)
