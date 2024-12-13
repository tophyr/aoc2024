import System.Environment
import Text.Regex.TDFA
import Control.Monad.Trans.State

main = do
    mem <- (getArgs >>= loadData)
    let r = sum $ evalState (mapM process $ commands mem) True
    print r

loadData [file] = readFile file
loadData _ = error "Usage: aoc <data file>"

commands mem = mem =~ "(do|don't|mul)\\((([[:digit:]]+),([[:digit:]]+))?\\)" :: [[String]]

process :: [String] -> State Bool Int
process [_, "mul"  , _, a, b] = do
    s <- get
    if s
        then return $ (read a :: Int) * (read b :: Int)
        else return 0
process [_, "do"   , _, _, _] = do
    put True
    return 0
process [_, "don't", _, _, _] = do
    put False
    return 0
