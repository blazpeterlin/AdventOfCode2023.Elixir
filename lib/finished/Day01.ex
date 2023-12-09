defmodule Day01 do
  def solve1 inputPath do
    {:ok, input} = File.read(inputPath);
    lines = String.split(input, "\r\n")
    tokenized =
      lines
      |> Enum.filter(fn x -> x != "" end)
      |> Enum.map(fn x -> (Regex.scan(~r/\d/, x)) |> Enum.concat() |> (Enum.map (&String.to_integer/1)) end) #
    res =
      tokenized
      |> Enum.map(fn tkns -> (hd tkns)*10 + (tkns |> Enum.reverse |> hd) end)
      |> Enum.sum()

    res
  end

  def findFirstNum(ln, numsMapped) do
    case Regex.run(~r/(\d|one|two|three|four|five|six|seven|eight|nine)/, ln) do
      [x,_] -> if Map.has_key?(numsMapped, x) do [numsMapped[x]] else [String.to_integer(x)] end
      _ -> []
    end
  end

  def findLastNum(ln, numsMapped) do

    res =
      0 .. String.length(ln) - 1
      |> Enum.reverse
      |> (Enum.map (fn startIdx -> String.slice(ln, startIdx, String.length(ln)-startIdx) end))
      |> (Enum.map (fn str -> findFirstNum(str,numsMapped) end))
      |> Enum.concat
    hd res
  end

  def solve2 inputPath do
    {:ok, input} = File.read(inputPath);
    lines = String.split(input, "\r\n") |> Enum.filter(fn x -> x != "" end)

    nums = ["one","two","three","four","five","six","seven","eight","nine"]
    numsMapped = nums |> (Enum.with_index()) |> (Enum.map (fn {word,idx} -> {word,idx+1} end)) |> Map.new


    linesFirst = Enum.map(lines, &findFirstNum(&1, numsMapped)) |> Enum.map(fn x -> hd x end)
    linesLast = Enum.map(lines, &findLastNum(&1, numsMapped))

    res =
      Enum.zip(linesFirst, linesLast)
      |> Enum.map(fn {a,b} -> a*10+b end)
      |> Enum.sum()
    # x = lines
    res
  end
end
