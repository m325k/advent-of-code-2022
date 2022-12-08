data Tree = Tree
  {
    height  :: Int,
    visible :: Bool
  } deriving Show
type Forest = [[Tree]]

main :: IO ()
main = do
  input <- fmap lines getContents
  print $ solve' input

solve :: [String] -> Int
solve xs = countVisible $ iterate (rotate . sweep) (getForest xs) !! 4

solve' :: [String] -> Int
solve' xs = findMax . snd $ iterate f (forest, allScores forest) !! 3
  where forest = getForest xs
        f (w, s) = (rotate w, mul (allScores (rotate w)) (rotate s))

findMax :: [[Int]] -> Int
findMax = maximum . map maximum

getForest :: [String] -> Forest
getForest xs = map (map (\x -> Tree (read (x : [])) False)) xs

sweep :: Forest -> Forest
sweep xs = map sweepLine xs

sweepLine :: [Tree] -> [Tree]
sweepLine (x : xs) = reverse . snd $ foldl f (height x, [Tree (height x) True]) xs
  where f (maxH, ys) (Tree h v) = if h > maxH then (h, Tree h True : ys) else (maxH, (Tree h v) : ys)

rotate :: [[a]] -> [[a]]
rotate = reverse . transpose

transpose :: [[a]] -> [[a]]
transpose ([] : _) = []
transpose xs = map head xs : transpose (map tail xs)

countVisible :: Forest -> Int
countVisible = sum . map (length . filter visible)

allScores :: Forest -> [[Int]]
allScores = map scores

scores :: [Tree] -> [Int]
scores (x : xs) = score (height x) xs : scores xs
scores []       = []

score :: Int -> [Tree] -> Int
score _ [] = 0
score h ((Tree h2 _) : xs)
  | h > h2 = 1 + score h xs
  | otherwise = 1

mul :: Num a => [[a]] -> [[a]] -> [[a]]
mul = (zipWith . zipWith) (*)