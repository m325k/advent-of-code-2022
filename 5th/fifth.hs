type Board = [[Char]]
type Move = (Int, Int, Int)

main :: IO ()
main = do
  input <- fmap lines getContents
  print $ solve input

solve :: [String] -> String
solve xs = readTop $ applyMoves (initBoard $ fst splitted) (initMoves $ snd splitted)
  where splitted = splitInput xs

splitInput :: [String] -> ([String], [String])
splitInput xs = (reverse $ fst splitted, snd splitted)
  where split (x : xs) up = if null x then (up, xs) else split xs (x : up)
        splitted = split xs []

initBoard :: [String] -> Board
initBoard xs = foldr addLine (take ((1 + (length $ head xs)) `div` 4) $ repeat []) xs

addLine :: String -> Board -> Board
addLine (_ : c : _ : _ : xs) (stack : ss) = if c == ' ' then (stack : addLine xs ss) else ((c : stack) : addLine xs ss)
addLine (_ : c : _ : [])     (stack : []) = if c == ' ' then (stack : []) else ((c : stack) : [])

initMoves :: [String] -> [Move]
initMoves (x : xs) = (read $ w !! 1, read $ w !! 3, read $ w !! 5) : initMoves xs
  where w = words x
initMoves [] = []

applyMoves :: Board -> [Move] -> Board
applyMoves b (m : ms) = applyMoves (applyMove b m) ms
applyMoves b []       = b

applyMove :: Board -> Move -> Board
applyMove b (q, from, to) = setStack (setStack b (from - 1) (snd p)) (to - 1) (push' (fst p) (b !! (to - 1)))
  where p = pop q (b !! (from - 1))

pop :: Int -> [a] -> ([a], [a])
pop q xs = pop' q ([], xs)
  where pop' 0    (front, back)   = (front, back)
        pop' _    (front, [])     = (front, [])
        pop' quan (front, b : bs) = pop' (quan - 1) (b : front, bs)

push :: [a] -> [a] -> [a]
push (x : xs) ys = x : (push xs ys)
push [] ys       = ys

push' :: [a] -> [a] -> [a]
push' (x : xs) ys = push' xs (x : ys)
push' [] ys       = ys

setStack :: Board -> Int -> [Char] -> Board
setStack (b : bs) 0   stack = stack : bs
setStack (b : bs) pos stack = b : setStack bs (pos - 1) stack

readTop :: Board -> String
readTop [] = []
readTop (b : bs) = head b : readTop bs