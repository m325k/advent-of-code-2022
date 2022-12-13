main :: IO ()
main = do
  input <- fmap lines getContents
  print $ solve' input
  
data Command = Add Int | Noop

solve :: [String] -> Int
solve xs = sum $ map (\x -> x * (cycles !! (x - 1))) (take 6 [20, 60..])
  where cycles = signal 1 (map convert xs)

solve' :: [String] -> [String]
solve' xs = chunks 40 $ zipWith (\x y -> if abs(x - y) < 2 then '#' else '.') crtPos cycles
  where cycles = signal 1 (map convert xs)
        crtPos = flatten $ take 6 $ repeat (take 40 [0..])

flatten :: [[a]] -> [a]
flatten = foldr (++) []

chunks :: Int -> [a] -> [[a]]
chunks _ [] = []
chunks l xs = (take l xs) : chunks l (drop l xs)

convert :: String -> Command
convert ('a' : 'd' : 'd' : 'x' : ' ' : x) = Add (read x)
convert _ = Noop


signal :: Int -> [Command] -> [Int]
signal x [] = [x]
signal x (Noop : cs)  = x : signal x cs
signal x (Add y : cs) = x : x : signal (x + y) cs