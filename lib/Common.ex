defmodule Common do
  def all_pairs(list1, list2) do
    Enum.flat_map(list1, fn elem1 ->
      Enum.map(list2, fn elem2 ->
        {elem1, elem2}
      end)
    end)
  end
end
