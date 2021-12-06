import times, strutils

template benchmark*(benchmarkName: string, code: untyped) =
  block:
    let t0 = epochTime()
    let t0_cpu = cpuTime()
    code
    let elapsed = epochTime() - t0
    let elapsed_cpu = cpuTime() - t0_cpu
    let elapsedStr = elapsed.formatFloat(format = ffDecimal, precision = 4)
    let elapsedStr_cpu = elapsed_cpu.formatFloat(format = ffDecimal, precision = 4)
    echo "Benchmark [", benchmarkName, "] wall=", elapsedStr, "s cpu=", elapsedStr_cpu

