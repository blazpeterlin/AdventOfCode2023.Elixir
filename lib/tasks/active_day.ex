defmodule Mix.Tasks.ActiveDay do
  use Mix.Task

  @deleteme "
todo
"

  def run(_) do
    Mix.Task.run("app.start")

    r = ActiveDay.solve1()
    IO.puts(r);
  end
end
