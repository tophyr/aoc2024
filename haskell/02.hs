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

calc left right = sum (fmap (\l -> l * freq l right) left)

freq x (y:list) = freq x list + if (x == y) then 1 else 0
freq _ [] = 0
