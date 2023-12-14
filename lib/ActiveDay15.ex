
defmodule ActiveDay15 do

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

  def solve1 inputPath do
    {:ok, input} = File.read(inputPath);
    lines = String.split(input, "\r\n") |> Enum.filter(fn x -> x != "" end)
    _ = lines

    res = 1+1
    res
  end

  def solve2 inputPath do
    {:ok, input} = File.read(inputPath);
    lines = String.split(input, "\r\n") |> Enum.filter(fn x -> x != "" end)
    _ = lines
    res = 1+1
    res
  end
end
