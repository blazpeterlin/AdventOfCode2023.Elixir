
defmodule Day15 do

  def dictMake name do
    :ets.new(name, [:set, :public, :named_table, read_concurrency: true, write_concurrency: true])
  end
  def dictGet(name, key) do
    case :ets.lookup(name, key) do
      [{_key, val}] -> {:ok, val}
      _ -> {:nok, nil}
    end
  end
  def dictSet(name, key, val) do
    :ets.insert(name, {key,val})
  end

  # dictMake(:myDict)
  # dictSet(:myDict, 1,2)
  # {:ok,res} = dictGet(:myDict, 1)

  def hash(tkn) do
    String.to_charlist(tkn)
    |> Enum.reduce(0, fn(codepoint,acc) -> rem((acc+codepoint)*17,256) end)
  end

  def solve1 inputPath do
    {:ok, input} = File.read(inputPath);
    line = String.split(input, "\r\n") |> Enum.at(0)
    tkns = String.split(line, ",") |> Enum.filter(fn x -> x != "" end)
    _ = tkns

    hashes = tkns |> Enum.map(&hash(&1))

    res = hashes |> Enum.sum()
    res
  end

  def operation(str) do
    strContains = String.contains?(str, "=")
    case strContains do
      :true ->
        [label,numStr] = String.split(str, "=")
        {:setVal, {label, String.to_integer(numStr)}}
      :false ->
        [label | _] = String.split(str, "-")
        {:unsetVal, label}
    end
  end

  def doOperation(op) do
    case(op) do
      {:unsetVal, lbl} ->
        idx = hash(lbl)
        case(dictGet(:dictLens, idx)) do
          {:ok, arr} ->
            filteredArr = arr |> Enum.filter(fn({key,_}) -> key != lbl end)
            dictSet(:dictLens, idx, filteredArr)
          {:nok, _} ->
            _noop=:true
        end
      {:setVal, {lbl,newVal}} ->
        idx = hash(lbl)
        arr =
          case(dictGet(:dictLens, idx)) do
            {:ok, existingArr} -> existingArr
            {:nok, _} -> []
          end

        eltExists = Enum.any?(arr, fn({eltLbl,_}) -> eltLbl == lbl end)
        newArr =
          case eltExists do
            true -> arr |> Enum.map(fn({eltLbl,eltVal}) -> if eltLbl==lbl, do: {eltLbl,newVal}, else: {eltLbl,eltVal} end)
            false -> [{lbl,newVal} | arr]
          end

        dictSet(:dictLens, idx, newArr)
    end
  end

  def calcFocusingPower(idx) do
    arr =
      case dictGet(:dictLens, idx) do
        {:ok, arrVal} -> arrVal
        {:nok, _} -> []
      end
    boxRealNum=idx+1
    arr |> Enum.reverse() |> Enum.with_index(1) |> Enum.map(fn({{_,focalLen},slotNum}) -> boxRealNum*slotNum*focalLen end)
  end

  def solve2 inputPath do
    {:ok, input} = File.read(inputPath);
    line = String.split(input, "\r\n") |> Enum.at(0)
    tkns = String.split(line, ",") |> Enum.filter(fn x -> x != "" end)
    ops = tkns |> Enum.map(&operation(&1))

    dictMake(:dictLens)

    ops |> Enum.each(&(doOperation(&1)))

    focusingPowers =
      0..256
      |> Enum.map(&calcFocusingPower(&1))
      |> Enum.concat()

    res = Enum.sum(focusingPowers)
    res
  end
end
