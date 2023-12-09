defmodule Game do
  defstruct [:id, :sets]
end

defmodule Set do
  defstruct red: 0, green: 0, blue: 0
end



defmodule Day02 do


  def toSet(str) do
    descs = str |> (String.split(", ")) |> Enum.map(&String.split(&1, " "))

    state0 = %Set{red: 0, green: 0, blue: 0}
    r =
      descs
      |> List.foldl(state0,
          fn([strNum, color], s) ->
            num = strNum |> String.to_integer
            case color do
              "red" -> %{s | red: s.red + num}
              "green" -> %{s | green: s.green + num}
              "blue" -> %{s | blue: s.blue + num}
          end
        end)

    r
  end

  def toGame(ln) do
    [gameHeader, gameDesc] = ln |> String.split(": ")
    id = gameHeader |> String.split(~r/(\s|\:)/) |> List.last |> String.to_integer()
    sets = gameDesc |> String.split(~r/;\s/) |> (Enum.map(fn str -> toSet str end))
    %Game{sets: sets, id: id}
  end

  def solve1 inputPath do
    {:ok, input} = File.read(inputPath);
    lines = String.split(input, "\r\n") |> Enum.filter(fn x -> x != "" end)
    parsedGames = lines |> Enum.map(&toGame(&1))

    reqSet = %Set{red: 12, green: 13, blue: 14}
    possibleGames = parsedGames |> Enum.filter(fn x -> fitsRequirements(x, reqSet) end)

    res = possibleGames |> Enum.map(&(&1.id)) |> Enum.sum
    res
  end

  def fitsRequirements(game, reqSet) do
    game.sets |> Enum.all?(fn s -> s.red <= reqSet.red && s.green <= reqSet.green && s.blue <= reqSet.blue end)
  end

  def solve2 inputPath do
    {:ok, input} = File.read(inputPath);
    lines = String.split(input, "\r\n") |> Enum.filter(fn x -> x != "" end)
    parsedGames = lines |> Enum.map(&toGame(&1))

    gameRequirements = parsedGames |> Enum.map(fn game -> getGameRequirements(game) end)

    cubePowers = gameRequirements |> Enum.map(fn set -> set.red * set.green * set.blue end)


    res = cubePowers |> Enum.sum
    res
  end

  def getGameRequirements(game) do
    reqInit = %Set{red: 0, green: 0, blue: 0}
    game.sets
    |> List.foldl(reqInit, fn(set,req) ->
      %Set{red: max(set.red, req.red), green: max(set.green, req.green), blue: max(set.blue, req.blue)}
     end)
  end
end
