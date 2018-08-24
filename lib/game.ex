defmodule PlayerData do
  defstruct name: "PlayerName", slots: []
end

defmodule GameData do
  defstruct number_of_throws: 0, dice: [], playerData: %PlayerData{}
end

defmodule Game do
  use Agent

  def start_link(_opts, data \\ %{}) do
    Agent.start_link(fn -> data end)
  end

  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  def throw_dice(bucket) do
    Agent.update(bucket, fn b ->
      Map.update(b, :dice, 1, fn _ -> Yatzy.random_dice() end)
      |> Map.update(:number_of_throws, 1, &(&1 - 1))
    end)
  end
end
