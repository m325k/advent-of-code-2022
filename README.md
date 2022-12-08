# Advent of code 2022

1st day
 - added the batches of numbers seperated by a blank line
 - sorted the list and last 3 numbers are the solution
 - could've kept track of the top 3 number only, but why bother

2nd day
  - there is only 9(3 for first player * 3 for the second one) combinations for all possible games,
    so i just hardcoded each one
  - the second subproblem was just a remapping of the first one

3rd day
 - for the first subproblem, divided the string into two halves, and looked for the intersection
 - for the second one reused the intersection function two times to get the intersection of three strings
 - made a custom `priority` function, could've used `ord` from `Data.Char`, 
     but wanted to have as little dependencies as possible

4th day
  - made a relatively generic replace function, to tidy up the input, it might come in handy in the later days
  - for the first subproblem i needed to check if the first range is fully contained in the other, or vice versa,
     just by comparing the bounds the answer can easily be found
  - for the second one, finding any intersection can be simplified by finding the complement function and inverting it,
    as in if the range from the first one is completely outside the second and vice versa, also just by checking the bounds

5th day
  - this one was a bit tricky because of immutability of data structures in haskell
  - the solution is to simulate the procedure with lists 
  - main functions are `pop` and `push`, where the actual transfer of the "crates" happens
  - `pop` creates two lists, one with the popped elements and the other with the rest
  - the popped elements are then pushed onto another list
  - in the first subproblem the push happens after the recursion and in the second one before, that ensures the correct order of the "crates"

6th day
  - no need to complicate, just march through the string with a window of fixed size and check if it has duplicates
  - duplicates function checks whether each element is contained in the tailing list after it

7th day
  - the solution starts of by converting the input strings to commands 
  - two of them are ignored for simplicity, denoted by the "Skip" command, and they are "$ ls" and "dir \*" where \* could be anything
  - the other commands
     - "Down dir" -> for going into a lower(if we visualize the tree of directories with root on the top) directory
     - "Up" -> for going into directory one up
     - "Insert Node" -> for adding a file to the current directory
     - "Root" -> for going up to the root directory
  - next the goal is to create a tree of the directories from those commands, that's the job of the `processCommands` function
      - it looks at the next command and executes it
      - its job is to create all subdirectories of the current directory, so when a Up or Root command is next it returns the result
      - the Down command is a bit tricky because you have to figure out where to continue from when a subdirectory is finished,
         that's accompished by counting the Up and Down commands in sequence in order to determine when do you get back
         to the current directory
  - after we have a tree it's just a matter of traversing that tree and finding the right condition from the 
    corresponding subproblem

8th day
  - the main idea to my solution is to look at one direction and then rotate the matrix and repeat that 4 times
  - the same main idea applies to both subproblems
  - for the first subproblem every tree had a visible flag and in each iteration there is a sweep from left to right,
      where the visible flag is set to true if it's currently the highest tree found, this is repeated for every row
  - for the second subproblem I kept the scores in a seperate matrix(could've put it in the Tree) and mutiplied
      and rotated them in each iteration, the score is calculated for every tree in every row and is equal to the 
      number of trees "seen" from that tree to the right
