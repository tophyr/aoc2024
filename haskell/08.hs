import System.Environment

main = do
    grid <- (getArgs >>= loadData)
    let r = length $ filter id $ map (match grid) $ cartesian [0..length (grid!!0) - 1] [0..length grid - 1]
    print r

loadData [file] = lines <$> readFile file
loadData _ = error "Usage: aoc <data file>"

cartesian xs ys = [(x, y) | x <- xs, y <- ys]

test grid (x, y) v = if y >= 0 && y < length grid && x >= 0 && x < length (grid!!y) then (grid!!y)!!x == v else False

match grid (x, y) = test grid (x, y) 'A' &&
    (((test grid (x - 1, y - 1) 'S') && (test grid (x + 1, y + 1) 'M')) || ((test grid (x - 1, y - 1) 'M') && (test grid (x + 1, y + 1) 'S'))) &&
    (((test grid (x + 1, y - 1) 'S') && (test grid (x - 1, y + 1) 'M')) || ((test grid (x + 1, y - 1) 'M') && (test grid (x - 1, y + 1) 'S')))
