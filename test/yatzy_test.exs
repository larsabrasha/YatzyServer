defmodule YatzyTest do
  use ExUnit.Case, async: true
  doctest Yatzy

  test "random_dice_value" do
    dice_value = Yatzy.random_dice_value()
    assert dice_value >= 1 && dice_value <= 6
  end

  test "random_dice" do
    dice = Yatzy.random_dice()

    assert Enum.count(dice) == 5
    dice |> Enum.each(&assert(&1.value >= 1 && &1.value <= 6))
  end

  test "count_dice" do
    dice_count = Yatzy.count_dice([2, 6, 1, 3, 3])

    expected_dice_count = [
      %ValueCount{value: 1, count: 1},
      %ValueCount{value: 2, count: 1},
      %ValueCount{value: 3, count: 2},
      %ValueCount{value: 4, count: 0},
      %ValueCount{value: 5, count: 0},
      %ValueCount{value: 6, count: 1}
    ]

    assert inspect(dice_count) == inspect(expected_dice_count)
  end

  test "number_of_different_values" do
    assert Yatzy.number_of_different_values([1, 2, 3, 4, 5]) == 5
    assert Yatzy.number_of_different_values([1, 1, 1, 1, 1]) == 1
    assert Yatzy.number_of_different_values([1, 1, 1, 5, 5]) == 2
  end

  test "numbers" do
    assert Yatzy.numbers([1, 2, 1, 5, 3], 1) == 2
    assert Yatzy.numbers([2, 2, 1, 2, 3], 2) == 3
    assert Yatzy.numbers([2, 2, 1, 2, 3], 3) == 1
    assert Yatzy.numbers([4, 4, 4, 2, 4], 4) == 4
    assert Yatzy.numbers([2, 2, 5, 2, 3], 5) == 1
    assert Yatzy.numbers([6, 2, 1, 2, 6], 6) == 2
    assert Yatzy.numbers([6, 2, 3, 2, 6], 1) == 0
  end

  test "one_pair" do
    assert Yatzy.one_pair([1, 1, 1, 1, 1]) == 2
    assert Yatzy.one_pair([1, 1, 1, 6, 6]) == 12
    assert Yatzy.one_pair([1, 2, 3, 4, 5]) == 0
  end

  test "two_pair" do
    assert Yatzy.two_pairs([1, 1, 1, 1, 1]) == 0
    assert Yatzy.two_pairs([1, 1, 1, 6, 6]) == 14
    assert Yatzy.two_pairs([1, 2, 3, 4, 5]) == 0
    assert Yatzy.two_pairs([1, 1, 3, 4, 5]) == 0
  end

  test "three_same" do
    assert Yatzy.three_same([1, 1, 1, 4, 5]) == 3
    assert Yatzy.three_same([2, 1, 2, 2, 5]) == 6
    assert Yatzy.three_same([2, 1, 2, 5, 5]) == 0
  end

  test "four_same" do
    assert Yatzy.four_same([1, 2, 3, 4, 5]) == 0
    assert Yatzy.four_same([1, 1, 2, 2, 5]) == 0
    assert Yatzy.four_same([1, 1, 1, 5, 5]) == 0
    assert Yatzy.four_same([2, 2, 2, 2, 5]) == 8
  end

  test "small_straight" do
    assert Yatzy.small_straight([1, 2, 3, 4, 5]) == 15
    assert Yatzy.small_straight([2, 3, 4, 5, 6]) == 0
    assert Yatzy.small_straight([2, 2, 3, 5, 6]) == 0
  end

  test "big_straight" do
    assert Yatzy.big_straight([1, 2, 3, 4, 5]) == 0
    assert Yatzy.big_straight([2, 3, 4, 5, 6]) == 20
    assert Yatzy.big_straight([2, 2, 3, 5, 6]) == 0
  end

  test "chance" do
    assert Yatzy.chance([1, 2, 3, 4, 5]) == 15
    assert Yatzy.chance([2, 3, 4, 5, 6]) == 20
    assert Yatzy.chance([2, 2, 3, 5, 6]) == 18
  end

  test "kak" do
    assert Yatzy.kak([1, 1, 1, 1, 1]) == 0
    assert Yatzy.kak([1, 1, 1, 1, 5]) == 0
    assert Yatzy.kak([1, 1, 1, 5, 5]) == 13
    assert Yatzy.kak([1, 1, 2, 5, 5]) == 0
  end

  test "yatzy" do
    assert Yatzy.yatzy([2, 2, 2, 2, 2]) == 50
    assert Yatzy.yatzy([2, 2, 2, 2, 6]) == 0
  end
end
