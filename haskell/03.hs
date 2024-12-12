import System.Environment
import Data.List

main = do
    reports <- (getArgs >>= loadData)
    let r = calc reports
    print r

loadData [file] = fmap (\l -> fmap read $ words l) <$> lines <$> readFile file
loadData _ = error "Usage: aoc <data file>"

calc reports = length $ filter is_safe reports

safe_asc a b = a < b && a + 3 >= b
safe_desc a b = a > b && a - 3 <= b
is_safe report = or $ map (\f -> all (uncurry f) (zip report $ drop 1 report)) [safe_asc, safe_desc]
