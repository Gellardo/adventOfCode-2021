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
  var points: seq[Point] = @[]
  var folds: seq[Fold] = @[]
  for line in lines:
    if line.startsWith("fold along"):
      if line.contains("x"):
        folds.add(Fold(type:left, x: line.split("=")[1].parseInt))
      else:
        folds.add(Fold(type:up, y: line.split("=")[1].parseInt))
    elif line.len > 0:
      var l = line.split(",")
      points.add((x: l[0].parseInt, y: l[1].parseInt))
  return (points, folds)

proc fold(p: Point, f: Fold): Point =
  case f.type:
    of left:
      if p.x < f.x:
        return p
      else:
        return (x: f.x-(p.x-f.x), y: p.y)
    of up:
      if p.y < f.y:
        return p
      else:
        return (x: p.x, y: f.y-(p.y-f.y))
  return p

proc applyFolds(p: var Point, folds: seq[Fold]): Point =
  for fold in folds:
    p = p.fold(fold)
  return p

proc part1(lines: seq[string]): int =
  let (points, folds) = lines.parse
  let pointsAfterFirst = points.map(proc (p:Point): Point = p.fold(folds[0])).toHashset
  return pointsAfterFirst.len

proc printPoints(points: HashSet[Point]) =
  var maxX = 0
  var maxY = 0
  for p in points:
    if maxX < p.x:
      maxX = p.x
    if maxY < p.y:
      maxY = p.y

  for y in 0..maxY:
    for x in 0..maxX:
      if (x:x,y:y) in points:
        stdout.write "#"
      else:
        stdout.write "."
    echo ""

proc part2(lines: seq[string])=
  let (points, folds) = lines.parse
  let pointsAfter = points.map(proc (p:Point): Point =
    var p2 = p
    for f in folds:
      p2 = p2.fold(f)
    return p2
  ).toHashset
  pointsAfter.printPoints

when isMainModule:
  import unittest
  suite "day 13":
    test "parsing":
      let input = @[
        "790,820",
        "",
        "fold along x=655",
      ]
      check(parse(input) == (@[(x: 790, y: 820)], @[Fold(type: left, x: 655)]))
    test "fold left":
      let point = (x: 5, y: 5)
      check(point.fold(Fold(type:left, x:3)) == (x: 1, y: 5))
      check(point.fold(Fold(type:left, x:4)) == (x: 3, y: 5))
    test "fold up":
      let point = (x: 5, y: 5)
      check(point.fold(Fold(type:up, y:3)) == (x: 5, y: 1))
      check(point.fold(Fold(type:up, y:4)) == (x: 5, y: 3))


  benchmark "day13":
    let lines = readFile("day13.txt").strip().splitLines()
    benchmark "computation":
      echo fmt"part 1: {part1(lines)}"
      echo fmt"part 2:"
      part2(lines)
