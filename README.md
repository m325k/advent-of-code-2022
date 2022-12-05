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
 - made a custom priority function, could've used ord from Data.Char, 
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
  - main functions are pop and push, where the actual transfer of the `crates` happens
  - pop creates two lists, one with the popped elements and the other with the rest
  - the popped elements are then pushed onto another list
  - in the first subproblem the push happens after the recursion and in the second one before, that ensures the correct order of the `crates`
