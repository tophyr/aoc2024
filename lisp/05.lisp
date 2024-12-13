(ql:quickload "cl-ppcre")
(print
    (if (= 0 (length (uiop:command-line-arguments)))
        '"Usage: script <dat-file>"
        (let ((res 0))
            (ppcre:do-register-groups ((#'parse-integer a b))
                ("mul\\((\\d+),(\\d+)\\)" (uiop:read-file-string (first (uiop:command-line-arguments))) res)
                (incf res (* a b))
            )
        )
    )
)
