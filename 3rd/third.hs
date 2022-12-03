alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

priority :: Char -> Int
priority c = order c alphabet 1
  where order c (a : as) r = if c == a then r else order c as (r + 1)

main :: IO ()
main = do
  input <- fmap lines getContents
  print $ solve' input

solve :: [String] -> Int
solve (r : rs) = priority (cross (firstHalf r) (secondHalf r) !! 0) + solve rs
solve [] = 0

solve' :: [String] -> Int
solve' (g1 : g2 : g3 : gs) = priority (cross' g1 g2 g3 !! 0) + solve' gs
solve' [] = 0

firstHalf :: [Char] -> [Char]
firstHalf x = secondHalf $ reverse x

secondHalf :: [Char] -> [Char]
secondHalf x = sh x ((length x) `div` 2)
  where sh ys       0 = ys
        sh (y : ys) i = sh ys (i - 1)

cross :: [Char] -> [Char] -> [Char]
cross (x : xs) ys
  | elem x ys = x : cross xs ys
  | otherwise = cross xs ys
cross [] _ = []

cross' :: [Char] -> [Char] -> [Char] -> [Char]
cross' xs ys zs = cross zs $ cross xs ys
