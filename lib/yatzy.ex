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

  def count_dice(dice) do
    1..6
    |> Enum.map(fn x -> %ValueCount{value: x, count: Enum.count(dice, &(&1 == x))} end)
  end

  def number_of_different_values(dice) do
    dice
    |> count_dice
    |> Enum.reduce(
      0,
      &if(&1.count > 0, do: 1 + &2, else: &2)
    )
  end

  def numbers(dice, value) do
    (dice
     |> count_dice
     |> Enum.find(&(&1.value == value))).count
  end

  def one_pair(dice) do
    dice
    |> count_dice
    |> Enum.reduce(0, &if(&1.count >= 2 && &1.value * 2 > &2, do: &1.value * 2, else: &2))
  end

  def two_pairs(dice) do
    dice
    |> count_dice
    |> Enum.sort(&(&1.value >= &2.value))
    |> Enum.reduce(%{best_twos: 0, next_best_twos: 0}, fn cur, acc ->
      cond do
        cur.count >= 2 && cur.value * 2 > acc.best_twos ->
          %{best_twos: cur.value * 2, next_best_twos: acc.next_best_twos}

        cur.count >= 2 && cur.value * 2 > acc.next_best_twos ->
          %{best_twos: acc.best_twos, next_best_twos: cur.value * 2}

        true ->
          acc
      end
    end)
    |> (&if(&1.best_twos > 0 && &1.next_best_twos > 0,
          do: &1.best_twos + &1.next_best_twos,
          else: 0
        )).()
  end

  def three_same(dice) do
    dice
    |> count_dice
    |> Enum.reduce(0, &if(&1.count >= 3, do: &1.value * 3, else: &2))
  end

  def four_same(dice) do
    dice
    |> count_dice
    |> Enum.reduce(0, &if(&1.count >= 4, do: &1.value * 4, else: &2))
  end

  def small_straight(dice) do
    1..5
    |> Enum.all?(&(Enum.count(dice, fn x -> x == &1 end) == 1))
    |> (&if(&1, do: 15, else: 0)).()
  end

  def big_straight(dice) do
    2..6
    |> Enum.all?(&(Enum.count(dice, fn x -> x == &1 end) == 1))
    |> (&if(&1, do: 20, else: 0)).()
  end

  def chance(dice) do
    dice
    |> Enum.sum()
  end

  def kak(dice) do
    dice
    |> count_dice
    |> Enum.reduce(%{best_threes: 0, best_twos: 0}, fn cur, acc ->
      cond do
        cur.count >= 3 && cur.value * 3 > acc.best_threes ->
          %{best_threes: cur.value * 3, best_twos: acc.best_twos}

        cur.count >= 2 && cur.value * 2 > acc.best_twos ->
          %{best_threes: acc.best_threes, best_twos: cur.value * 2}

        true ->
          acc
      end
    end)
    |> (&if(&1.best_threes > 0 && &1.best_twos > 0, do: &1.best_threes + &1.best_twos, else: 0)).()
  end

  def yatzy(dice) do
    dice
    |> count_dice
    |> Enum.reduce(0, &if(&1.count >= 5, do: 50, else: &2))
  end
end
