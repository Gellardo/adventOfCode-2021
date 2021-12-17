## # Day 17
## target area: x=235..259, y=-118..-62
import strutils, sequtils, std/strformat, math, std/sets, std/algorithm
import common

let target: tuple[x: Slice[int], y: Slice[int]] = (x: 235 .. 259, y: -118 .. -62)

type
  Vec = tuple[x: int, y: int]
  AOCProbe = tuple
    position: Vec
    velocity: Vec

proc initProbe(velocity: Vec): AOCProbe =
  return (position: (x:0,y:0), velocity:velocity)
proc tick(current: AOCProbe): AOCProbe =
  var next = current
  next.position.x = next.position.x + next.velocity.x
  next.position.y = next.position.y + next.velocity.y
  if next.velocity.x > 0:
    next.velocity.x = next.velocity.x - 1
  elif next.velocity.x < 0:
    next.velocity.x = next.velocity.x + 1
  next.velocity.y = next.velocity.y - 1
  return next


proc highest_peak*(target_area: tuple): int =
  ## This comes down to pure math:
  ##
  ## For any positive velocity we put in, the probe will later arrive at y=0 again.
  ## (The slowdown/speedup by gravity is symmetric, first decreasing by one each step then increasing to mirror the trajectory)
  ##
  ## This means that the maximum y-velocity has to be chosen so that the next step takes the probe to the lowest y value of the target area.
  ## Any faster and the step after reaching y=0 again takes us beyond the target area.
  ## (-1 to account for gravity after reaching y=0.)
  ##
  ## v_y_max = min(target_y) - 1.
  ##
  ## That leaves us with determining the height of that shot:
  ## sum(v_y_max .. 0) = sum (0..v_y_max) = v_y_max * (v_y_max + 1) / 2
  ##
  ## Either know that formula, go to wolfram alpha or do a for-loop
  let last_iteration_y: int = target_area.y.a

  return last_iteration_y * (last_iteration_y + 1 ) div 2

proc all_vectors*(target_area: tuple): seq[Vec] =
  return @[(1,2)]

proc part1(target_area: tuple): int =
  return highest_peak(target_area)
proc part2(target_area: tuple): int =
  return all_vectors(target_area).len

when isMainModule:
  import unittest
  suite "day 17":
    test "probe tick":
      check(initProbe((x:2, y:3)).tick() == (position: (x: 2, y: 3), velocity: (x:1,y:2)))
      check(initProbe((x: -2, y: -3)).tick() == (position: (x: -2, y: -3), velocity: (x: -1,y: -4)))
    test "highest_peak":
      check(highest_peak((x: 20 .. 30, y: -10 .. -5)) == 45)


  benchmark "day17":
    benchmark "computation":
      echo fmt"part 1: {part1(target)}"
      echo fmt"part 2: {part2(target)}"
