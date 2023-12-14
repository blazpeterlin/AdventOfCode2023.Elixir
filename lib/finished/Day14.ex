
defmodule Day14 do

  def dictMake name do
    :ets.new(name, [:set, :public, :named_table, read_concurrency: true, write_concurrency: true])
  end
  def dictGet(name, key) do
    case :ets.lookup(name, key) do
      [{_key, val}] -> {:ok, val}
      _ -> {:nok, nil}
    end
  end
  @spec dictSet(atom() | :ets.tid(), any(), any()) :: true
  def dictSet(name, key, val) do
    :ets.insert(name, {key,val})
  end

  # dictMake(:myDict)
  # dictSet(:myDict, 1,2)
  # {:ok,res} = dictGet(:myDict, 1)

  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(fn x -> Tuple.to_list(x) end)
  end

  def rollDown(codepoints) do
    {rev,_} =
      codepoints
      |> Enum.with_index()
      |> List.foldl({[], 0}, fn({char,charIdx},{buildup,rollIdx}) ->
        case char do
          "#" -> {[char | buildup], charIdx+1}
          "." -> {[char | buildup], rollIdx}
          "O" ->
            if charIdx == rollIdx do
              {[char | buildup], rollIdx+1}
            else
              nextBuildup = List.insert_at(buildup,Enum.count(buildup)-rollIdx,char)
              {nextBuildup, rollIdx+1}
            end
        end
      end)

    r = rev |> Enum.reverse()
    r
  end

  def rate(col) do
    len = Enum.count(col)
    r =
      col
      |> Enum.with_index()
      |> Enum.map(fn {char,charIdx} ->
        case char do
          "#" -> 0
          "." -> 0
          "O" -> len-charIdx
        end
      end)
      |> Enum.sum()
    r
  end

  def rateMap(map) do
    map |> Enum.map(fn col -> rate(col) end) |> Enum.sum()
  end

  def solve1 inputPath do
    {:ok, input} = File.read(inputPath);
    lines = String.split(input, "\r\n") |> Enum.filter(fn x -> x != "" end)
    _ = lines

    rowChars = lines |> Enum.map(fn ln -> String.codepoints(ln) end)
    transposed = rowChars |> transpose()

    rolledNorth = transposed |> Enum.map(&rollDown(&1))

    res= rateMap(rolledNorth);
    res
  end

  def spinCycle(rowChars) do
    forN = rowChars |> transpose()
    rollN = forN |> Enum.map(&rollDown(&1))

    forW = rollN |> transpose()
    rollW = forW |> Enum.map(&rollDown(&1))

    forS = rollW |> transpose() |> Enum.map(&Enum.reverse(&1))
    rollS = forS |> Enum.map(&rollDown(&1))

    forE = rollS |> Enum.map(&Enum.reverse(&1)) |> transpose() |> Enum.map(&Enum.reverse(&1))
    rollE = forE |> Enum.map(&rollDown(&1))

    back2orig = rollE |> Enum.map(&Enum.reverse(&1))

    back2orig
  end

  def findRepeat(rowChars0) do
    dictMake(:cycleDict)

    dictSet(:cycleDict, rowChars0, 0)

    {_, {idxFirstTime, idxSecondTime}} =
      1..1000000000
      |> Stream.scan({rowChars0, nil}, fn(idx,{rcPrev, _}) ->
        rcNext = spinCycle(rcPrev)
        case dictGet(:cycleDict, rcNext) do
          {:ok, repeatedIdx} -> {rcNext, {repeatedIdx, idx}}
          {:nok, _} ->
            dictSet(:cycleDict, rcNext, idx)
            {rcNext, nil}
        end
      end)
      |> Enum.find(fn({_,foundRepeat}) ->
        foundRepeat != nil
      end)

    {idxFirstTime, idxSecondTime}
  end

  def solve2 inputPath do
    {:ok, input} = File.read(inputPath);
    lines = String.split(input, "\r\n") |> Enum.filter(fn x -> x != "" end)
    _ = lines

    rowChars = lines |> Enum.map(fn ln -> String.codepoints(ln) end)

    {fst, snd} = findRepeat(rowChars)
    loopSize = snd-fst
    unloopedStepsNum = rem(1000000000 - fst, loopSize) + fst

    finalChars =
      1..unloopedStepsNum
      |> Enum.reduce(rowChars, fn(_,acc) ->
        spinCycle(acc)
      end)
    res = finalChars |> transpose() |> rateMap()
    res
  end
end
