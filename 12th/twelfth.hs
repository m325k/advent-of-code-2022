-- from eleventh
type Queue a = ([a], [a])

push :: Queue a -> a -> Queue a
push (dq, eq) x = (dq, x : eq)

pop :: Queue a -> (a, Queue a)
pop ([], eq)     = pop (reverse eq, [])
pop (x : xs, eq) = (x, (xs, eq))

empty :: Queue a -> Bool
empty ([], []) = True
empty _ = False

-- from third
alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

priority :: Char -> Int
priority 'S' = priority 'a'
priority 'E' = priority 'z'
priority c = order c alphabet 1
  where order c (a : as) r = if c == a then r else order c as (r + 1)

main :: IO ()
main = do
  input <- fmap lines getContents
  print $ solve input

type Node = Char
type QueueElement = ((Int, Int), Int)
type History = [(Int, Int)]

solve :: [String] -> Int
solve xs = expand xs (initQueue' (0, 0) xs) []

initQueue :: (Int, Int) -> [String] -> Queue QueueElement
initQueue (x, y) ([] : xs) = initQueue (0, y + 1) xs
initQueue (x, y) ((n : ns) : nss) = if n == 'S' then ([((x, y), 0)], []) else initQueue (x + 1, y) (ns : nss)

initQueue' :: (Int, Int) -> [String] -> Queue QueueElement
initQueue' (x, y) ([] : xs) = initQueue' (0, y + 1) xs
initQueue' (x, y) ((n : ns) : nss)
  | n == 'a' = (((x, y), 0) : (fst $ initQueue' (x + 1, y) (ns : nss)), [])
  | otherwise = initQueue' (x + 1, y) (ns : nss)
initQueue' _ [] = ([], [])

dxdy :: [(Int, Int)]
dxdy = [(0, -1), (1, 0), (0, 1), (-1, 0)]


expand :: [[Node]] -> Queue QueueElement -> History -> Int
expand xs queue history
  | empty queue = -1
  | ((xs !! y) !! x) == 'E' = snd node
  | (x, y) `elem` history = expand xs q history
  | otherwise = expand xs newQ ((fst node) : history)
  where (node, q) = pop queue
        (x, y) = fst node
        newQ = foldr (\d acc -> expandOne xs node history d acc) q dxdy

expandOne :: [[Node]] -> QueueElement -> History -> (Int, Int) -> Queue QueueElement -> Queue QueueElement
expandOne xs ((x, y), step) history (dx, dy) q
  | not $ checkBounds xs newX newY = q
  | (newX, newY) `elem` history = q
  | priority ((xs !! newY) !! newX) - priority ((xs !! y) !! x) > 1 = q
  | otherwise = push q ((newX, newY), step + 1)
  where newX = x + dx
        newY = y + dy

checkBounds :: [[Node]] -> Int -> Int -> Bool
checkBounds xs@(h : _) x y
  | x < 0 || x >= length h  = False
  | y < 0 || y >= length xs = False
  | otherwise = True

