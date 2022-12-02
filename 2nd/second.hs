main :: IO ()
main = do
  input <- fmap lines getContents
  print $ solve input

solve :: [String] -> Int
solve (x : xs) = score' (x !! 0) (x !! 2) + solve xs
solve []       = 0

score' :: Char -> Char -> Int
score'  'A' 'X' = score 'A' 'Z'
score'  'B' 'X' = score 'B' 'X'
score'  'C' 'X' = score 'C' 'Y'

score'  'A' 'Y' = score 'A' 'X'
score'  'B' 'Y' = score 'B' 'Y'
score'  'C' 'Y' = score 'C' 'Z'

score'  'A' 'Z' = score 'A' 'Y'
score'  'B' 'Z' = score 'B' 'Z'
score'  'C' 'Z' = score 'C' 'X'

score :: Char -> Char -> Int
score 'A' 'X' = 1 + 3
score 'B' 'X' = 1 + 0
score 'C' 'X' = 1 + 6

score 'A' 'Y' = 2 + 6
score 'B' 'Y' = 2 + 3
score 'C' 'Y' = 2 + 0

score 'A' 'Z' = 3 + 0
score 'B' 'Z' = 3 + 6
score 'C' 'Z' = 3 + 3
score a x = 0