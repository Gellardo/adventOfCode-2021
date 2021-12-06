## # Day 6
## Basically the algorithm wanders backwards through time.
##
## > Given a counter of X and Y days remaining, how many jellyfish does this produce?
##
## And since all jellyfish are independent from one another,
## we can just add up that result at the end.
##
## The algorithm is inspired by a loop-based fibonacci generator.
## Iteration is pretty simple:
## - no matter the counter, on day 0, there will be one "decendant". `J[X, 0] = 1`
## - a jellyfish with counter X at day Y will produce the same number as one with X-1 on day Y-1.
##   So `J[X, Y] = J[X-1, Y-1]`.
## - a jellyfish with counter 0 will produce 2 jellyfish and therefore the sum of their decendants.
##   So `J[0,Y] = J[6,Y-1] + J[8,Y-1]`.
##
## This leaves me with a O(<number of days> * <number of states> + <initial number of jellyfish>).
## Which, given the problem varying the number of days, simplifies to
## `O(<number of days>*c_0 + c_1) for small c_x == O(<number of days>)`.
## With minimal memory taken up.
import strutils, sequtils, std/strformat, math
import common

proc decendents(days: int): array[9, int] =
  ## basically calculating backwards:
  ## Given a number of days, how many decendants will a jellyfish with lifetime == index have.
  ## 0 days: 1 (itself), 1 day: 1 unless it had a counter of 0, then 2, ...
  var after = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  var before: array[9, int]
  for d in 1 .. days:
    before[0] = after[6] + after[8]
    for i in 1..8:
      before[i] = after[i-1]
    after = before

  return before

proc jellyfishAfter*(days: int, input: seq[int]): int =
  ## Solved both parts without redoing anything. Immediate solution
  ## (after a quick think how much of a pain a normal simulation would be)
  ## was the fibonnaci-like construction I ended up on.
  ##
  ## First dynamic programming with a lot of memoisation, then remembered
  ## that just needed the results from one timestep, so only "needs" one
  ## intermediate array.
  let lookupDecendents = decendents(days)
  return input.map(proc (x: int): int = lookupDecendents[x]).sum()

when isMainModule:
  import unittest
  suite "day 6":
    test "array behavior":
      var a = [1, 2, 3]
      var b = [2, 3, 4]
      b = a
      a[0] = 9
      check(b[0] == 1)
      check(a[0] == 9)
    test "2 days of jellyfish":
      let input = @[0, 1, 2]
      # [0,1,2] -> [6,0,1,8] -> [5,6,0,7,8]
      check(jellyfishAfter(2, input) == 5)
    test "aoc example":
      let input = @[3, 4, 3, 1, 2]
      check(jellyfishAfter(2, input) == 6)
      check(jellyfishAfter(11, input) == 15)
      check(jellyfishAfter(80, input) == 5934)
      check(jellyfishAfter(256, input) == 26984457539)


  benchmark "day2":
    let start = readFile("day6.txt").strip().split(",").map(parseInt)
    benchmark "computation":
      echo fmt"part 1: {jellyfishAfter(80,start)}"
      echo fmt"part 2: {jellyfishAfter(256,start)}"
