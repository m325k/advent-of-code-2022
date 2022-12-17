main :: IO ()
main = do
  input <- fmap lines getContents
  print $ solve' input

solve :: [String] -> Int
solve xs = countDistinct state
  where (state, _, _) = foldl (\acc x -> move acc (parse x)) ([(0, 0)], (0, 0), (0, 0)) xs

solve' :: [String] -> Int
solve' xs = countDistinct state
  where (state, _) = foldl (\acc x -> move' acc (parse x)) ([(0, 0)], take 10 $ repeat (0, 0)) xs

type Pos = (Int, Int)
type State = ([Pos], Pos, Pos)
type BigState = ([Pos], [Pos])

parse :: String -> (Char, Int)
parse (c : ' ' : x) = (c, read x)

move ::  State -> (Char, Int) -> State
move state (_, 0) = state
move (visited, h, t) (dir, x) = if t /= newT then move ((newT : visited), newH, newT) (dir, x - 1) else move (visited, newH, t) (dir, x - 1)
  where newH = moveHead h dir
        newT = moveTail newH t

move' :: BigState -> (Char, Int) -> BigState
move' state (dir, 0) = state
move' (v : vs, t : [])          ('X', 1) = if v /= t then (t : v : vs, t : []) else (v : vs, t : [])
move' (visited, (h : t : rest)) ('X', 1) = if t /= newT then (vs, h : poss) else (visited, (h : t : rest))
  where newT = moveTail h t
        (vs, poss) = move' (visited, (newT : rest)) ('X', 1)

move' (visited, (h : t : rest)) (dir, x) = if t /= newT then move' (vs, newH : poss) (dir, x - 1) else move' (visited, newH : t : rest) (dir, x - 1)
  where (_, newH, newT) = move ([], h, t) (dir, 1)
        (vs, poss) = move' (visited, (newT : rest)) ('X', 1)

moveHead :: Pos -> Char -> Pos
moveHead (x, y) 'U' = (x, y + 1)
moveHead (x, y) 'D' = (x, y - 1)
moveHead (x, y) 'R' = (x + 1, y)
moveHead (x, y) 'L' = (x - 1, y)

moveTail :: Pos -> Pos -> Pos
moveTail (x1, y1) (x2, y2)
  | dist (x1, y1) (x2, y2) <= 1 = (x2, y2)
  | x1 == x2 = (x2, (y1 + y2) `div` 2)
  | y1 == y2 = ((x1 + x2) `div` 2, y2)
  | abs(x2 - x1) == abs(y2 - y1) = ((x1 + x2) `div` 2, (y1 + y2) `div` 2)
  | abs(x2 - x1) > abs(y2 - y1) = ((x1 + x2) `div` 2, y1)
  | otherwise = (x1, (y1 + y2) `div` 2)

dist :: Pos -> Pos -> Int
dist (x1, y1) (x2, y2)
  | x1 == x2 = abs $ y2 - y1
  | y1 == y2 = abs $ x2 - x1
  | otherwise = abs (x2 - x1) + abs(y2 - y1) - 1

countDistinct :: Eq a => [a] -> Int
countDistinct (x : xs)
  | x `elem` xs = countDistinct xs
  | otherwise   = 1 + countDistinct xs
countDistinct [] = 0