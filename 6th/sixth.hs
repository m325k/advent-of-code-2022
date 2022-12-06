main :: IO ()
main = do
  input <- getContents
  print $ solve input

signalLength :: Int
signalLength = 14

solve :: String -> Int
solve = signal signalLength

signal :: Int -> String -> Int
signal index xs@(x : ts)
  | hasDuplicates (take signalLength xs) = signal (index + 1) ts
  | otherwise = index

hasDuplicates :: Eq a => [a] -> Bool
hasDuplicates (x : xs) = x `elem` xs || hasDuplicates xs
hasDuplicates []       = False
