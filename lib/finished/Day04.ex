
defmodule Card do
  defstruct winningNums: [], foundNums: []
end

defmodule Day04 do

  def solve1 inputPath do
    {:ok, input} = File.read(inputPath);
    lines = String.split(input, "\r\n") |> Enum.filter(fn x -> x != "" end)
    cards =
      lines
      |> Enum.map(
        fn line ->
          splits = String.split(line, ~r/(:|\|)/) |> Enum.map(fn str -> String.trim(str) end)
          winning = String.split(Enum.at(splits,1), " ", trim: true) |> Enum.map(&String.to_integer(&1))
          found = String.split(Enum.at(splits,2), " ", trim: true) |> Enum.map(&String.to_integer(&1))
          %Card{winningNums: winning, foundNums: found}
        end
      )

    pts =
      cards
      |> Enum.map(
        fn card ->
          winSet = MapSet.new(card.winningNums)
          card.foundNums |> Enum.filter(fn num -> MapSet.member?(winSet, num) end) |> Enum.count()
        end
      )
      |> Enum.filter(fn c -> c != 0 end)
      |> Enum.map(fn c -> :math.pow(2, c-1) end)

    res = pts |> Enum.sum() |> round()
    res
  end

  def solve2 inputPath do
    {:ok, input} = File.read(inputPath);
    lines = String.split(input, "\r\n") |> Enum.filter(fn x -> x != "" end)
    cards =
      lines
      |> Enum.map(
        fn line ->
          splits = String.split(line, ~r/(:|\|)/) |> Enum.map(fn str -> String.trim(str) end)
          winning = String.split(Enum.at(splits,1), " ", trim: true) |> Enum.map(&String.to_integer(&1))
          found = String.split(Enum.at(splits,2), " ", trim: true) |> Enum.map(&String.to_integer(&1))
          %Card{winningNums: winning, foundNums: found}
        end
      )

    ones = 1..(Enum.count(cards)) |> Enum.map(fn _ -> 1 end)

    pts =
      cards
      |> Enum.map(
        fn card ->
          winSet = MapSet.new(card.winningNums)
          card.foundNums |> Enum.filter(fn num -> MapSet.member?(winSet, num) end) |> Enum.count()
        end

      )
      # |> Enum.filter(fn c -> c != 0 end)
      |> Enum.scan(
          ones,
          fn(nextCardOutput, acc) ->
            [headAcc | tailAcc] = acc
            tailAcc
            |> Enum.with_index()
            |> (Enum.map (fn({x,idx}) -> x+(if idx < nextCardOutput, do: headAcc, else: 0) end))
          end)

    almostRes = pts |> Enum.filter(fn x -> Enum.any?(x) end) |> Enum.map(fn [head | _] -> head end) |> Enum.sum()
    res = almostRes + 1 # first result is not taken in
    res
  end
end
