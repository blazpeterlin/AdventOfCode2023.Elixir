
defmodule Day03 do

  def calcEngineParts(lines, isEnginePart) do
    lines
    |> Enum.with_index()
    |> (Enum.map (
      fn {ln,idxY} ->
        String.to_charlist(ln)
        |> Enum.with_index()
        |> Enum.filter(fn({ch,_}) ->
            chStr = List.to_string([ch])

            isEnginePart.(chStr)
          end)
        |> (Enum.map(fn({ch,idxX}) -> {{idxX,idxY},ch} end))
      end))
  end

  def calcNumsWithPos(lines) do
    lines
    |> Enum.with_index()
    |> Enum.map(
        fn {ln, idxY} ->
          rs = Regex.scan(~r/(\d*)/, ln, return: :index)
          rs
          |> Enum.map(fn [{idx, len}, _] -> {idx,len} end)
          |> (Enum.filter (fn {_, len} -> len>0 end))
          |> (Enum.map(fn {idxX, len} -> {{idxX,idxY}, len, String.to_integer(String.slice(ln, idxX..idxX+len-1))} end))
        end
      )
    |> Enum.concat
  end

  def isAdjacent(numWithLen, coord) do
    {{x1,y1},len1,_} = numWithLen
    {x2,y2} = coord

    case abs (y2 - y1) do
      delta when delta>1 -> false
      _ ->
        x1..(x1+len1-1)
        |> Enum.any?(
          fn x ->
            abs(x2-x) <= 1
          end)
    end
  end

  def findNumsAdjacentToSymbols(numStrsWithPos, enginePartCoords) do
    engineSet = MapSet.new(enginePartCoords)

    numStrsWithPos
    |> (Enum.filter (
      fn {{x,y},len,_} ->
        (x-1)..(x+len)
        |> Common.all_pairs((y-1)..(y+1))
        |> Enum.any?(fn pos -> MapSet.member?(engineSet, pos) end)
      end
    ))
  end

  def solve1 inputPath do
    {:ok, input} = File.read(inputPath);
    lines = String.split(input, "\r\n") |> Enum.filter(fn x -> x != "" end)
      _ = lines

    engineParts = calcEngineParts(
      lines,
      fn(chStr) ->
        chStr != "." && case (Integer.parse(chStr)) do
          :error -> true
          _ -> false
        end
      end
    ) |> Enum.to_list()
    enginePartCoords = engineParts |> Enum.concat |> Enum.map(fn {pos,_} -> pos end) |> Enum.to_list()

    numStrsWithPos = calcNumsWithPos(lines)

    adjacentNumStrs = findNumsAdjacentToSymbols(numStrsWithPos, enginePartCoords)

    res =
      adjacentNumStrs
      |> Enum.map(fn {_,_,num} -> num end)
      |> Enum.sum()

    res
  end

  def solve2 inputPath do
    {:ok, input} = File.read(inputPath);
    lines = String.split(input, "\r\n") |> Enum.filter(fn x -> x != "" end)
    _ = lines

    gearParts = calcEngineParts(
        lines,
        fn(chStr) -> chStr == "*" end) |> Enum.to_list()
      |> Enum.concat()

    # list of x*y
    gearCoords = gearParts |> Enum.map(fn {pos,_} -> pos end) |> Enum.to_list()

    # list of (x*y)*_*num
    numStrsWithPos = calcNumsWithPos(lines)

    # adjacentNumStrs = findNumsAdjacentToSymbols(numStrsWithPos, gearCoords)

    gearPartNums =
      gearCoords
      |> Enum.map(fn(gearCoord) ->
        adjacentNums =
          numStrsWithPos
          |> Enum.filter(
            fn numSWP ->
              isAdjacent(numSWP, gearCoord)
            end)

        cond do
          Enum.count(adjacentNums) != 2 -> []
          true -> adjacentNums |> Enum.map(fn {_,_,num} -> num end)
        end
      end)

    res =
      gearPartNums
      |> (Enum.filter (fn arr -> !Enum.empty?(arr) end))
      |> Enum.map(fn arr -> Enum.reduce(arr, fn(a,b) -> a*b end) end)
      |> Enum.sum()

    res
  end
end
