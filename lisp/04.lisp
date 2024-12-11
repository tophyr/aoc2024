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
                    (lambda (report)
                        (let
                            (
                                (dampened
                                    (cons report
                                        (loop for e in (make-list (length report) :initial-element report) and i from 0
                                            collect (append (subseq report 0 i) (subseq report (+ i 1)))
                                        )
                                    )
                                )
                            )
                            (some
                                (lambda (dampened_report)
                                    (or
                                        (every (lambda (a b) (and (> a b) (<= (- a 3) b))) dampened_report (rest dampened_report))
                                        (every (lambda (a b) (and (< a b) (>= (+ a 3) b))) dampened_report (rest dampened_report))
                                    )
                                )
                                dampened
                            )
                        )
                    )
                    reports
                )
            )
        )
    )
)
