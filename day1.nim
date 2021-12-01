import strutils, sequtils

let input = readFile("day1.txt").strip() # remove final newline

let inputLines = input.splitLines().map(parseInt)

proc num_increases(input: seq[int]): int =
  var last = input[0]
  var increases = 0
  for n in input:
    if n > last:
      increases = increases + 1
    last = n
  return increases

when isMainModule:
  import unittest
  suite "day 1":
    test "find number of increases":
      let input = @[1,10,7,8,5,5,15]
      check(num_increases(input) == 3)

  echo num_increases(inputLines)
