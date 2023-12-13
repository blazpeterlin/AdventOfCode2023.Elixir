
defmodule RangeMap do
  defstruct srcX: 0, dstX: 0, len: 0
end

defmodule Mapping do
  defstruct rangeMaps: []
end

defmodule SeedRange do
  defstruct fromIncl: 0, toExcl: 0, len: 0
end

defmodule Day05 do

  def grp2mapping(grp) do
    r1 =
      String.split(grp, "\r\n")
      |> Kernel.then(&Enum.drop(&1, 1))

    ranges =
      r1
      |> Enum.map(fn ln ->
          huh =
            String.split(ln, " ")
            |> Enum.map(&String.to_integer(&1))
          huh
        end)
      |> Enum.map(fn [a,b,c] -> %RangeMap{srcX: b, dstX: a, len: c} end)


    r2 = %Mapping{rangeMaps: ranges}
    r2
  end

  def transformSingle(singleMapping, seed) do
    rangeMap =
      singleMapping.rangeMaps
      |> Enum.find(
          %RangeMap{srcX: seed, dstX: seed, len: 1},
          fn rm -> rm.srcX <= seed && seed < rm.srcX + rm.len end)

    mappedSeed = rangeMap.dstX + (seed - rangeMap.srcX)
    mappedSeed
  end

  def transform(seed, mappings) do
    r = List.foldl(mappings, seed, fn(elem,acc) -> transformSingle(elem,acc) end)
    {seed, r}
  end

  def solve1 inputPath do
    {:ok, input} = File.read(inputPath);

    grps = String.split(input, "\r\n\r\n") |> Enum.filter(fn x -> x != "" end)

    seeds =
      Enum.at(grps, 0)
      |> Kernel.then(fn ln -> String.split(ln, " ") end)
      |> Kernel.then(fn x -> Enum.drop(x,1) end)
      |> (Enum.map(&String.to_integer(&1)))
    mappings = grps |> Enum.drop(1) |> Enum.map(fn grp -> grp2mapping(grp) end)

    seedsLocs =
      seeds
      |> Enum.map(fn s -> transform(s, mappings) end)

    res = seedsLocs |> Enum.map(fn {_,loc} -> loc end) |> Enum.min()
    # res = seeds
    res
  end

  def approximateSeed(seedRanges, approximation, mappings) do
    seedAttempts =
      seedRanges
      |> Enum.map(fn sr -> [sr.toExcl] ++ Enum.to_list(sr.fromIncl .. sr.toExcl // approximation) end)
      |> Enum.concat()

    seedsLocsApprox =
      seedAttempts
      |> Enum.map(fn s -> transform(s, mappings) end)

    res = seedsLocsApprox |> Enum.min_by(fn {_, loc} -> loc end)
    res
  end

  def solve2 inputPath do
    {:ok, input} = File.read(inputPath);

    grps = String.split(input, "\r\n\r\n") |> Enum.filter(fn x -> x != "" end)

    seedRanges =
      Enum.at(grps, 0)
      |> Kernel.then(fn ln -> String.split(ln, " ") end)
      |> Kernel.then(fn x -> Enum.drop(x,1) end)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [a, b] ->
        inta = String.to_integer(a)
        intb = String.to_integer(b)
        r = %SeedRange{fromIncl: inta, toExcl: (inta+intb), len: intb}
        r
      end)
    mappings = grps |> Enum.drop(1) |> Enum.map(fn grp -> grp2mapping(grp) end)

    # seedMax = seedRanges |> Enum.map(fn sr -> sr.toExcl end) |> Enum.max()

    approximation1 = 1000000
    approximation2 = 1000
    approximation3 = 1

    {closestSeed1,_} = approximateSeed(seedRanges, approximation1, mappings)
    seedRanges1 =
      Enum.to_list((closestSeed1 - approximation1) .. (closestSeed1+1) // approximation2)
      |> Enum.map(fn num -> %SeedRange{fromIncl: num, toExcl: num+approximation2, len: approximation2} end)
    {closestSeed2,_} = approximateSeed(seedRanges1, approximation2, mappings)
    seedRanges2 =
      Enum.to_list((closestSeed2 - approximation2) .. (closestSeed2+1) // approximation3)
      |> Enum.map(fn num -> %SeedRange{fromIncl: num, toExcl: num+approximation3, len: approximation3} end)
    {_,loc3} = approximateSeed(seedRanges2, approximation3, mappings)

    res = loc3
    # res = seedsLocs |> Enum.map(fn {_,loc} -> loc end) |> Enum.min()
    # res = seeds
    res
  end
end
