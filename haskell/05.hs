import System.Environment
import Text.Regex.TDFA

main = do
    mem <- (getArgs >>= loadData)
    let r = sum $ fmap process $ commands mem
    print r

loadData [file] = readFile file
loadData _ = error "Usage: aoc <data file>"

commands mem = mem =~ "mul\\(([[:digit:]]+),([[:digit:]]+)\\)" :: [[String]]

process [_, a, b] = (read a :: Int) * (read b :: Int)
process _ = error "Invalid command"
