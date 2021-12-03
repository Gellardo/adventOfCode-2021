## # Day 3
import strutils, sequtils, math, std/strformat

proc gamma(lines: seq[string], length:int): int =
  var gamma = ""
  for c in 0..<length:
    var ones = 0
    for l in lines:
      if l[c] == '1':
        ones = ones + 1
    if ones > lines.len div 2:
      gamma = gamma & "1"
    else:
      gamma = gamma & "0"
  echo gamma

  return gamma.parseBinInt
proc epsilon(lines: seq[string], length:int): int =
  var epsilon = ""
  for c in 0..<length:
    var ones = 0
    for l in lines:
      if l[c] == '1':
        ones = ones + 1
    if ones > lines.len div 2:
      epsilon = epsilon & "0"
    else:
      epsilon = epsilon & "1"
    #echo fmt"{c}: {ones}"
  #echo fmt"{epsilon} {length} {lines.len}"

  return epsilon.parseBinInt

proc powerConsumption*(lines: seq[string]): int =
  ## part1 solution
  ##
  ## learning:
  ## Tests should have more lines than length for the if-ones check.
  ## Otherwise using length instead of lines.len will also be successful
  let gamma = gamma(lines, lines[0].len)
  let epsilon = epsilon(lines, lines[0].len)
  echo fmt"{gamma} * {epsilon}"
  return gamma * epsilon

when isMainModule:
  import unittest
  suite "day 3":
    test "gamma":
      let input = @["011", "010", "100", "010", "101"]
      check(gamma(input, 3) == 2)
    test "epsilon":
      let input = @["011", "010", "100", "010", "101"]
      check(epsilon(input, 3) == 5)
    test "powerConsumption":
      let input = @["011", "010", "100", "010", "101"]
      check(powerConsumption(input) == 10)

  let lines = readFile("day3.txt").strip().splitLines()
  echo format("part 1: $#", powerConsumption(lines))
  #echo "part 2: {num_increases_sliding_window(inputLines)}".fmt
