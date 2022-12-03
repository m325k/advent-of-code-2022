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
