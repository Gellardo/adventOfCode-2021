## # Day 9
import strutils, sequtils, std/strformat, math, std/sets, std/algorithm
import common

proc findMinima*(lines: seq[string]): seq[int] =
  ## Check all surrounding locations, if all are bigger, you found a minimum. easy
  var minima: seq[int] = @[]
  for r in 0..<lines.len:
    for c in 0..<lines[0].len:
      if (c-1 < 0 or lines[r][c] < lines[r][c-1]) and
         (c+1 == lines[0].len or lines[r][c] < lines[r][c+1]) and
         (r-1 < 0 or lines[r][c] < lines[r-1][c]) and
         (r+1 == lines.len or lines[r][c] < lines[r+1][c]):
          minima.add(parseInt(fmt"{lines[r][c]}"))
  return minima

type Pos = tuple[r: int, c: int]
proc findBasinsSizes*(lines: seq[string]): seq[int] =
  ## basically a breadth first search using all non-9 locations
  var sizes: seq[int] = @[]
  var unvisited: Hashset[Pos]
  for r in 0..<lines.len:
    for c in 0..<lines[0].len:
      if lines[r][c] != '9':
        unvisited.incl((r, c))
  var currentBasin: Hashset[Pos]
  var edge: Hashset[Pos]
  edge.incl(unvisited.pop())
  while edge.len > 0:
    let current = edge.pop()
    currentBasin.incl(current)
    let left = (current.r, current.c-1)
    let right = (current.r, current.c+1)
    let up = (current.r-1, current.c)
    let down = (current.r+1, current.c)
    for n in [left, right, up, down]:
      if n in unvisited:
        unvisited.excl(n)
        edge.incl(n)
    if edge.len == 0:
      sizes.add(currentBasin.len)
      currentBasin.clear
      if unvisited.len > 0:
        edge.incl(unvisited.pop())
  return sizes.sorted(SortOrder.Descending)

proc part1(lines: seq[string]): int =
  let minima = findMinima(lines)
  return sum(minima) + minima.len

proc part2(lines: seq[string]): int =
  let sizes = findBasinsSizes(lines)
  return prod(sizes[0..2])

when isMainModule:
  import unittest
  suite "day 9":
    test "find minima":
      let input = @[
        "981",
        "936",
        "849",
      ]
      check(findMinima(input) == @[1, 3])
    test "find basin sizes":
      let input = @[
        "149",
        "996",
        "845",
      ]
      check(findBasinsSizes(input) == @[4, 2])


  benchmark "day9":
    let lines = readFile("day9.txt").strip().splitLines()
    benchmark "computation":
      echo fmt"part 1: {part1(lines)}"
      echo fmt"part 2: {part2(lines)}"
      assert part2(lines) == 964712
