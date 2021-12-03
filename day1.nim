## # Day1
## Something about getting a "depth" reading and looking for how often it decreases
import strutils, sequtils, math, std/strformat

proc num_increases*(input: seq[int]): int =
  ## for part 1
  var last = input[0]
  var increases = 0
  for n in input:
    if n > last:
      increases = increases + 1
    last = n
  return increases

proc sliding_window_sums(input: seq[int], size: int): seq[int] =
  var window: seq[int] = @[]
  var output: seq[int] = @[]

  for n in input:
    window.add(n)
    if window.len > size:
      window = window[1 ..< window.len]
    if window.len == size:
      output.add(sum(window))
  return output

proc num_increases_sliding_window*(input: seq[int]): int =
  ## for part 2, reusing solution of part 1 after "mapping" to sums of sliding window
  return num_increases(sliding_window_sums(input, 3))

when isMainModule:
  import unittest
  suite "day 1":
    test "find number of increases":
      let input = @[1, 10, 7, 8, 5, 5, 15]
      check(num_increases(input) == 3)
    test "sliding window sums base case":
      let input = @[1, 1, 1]
      check(sliding_window_sums(input, 3) == @[3])
    test "sliding window sums work":
      let input = @[1, 1, 1, 2, 2, 0]
      check(sliding_window_sums(input, 3) == @[3, 4, 5, 4])
    test "find number of increases in sliding window":
      let input = @[1, 1, 1, 2, 2, 0]
      check(num_increases_sliding_window(input) == 2)

  let input = readFile("day1.txt").strip()       # remove final newline
  let inputLines = input.splitLines().map(parseInt)
  echo format("part 1: $#", num_increases(inputLines))
  echo "part 2: {num_increases_sliding_window(inputLines)}".fmt
