
defmodule ActiveDay do

  def solve1 inputPath do
    {:ok, input} = File.read(inputPath);
    lines = String.split(input, "\r\n") |> Enum.filter(fn x -> x != "" end)
    _ = lines
    0
  end

  def solve2 inputPath do
    {:ok, input} = File.read(inputPath);
    lines = String.split(input, "\r\n") |> Enum.filter(fn x -> x != "" end)
    _ = lines
    0
  end
end
