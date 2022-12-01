main :: IO ()
main = do
  input <- fmap (lines) getContents
  print $ solve input

solve :: [String] -> [Int]
solve = quickSort . addUp 0

addUp :: Int -> [String] -> [Int]
addUp curr (x : xs)
  | null x  = (curr : addUp 0 xs)
  | otherwise = addUp (curr + read x) xs
addUp curr [] = [curr]

quickSort :: [Int] -> [Int]
quickSort [] = []
quickSort (x : xs) = (quickSort [y | y <- xs, y <= x]) ++ [x] ++ (quickSort [y | y <- xs, y > x])