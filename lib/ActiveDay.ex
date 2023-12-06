defmodule ActiveDay do
  def solve1 do
    {:ok, input} = File.read("lib/input.txt");
    lines = String.split(input, "\r\n")
    tokenized =
      lines
      |> Enum.filter(fn x -> x != "" end)
      |> Enum.map(fn x -> (Regex.scan(~r/\d/, x)) |> Enum.concat() |> (Enum.map (&String.to_integer/1)) end) #
    res =
      tokenized
      |> Enum.map(fn tkns -> (hd tkns)*10 + (tkns |> Enum.reverse |> hd) end)
      |> Enum.sum()

    # x = lines
    res
  end
end
