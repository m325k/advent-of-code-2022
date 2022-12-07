main :: IO ()
main = do
  input <- fmap lines getContents
  print $ solve' input

data Node = Dir String [Node] | File String Int deriving (Show)
data Command = Down String | Up | Insert Node | Root | Skip deriving (Show)

name :: Node -> String
name (Dir n _)  = n
name (File n _) = n

getChild :: Node -> String -> Node
getChild (Dir a (x : xs)) wanted
  | name x == wanted = x
  | otherwise = getChild (Dir a xs) wanted
getChild (Dir _ []) wanted = error $ "Child " ++ wanted ++ " not found"
getChild (File n _) wanted = error $ "Node " ++ n ++ " is a file, cannot find child " ++ wanted

solve :: [String] -> Int
solve xs = getAllSmaller 100000 $ processCommands (Dir "/" []) (map command xs)

solve' :: [String] -> Int
solve' xs = justEnough (getSize root - 40000000) (40000000 * 2) root
  where root = processCommands (Dir "/" []) (map command xs)

processCommands :: Node -> [Command] -> Node
processCommands node (Up : cs) = node
processCommands node@(Dir "/" x) (Root : cs) = processCommands node cs
processCommands node (Root : cs) = node
processCommands node (Skip : cs) = processCommands node cs
processCommands (Dir dirName xs) (Down name : cs) = processCommands (Dir dirName ((processCommands (Dir name []) (fst $ upDownCond cs)) : xs)) (snd $ upDownCond cs)
processCommands (Dir name xs) (Insert node : cs)  = processCommands (Dir name (node : xs)) cs
processCommands node [] = node

upDownCond :: [Command] -> ([Command], [Command])
upDownCond xs = f (-1) xs []
  where f 0 xs ys = (reverse ys, xs)
        f i (Down name : xs) ys = f (i - 1) xs (Down name : ys)
        f i (Up : xs) ys = f (i + 1) xs (Up : ys)
        f i (x : xs) ys = f i xs (x : ys)
        f i [] ys = (reverse ys, [])

command :: String -> Command
command "$ cd .." = Up
command "$ cd /" = Root
command ('$' : ' ' : 'c' : 'd' : ' ' : dir) = Down dir
command "$ ls" = Skip
command ('d' : 'i' : 'r' : ' ' : dir) = Skip
command s = Insert (File name (read size))
  where (size : name : []) = words s


getAllSmaller :: Int -> Node -> Int
getAllSmaller cap n@(Dir _ nodes) = (sum $ map (getAllSmaller cap) nodes) + (if size <= cap then size else 0)
  where size = getSize n
getAllSmaller cap (File _ size) = 0

getSize :: Node -> Int
getSize (File _ size) = size
getSize (Dir _ nodes) = sum $ map getSize nodes

justEnough :: Int -> Int -> Node -> Int
justEnough _ curr (File _ _)      = curr
justEnough _ curr (Dir _ [])      = curr
justEnough t curr node@(Dir a xs) = minimum (map (justEnough t update) xs)
  where update = if mySize > t && mySize < curr then mySize else curr
        mySize = getSize node
        
