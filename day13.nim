## # Day 13
import strutils, sequtils, std/strformat, math, std/sets, std/algorithm
import common


type
  FoldType = enum
    up,
    left,
  Fold = object
    case type: FoldType
    of up: y: int
    of left: x: int
  Point = tuple[x: int, y: int]

proc `==`(obj1, obj2: Fold): bool =
  result = obj1.type == obj2.type
  if result:
    case obj1.type
    of up:
      result = obj1.y == obj2.y
    of left:
      result = obj1.x == obj2.x


proc parse(lines: seq[string]): (seq[Point], seq[Fold]) =
  return (@[(x: 790, y: 820)], @[Fold(type: up, y: 655)])

when isMainModule:
  import unittest
  suite "day 13":
    test "parsing":
      let input = @[
        "790,820",
        "",
        "fold along x=655",
      ]
      check(parse(input) == (@[(x: 790, y: 820)], @[Fold(type: up, y: 655)]))


  benchmark "day9":
    let lines = readFile("day9.txt").strip().splitLines()
    benchmark "computation":
      echo "TODO"
      #echo fmt"part 1: {part1(lines)}"
      #echo fmt"part 2: {part2(lines)}"
