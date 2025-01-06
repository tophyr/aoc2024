(ql:quickload "split-sequence")
(defun parse-data (data-lines)
    ; data-lines
    (let ((split-lines (split-sequence:split-sequence-if (lambda (line) (equalp '"" line)) data-lines)))
        (list
            (mapcar (lambda (rule) (mapcar #'parse-integer (uiop:split-string rule :separator "|"))) (first split-lines))
            (mapcar (lambda (reprint) (mapcar #'parse-integer (uiop:split-string reprint :separator ","))) (second split-lines))
        )
    )
)
(defun is-sorted (rule reprint)
    (or
        (some #'null (mapcar (lambda (rule-elem) (find rule-elem reprint :test #'equalp)) rule))
        (< (position (first rule) reprint :from-end T :test #'equalp) (position (second rule) reprint :test #'equalp))
    )
)
(defun middle (reprint)
    (elt reprint (/ (- (length reprint) 1) 2))
)
(print
    (if (= 0 (length (uiop:command-line-arguments)))
        '"Usage: script <dat-file>"
        (let ((data (parse-data (uiop:read-file-lines (first (uiop:command-line-arguments))))))
            (let ((rules (first data)) (reprints (second data)))
                (apply #'+ (mapcar #'middle
                    (remove-if-not (lambda (reprint) (every (lambda (rule) (is-sorted rule reprint)) rules)) reprints)
                ))
            )
        )
    )
)
