main :: IO ()
main = do
  input <- fmap lines getContents
  print $ solve input

solve :: [String] -> Int
solve (x : xs) = solve xs + if (check' $ map read $ words $ replace ',' ' ' $ replace '-' ' ' x) then 1 else 0
solve []       = 0

replace :: Eq a => a -> a -> [a] -> [a]
replace a b (x : xs)
  | a == x    = b : replace a b xs
  | otherwise = x : replace a b xs
replace _ _ [] = []

check :: [Int] -> Bool
check (x1 : y1 : x2 : y2 : []) = inside x1 y1 x2 y2 || inside x2 y2 x1 y1
  where inside x1 y1 x2 y2 = x1 <= x2 && y1 >= y2

check' :: [Int] -> Bool
check' (x1 : y1 : x2 : y2 : []) = not (outside x1 y1 x2 y2 || outside x2 y2 x1 y1)
  where outside x1 y1 x2 y2 = y1 < x2