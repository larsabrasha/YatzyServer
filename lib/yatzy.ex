defmodule Dice do
  @enforce_keys [:dice]
  defstruct [:dice, :value]
end

defmodule ValueCount do
  @enforce_keys [:value, :count]
  defstruct [:value, :count]
end

defmodule Yatzy do
  def random_dice_value do
    Enum.random(1..6)
  end

  def random_dice do
    1..5
    |> Enum.map(
      &%Dice{
        dice: &1,
        value: Yatzy.random_dice_value()
      }
    )
  end

  def numbers(dice, value) do
    (dice
     |> Enum.filter(&(&1 == value))
     |> Enum.count()) * value
  end

  def one_pair(dice) do
    case dice |> Enum.sort() do
      [_, _, _, a, a] -> a * 2
      [_, _, a, a, _] -> a * 2
      [_, a, a, _, _] -> a * 2
      [a, a, _, _, _] -> a * 2
      _ -> 0
    end
  end

  def two_pairs(dice) do
    case dice |> Enum.sort() do
      [_, a, a, b, b] when a != b -> a * 2 + b * 2
      [a, a, _, b, b] when a != b -> a * 2 + b * 2
      [a, a, b, b, _] when a != b -> a * 2 + b * 2
      _ -> 0
    end
  end

  def three_of_a_kind(dice) do
    case dice |> Enum.sort() do
      [_, _, a, a, a] -> a * 3
      [_, a, a, a, _] -> a * 3
      [a, a, a, _, _] -> a * 3
      _ -> 0
    end
  end

  def four_of_a_kind(dice) do
    case dice |> Enum.sort() do
      [_, a, a, a, a] -> a * 4
      [a, a, a, a, _] -> a * 4
      _ -> 0
    end
  end

  def small_straight(dice) do
    case dice |> Enum.sort() do
      [1, 2, 3, 4, 5] -> 15
      _ -> 0
    end
  end

  def large_straight(dice) do
    case dice |> Enum.sort() do
      [2, 3, 4, 5, 6] -> 20
      _ -> 0
    end
  end

  def chance(dice) do
    dice
    |> Enum.sum()
  end

  def full_house(dice) do
    case dice |> Enum.sort() do
      [a, a, b, b, b] when a != b -> dice |> Enum.sum()
      [a, a, a, b, b] when a != b -> dice |> Enum.sum()
      _ -> 0
    end
  end

  def yatzy(dice) do
    case dice do
      [a, a, a, a, a] -> 50
      _ -> 0
    end
  end
end
