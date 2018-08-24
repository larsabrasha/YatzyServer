defmodule GameTest do
  use ExUnit.Case, async: true

  test "throw dice" do
    {:ok, bucket} = Game.start_link([], %{number_of_throws: 3})
    assert Game.get(bucket, :number_of_throws) == 3

    Game.throw_dice(bucket);
    assert Game.get(bucket, :number_of_throws) == 2
  end
end
