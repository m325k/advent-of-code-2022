--from tenth
chunks :: Int -> [a] -> [[a]]
chunks _ [] = []
chunks l xs = (take l xs) : chunks l (drop l xs)

--from first
quickSort :: [Int] -> [Int]
quickSort [] = []
quickSort (x : xs) = (quickSort [y | y <- xs, y > x]) ++ [x] ++ (quickSort [y | y <- xs, y <= x])

main :: IO ()
main = do
  input <- fmap lines getContents
  print $ solve input


divideWorry :: Bool
divideWorry = False -- True for first subproblem, False for second

numOfRounds :: Int
numOfRounds = 10000 -- 20 for first subproblem, 10000 for second

type Queue a = ([a], [a])

toQueue :: [a] -> Queue a
toQueue x = (x, [])

push :: Queue a -> a -> Queue a
push (dq, eq) x = (dq, x : eq)

pop :: Queue a -> (a, Queue a)
pop ([], eq)     = pop (reverse eq, [])
pop (x : xs, eq) = (x, (xs, eq))

empty :: Queue a -> Bool
empty ([], []) = True
empty _ = False

data Monkey = Monkey
  {
      queue :: Queue Int,
      operation :: Int -> Int,
      divisibleBy :: Int,
      ifTrue :: Int,
      ifFalse :: Int,
      inspected :: Int
  }

solve :: [String] -> Integer
solve xs = mulMostActive $ map inspected (iterate doRound (map parseMonkey $ chunks 7 xs) !! numOfRounds)

mulMostActive :: [Int] -> Integer
mulMostActive xs = (toInteger f) * (toInteger s)
 where (f : s : _) = quickSort xs

parseMonkey :: [String] -> Monkey
parseMonkey (_ : items : operation : divisible : iftrue : iffalse : _) =
  Monkey (q items) (o operation) (d divisible) (ift iftrue) (iff iffalse) 0
  where q xs   = toQueue $ read (('[' : (drop 18 xs)) ++ "]")
        o xs   = toFunc $ words $ drop 19 xs
        d xs   = read (drop 21 xs)
        ift xs = read (drop 29 xs)
        iff xs = read (drop 30 xs)

toFunc :: [String] -> (Int -> Int)
toFunc ("old" : "*" : "old" : []) = \x -> x * x
toFunc ("old" : "+" : "old" : []) = \x -> x + x
toFunc ("old" : "*" :   num : []) = \x -> x * (read num)
toFunc ("old" : "+" :   num : []) = \x -> x + (read num)


doRound :: [Monkey] -> [Monkey]
doRound ms = foldl monkeyDo ms [0..(length ms - 1)]

monkeyDo :: [Monkey] -> Int -> [Monkey]
monkeyDo ms num
  | empty q = ms
  | otherwise = monkeyDo (update (pushItem ms (if worry item `mod` divBy == 0 then ift else iff) (worry item)) num (Monkey newQ op divBy ift iff (ins + 1))) num
  where (Monkey q op divBy ift iff ins) = ms !! num
        worry x = if divideWorry then (op x) `div` 3 else (op x) `mod` (foldr (*) 1 (map divisibleBy ms))
        (item, newQ) = pop q

pushItem :: [Monkey] -> Int -> Int -> [Monkey]
pushItem (Monkey q op divBy ift iff ins : ms) 0 item = (Monkey (push q item) op divBy ift iff ins : ms)
pushItem (m : ms) x item = m : pushItem ms (x - 1) item

update :: [Monkey] -> Int -> Monkey -> [Monkey]
update (m : ms) 0 newM = (newM : ms)
update (m : ms) x newM = m : update ms (x - 1) newM
