(ql:quickload "cl-ppcre")
(print
    (if (= 0 (length (uiop:command-line-arguments)))
        '"Usage: script <dat-file>"
        (let ((res 0) (enabled t))
            (ppcre:do-register-groups (cmd params a b)
                ("(do|don't|mul)\\(((\\d+),(\\d+))?\\)" (uiop:read-file-string (first (uiop:command-line-arguments))) res)
                (cond
                    ((string= "do" cmd) (setq enabled t))
                    ((string= "don't" cmd) (setq enabled nil))
                    ((string= "mul" cmd) (if enabled (incf res (* (parse-integer a) (parse-integer b)))))
                )
            )
        )
    )
)
