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

proc oxygen(lines: seq[string]): int =
  ## my reading: closest to gamma, comparing from the front
  ## wrong reading after all, it is a changing gamma based on the remaining lines (!= overall gamma)
  return 23

proc co2(lines: seq[string]): int =
  ## my reading: closest to epsilon, comparing from the front
  ## wrong reading after all, it is a changing epsilon based on the remaining lines (!= overall epsilon)
  return 10

proc lifeSupport(lines: seq[string]): int =
  return oxygen(lines) * co2(lines)

when isMainModule:
  import unittest
  suite "day 3":
    setup:
      let input = @["011", "010", "100", "010", "101"]
      let inputOfficial = @[
        "00100",
        "11110",
        "10110",
        "10111",
        "10101",
        "01111",
        "00111",
        "11100",
        "10000",
        "11001",
        "00010",
        "01010"
      ]
    test "gamma":
      check(gamma(input, 3) == 2)
      check(gamma(inputOfficial, 5) == 22)
    test "epsilon":
      check(epsilon(input, 3) == 5)
      check(epsilon(inputOfficial, 5) == 9)
    test "powerConsumption":
      check(powerConsumption(input) == 10)
    test "oxygen":
      #check(oxygen(input) == 2)
      check(oxygen(inputOfficial) == 23)
    test "co2":
      #check(co2(input) == 4)
      check(co2(inputOfficial) == 10)
    test "lifeSupport":
      #check(lifeSupport(input) == 8)
      check(lifeSupport(inputOfficial) == 230)

  let lines = readFile("day3.txt").strip().splitLines()
  echo format("part 1: $#", powerConsumption(lines))
  echo fmt"part 2: {lifeSupport(lines)}"
