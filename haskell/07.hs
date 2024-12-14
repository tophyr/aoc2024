import System.Environment

main = do
    grid <- (getArgs >>= loadData)
    let r = sum $ map (search grid) $ cartesian [0..length (grid!!0) - 1] [0..length grid - 1]
    print r

loadData [file] = lines <$> readFile file
loadData _ = error "Usage: aoc <data file>"

cartesian xs ys = [(x, y) | x <- xs, y <- ys]

search grid (x, y) = length $ filter id $ map (match grid (x, y) "XMAS") $ cartesian [-1..1] [-1..1]

match grid (x, y) (needle:rest) (x_step, y_step) =
    if y >= 0 && y < length grid
    then if x >= 0 && x < length (grid!!y)
        then (grid!!y)!!x == needle && match grid (x + x_step, y + y_step) rest (x_step, y_step)
        else False
    else False
match _ _ [] _ = True
