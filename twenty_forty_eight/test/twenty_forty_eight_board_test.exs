defmodule TwentyFortyEightBoardTest do
  use ExUnit.Case
  doctest TwentyFortyEight.Board
  alias TwentyFortyEight.Board

  test "creates a new board" do
    empty_board = [
      [:empty, :empty, :empty, :empty],
      [:empty, :empty, :empty, :empty],
      [:empty, :empty, :empty, :empty],
      [:empty, :empty, :empty, :empty]
    ]

    assert Board.create_new_board() == empty_board
  end

  test "updates the board with given value and coordinates" do
    empty_board = [
      [:empty, :empty, :empty, :empty],
      [:empty, :empty, :empty, :empty],
      [:empty, :empty, :empty, :empty],
      [:empty, :empty, :empty, :empty]
    ]

    assert Board.update_board(empty_board, [0,0], 2) == [
      [2, :empty, :empty, :empty],
      [:empty, :empty, :empty, :empty],
      [:empty, :empty, :empty, :empty],
      [:empty, :empty, :empty, :empty]
    ]

    assert Board.update_board(empty_board, [2,3], 8) == [
      [:empty, :empty, :empty, :empty],
      [:empty, :empty, :empty, :empty],
      [:empty, :empty, :empty, 8],
      [:empty, :empty, :empty, :empty]
    ]
  end

  test "compresses a list by getting rid of :empty elements" do
    list = [:empty, 1, :empty, 2]
    assert Board.compress(list) == [1,2]
  end

  test "gets a list of row and column indexes of available tiles of a board" do
    board = [
      [2, :empty, 4, :empty],
      [16, :empty, :empty, :empty],
      [8, 2, :empty, :empty],
      [:empty, :empty, 8, :empty]
    ]

    available_tiles_list = [[0, 1], [0, 3], [1, 1], [1, 2], [1, 3], [2, 2], [2, 3], [3, 0], [3, 1], [3, 3]]
    assert Enum.sort(Board.available_tiles(board)) == Enum.sort(available_tiles_list)
  end

  test "returns a random element from a given list" do
    available_tiles_list = [[0, 1], [0, 3], [1, 1], [1, 2], [1, 3]]

    assert Board.random_available_tile(available_tiles_list) in available_tiles_list
  end

  test "generates a random number that is either 2 or 4" do
    assert Board.random_tile_number in [2, 4]
  end

  test "finds the number of digits of the biggest integer in the board" do
    board = [
      [2, :empty, 4, :empty],
      [2048, :empty, :empty, :empty],
      [8, 2, :empty, :empty],
      [:empty, :empty, 8, :empty]
    ]

    assert Board.get_max_tile_length(board) == 4
  end

  test "pads lists with empty items depending on the direction until it reaches length of 4 items" do
    l1 = [4,5]
    assert Board.pad_list(l1, :left) == [4, 5, :empty, :empty]
    assert Board.pad_list(l1, :up) == [4, 5, :empty, :empty]

    l2 = [4,5]
    assert Board.pad_list(l2, :right) == [:empty, :empty, 4, 5]
    assert Board.pad_list(l2, :down) == [:empty, :empty, 4, 5]
  end

  test "gets columns of a board" do
    example_board = [
      [2, 4, :empty, 16],
      [2, 4, :empty, 16],
      [2, 4, :empty, 16],
      [2, 4, :empty, 16]
    ]

    result_board = [
      [2, 2, 2, 2],
      [4, 4, 4, 4],
      [:empty, :empty, :empty, :empty],
      [16, 16, 16, 16]
    ]
    assert Board.get_columns(example_board) == result_board
  end


  test "gets the pair sums of a compressed list" do
    l1 = [4,8,8,4]
    assert Board.get_sums(l1) == [4, 16, 4]

    l2 = [2,2,4,2]
    assert Board.get_sums(l2) == [4,4,2]

    l3 = [4,8,2]
    assert Board.get_sums(l3) == [4,8,2]

    l4 = [4,4,4]
    assert Board.get_sums(l4) == [8,4]

    l5 = [2,2]
    assert Board.get_sums(l5) == [4]

    l6 = [4]
    assert Board.get_sums(l6) == [4]

    l7 = []
    assert Board.get_sums(l7) == []
  end

  test "rotates the list with given direction" do
    example_board = [
      [8, 4, :empty, 16],
      [2, 8, :empty, :empty],
      [2, 4, :empty, 32],
      [2, 4, 8, 16]
    ]
    rotated_board = [
      [8, 2, 2, 2],
      [4, 8, 4, 4],
      [:empty, :empty, :empty, 8],
      [16, :empty, 32, 16]
    ]
    assert Board.rotate(example_board) == rotated_board
  end

  test "reorients the board with given direction" do
    example_board = [
      [:empty, 4, 4, 4],
      [4, :empty, 4, :empty],
      [:empty, 4, 8, 2],
      [2, 2, 4, 2]
    ]

    left_board = [
      [8, 4, :empty, :empty],
      [8, :empty, :empty, :empty],
      [4, 8, 2, :empty],
      [4, 4, 2, :empty]
    ]

    right_board = [
      [:empty, :empty, 4, 8],
      [:empty, :empty, :empty, 8],
      [:empty, 4, 8, 2],
      [:empty, 4, 4, 2]
    ]

    up_board = [
      [4, 8, 8, 4],
      [2, 2, 8, 4],
      [:empty, :empty, 4, :empty],
      [:empty, :empty, :empty, :empty]
    ]

    down_board = [
      [:empty, :empty, :empty, :empty],
      [:empty, :empty, 8, :empty],
      [4, 8, 8, 4],
      [2, 2, 4, 4]
    ]

    assert Board.reorient(example_board, :up) == up_board
    assert Board.reorient(example_board, :left) == left_board
    assert Board.reorient(example_board, :right) == right_board
    assert Board.reorient(example_board, :down) == down_board
  end
end
