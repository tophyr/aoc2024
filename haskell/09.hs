import System.Environment
import Data.List
import Data.Maybe

type BeforePage = Integer
type AfterPage = Integer
type Rule = (BeforePage, AfterPage)

type Page = Integer
type Reprint = [Page]

main = do
    (rules, reprints) :: ([Rule], [Reprint]) <- (getArgs >>= loadData)
    print $ sum $ map midpointOf $ validReprints rules reprints

loadData [file] = parse <$> break (=="") <$> lines <$> readFile file
loadData _ = error "Usage: aoc <data file>"
parse (rules, reprints) = (map parseRule rules, map parseReprint $ drop 1 reprints)
parseRule text = (\[before, after] -> (before, after)) $ map read $ split (=='|') text
parseReprint text = map read $ split (==',') text

split p list =  case dropWhile p list of
                      [] -> []
                      l' -> w : split p l''
                            where (w, l'') = break p l'

isSortedBy _ [] = True
isSortedBy p (elem:rem) = all (p elem) rem && isSortedBy p rem

midpointOf [x] = x
midpointOf (x:xs) = midpointOf (reverse xs)

pagesFollowRule (rule_a, rule_b) a b = not (rule_a == b && rule_b == a)
reprintFollowsRule reprint rule = isSortedBy (pagesFollowRule rule) reprint
validReprints rules reprints = filter (\reprint -> all (reprintFollowsRule reprint) rules) reprints
