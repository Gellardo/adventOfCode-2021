## # Day 3
## This was definitely a lot slower than it could have been.
## Trying to be smart and writing full solutions for gamma and epsilon lead to them "having" to be rewritten for p2.
## And having no small utility function to use by oxygen/co2.
##
## I also misunderstood the oxygen/co2 functions quite a bit.
## I thought that they were about "finding the closest match to epsilon/gamma".
## Which would have been correct if the text did not specify that the set to look at got smaller every time.
## Luckily there are examples which fixed that.
##
## Also missing tests for minorDigit had me scratch my head a little (switched the returns around).
import strutils, sequtils, std/strformat
import common

proc majorDigit(lines: seq[string], position: int): char =
  var ones = 0
  let half = lines.len div 2
  for l in lines:
    if l[position] == '1':
      ones = ones + 1
  #echo fmt"{lines.len} {ones}"
  if ones > half:
    return '1'
  if lines.len mod 2 == 0 and ones == half: # tie break if len even
    return '1'
  else:
    return '0'

proc minorDigit(lines: seq[string], pos: int): char =
  return if majorDigit(lines, pos) == '1': '0' else: '1'

proc gamma(lines: seq[string]): int =
  var gamma = ""
  for c in 0..<lines[0].len:
    gamma = gamma & majorDigit(lines, c)
  #echo gamma

  return gamma.parseBinInt

proc epsilon(lines: seq[string]): int =
  var epsilon = ""
  for c in 0..<lines[0].len:
    epsilon = epsilon & minorDigit(lines, c)
  #echo fmt"{epsilon} {length} {lines.len}"

  return epsilon.parseBinInt

proc powerConsumption*(lines: seq[string]): int =
  ## part1 solution
  ##
  ## learning:
  ## Tests should have more lines than length for the if-ones check.
  ## Otherwise using length instead of lines.len will also be successful
  let gamma = gamma(lines)
  let epsilon = epsilon(lines)
  #echo fmt"{gamma} * {epsilon}"
  return gamma * epsilon

proc oxygen(lines: seq[string]): int =
  ## my reading: closest to gamma, comparing from the front
  ## wrong reading after all, it is a changing gamma based on the remaining lines (!= overall gamma)
  var remaining = lines
  let length = remaining[0].len
  for pos in 0..<length:
    let d = majorDigit(remaining, pos)
    remaining = remaining.filter(proc (l: string): bool = l[pos] == d)

    #echo remaining
  return remaining[0].parseBinInt

proc co2(lines: seq[string]): int =
  ## my reading: closest to epsilon, comparing from the front
  ## wrong reading after all, it is a changing epsilon based on the remaining lines (!= overall epsilon)
  var remaining = lines
  let length = remaining[0].len
  for pos in 0..<length:
    let d = minorDigit(remaining, pos)
    remaining = remaining.filter(proc (l: string): bool = l[pos] == d)
    # we need an early break since 'least common' can determine a digit that has no line instance
    if remaining.len == 1: break

    #echo remaining
  return remaining[0].parseBinInt

proc lifeSupport*(lines: seq[string]): int =
  ## part 2 solution
  ##
  ## my reading for oxygen/co2: closest to gamma/epsilon, comparing from the front.
  ##
  ## wrong reading after all, closest understanding woule be a changing epsilon based on the remaining lines
  ## (!= overall epsilon).
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
    test "majorDigit":
      let digitInput = @["011", "010"]
      check(majorDigit(digitInput, 0) == '0')
      check(majorDigit(digitInput, 1) == '1')
      check(majorDigit(digitInput, 2) == '1')
      check(minorDigit(digitInput, 0) == '1')
      check(minorDigit(digitInput, 1) == '0')
      check(minorDigit(digitInput, 2) == '0')
    test "gamma":
      check(gamma(input) == 2)
      check(gamma(inputOfficial) == 22)
    test "epsilon":
      check(epsilon(input) == 5)
      check(epsilon(inputOfficial) == 9)
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

  benchmark "day2":
    let lines = readFile("day3.txt").strip().splitLines()
    benchmark "computation":
      echo format("part 1: $#", powerConsumption(lines))
      echo fmt"part 2: {lifeSupport(lines)}"
