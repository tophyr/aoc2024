import System.Environment
import Data.List

main = do
    (left, right) <- (getArgs >>= loadData)
    let r = calc left right
    print r

loadData [] = error "Usage: 01 <data file>"
loadData [file] = do
    list <- fmap read <$> words <$> readFile file
    return (lefts list, rights list)

lefts (left:right:rest) = left : lefts rest
lefts _ = []
rights (left:right:rest) = right : rights rest
rights _ = []

calc left right =
    sum (
        fmap (\(l, r) -> abs (l - r)) (
            zip (sort left) (sort right)
        )
    )
