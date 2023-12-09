
defmodule Mix.Tasks.FinishedDays do
  use Mix.Task

  def run(args) do
    {[{:day, day}, {:part, part}], _, _} = args |> hd |> OptionParser.split |> OptionParser.parse(strict: [day: :integer, part: :integer])

    Mix.Task.run("app.start")

    dayModule = case day do
      1 -> Day01
    end

    dayStr = day |> Integer.to_string |> String.pad_leading(2, "0")
    inputFileName = "lib/finished/input_day#{dayStr}.txt"
    # moduleName = "Day" <> dayStr

    # module = String.to_existing_atom(moduleName)
    # funSolve2 = String.to_existing_atom("solve2b")

    r = case part do
      1 -> dayModule.solve1(inputFileName)
      2 -> dayModule.solve2(inputFileName)
      # 2 -> module.solve2b(inputFileName) #apply(module, funSolve2, [inputFileName])
      # call_function(moduleName <> ".solve2",
        #
      # dayModule.solve2(inputFileName)
    end

    IO.puts(r);
  end

  # def call_function(module_and_function, args) do
  #   {module_name, function_name} =
  #     module_and_function
  #     |> String.split(".", trim: true)
  #     |> Enum.map(&String.to_existing_atom/1)

  #   apply(module_name, function_name, args)
  # end
end
