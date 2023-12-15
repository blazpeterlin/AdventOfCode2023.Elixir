defmodule Mix.Tasks.ActiveDay do
  use Mix.Task

  def run(_) do
    Mix.Task.run("app.start")

    r1 = ActiveDay16.solve1("lib/input.txt")
    IO.puts(r1);
    r2 = ActiveDay16.solve2("lib/input.txt")
    IO.puts(r2);
  end
end
