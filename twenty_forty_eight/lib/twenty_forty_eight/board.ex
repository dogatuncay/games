defmodule TwentyFortyEight.Board do
  def create_new_board do
    Enum.reduce(0..3, [], fn _, accr ->
      [Enum.reduce(0..3, [], fn _, accc -> [:empty | accc] end) | accr]
    end)
  end

  def initialize do
    board = create_new_board()
    initialize_board_tiles(board)
  end

  def update_board(board, [row_index, column_index], tile_value) do
    board = List.update_at(board, row_index, fn row ->
      List.update_at(row, column_index, fn _ ->
        tile_value
      end)
    end)
    board
  end

  def update_board_with_random_tile(board) do
    number = random_tile_number()
    available_tiles_list = available_tiles(board)
    available_tile = random_available_tile(available_tiles_list)
    IO.inspect available_tile
    update_board(board, available_tile, number)
  end

  def initialize_board_tiles(board) do
      board = update_board_with_random_tile(board)
      board = update_board_with_random_tile(board)
      board
  end

  def available_tiles(board) do
    Enum.reduce(0..15, [], fn index, acc ->
      row_index = div(index, 4)
      column_index = rem(index, 4)
      tile = Enum.at(Enum.at(board, row_index), column_index)
      if tile == :empty, do: [[row_index, column_index] | acc], else: acc
    end)
  end

  def random_available_tile(available_tiles_list) do
    random_index = Enum.random(0..length(available_tiles_list)-1)
    Enum.at(available_tiles_list, random_index)
  end

  def random_tile_number do
    if :rand.uniform() < 0.9, do: 2, else: 4
  end

  def get_length_of_int(num), do: length(Integer.digits(num))

  def get_max_tile_length(board) do
    max_tile_number = Enum.max(Enum.filter(List.flatten(board), fn tile -> tile != :empty end))
    get_length_of_int(max_tile_number)
  end

  def string_of_piece(:empty, max_length), do: String.duplicate(" ", max_length)
  def string_of_piece(num, max_length) do
    num_str = Integer.to_string num
    num_str <> String.duplicate(" ", max_length - get_length_of_int(num))
  end

  def pretty_print_row(row, max_length) do
    Enum.map(row, fn tile -> " #{string_of_piece(tile, max_length)} " end)
    |> Enum.join("|")
    |> IO.puts
  end

  def border(max_length) do
    tile_border = "--" <> String.duplicate("-", max_length) <> " "
    String.duplicate(tile_border, 4)
  end
  def pretty_print(board) do
    max_length = get_max_tile_length(board)
    Enum.each(board, fn row ->
      IO.puts border(max_length)
      pretty_print_row(row, max_length)
    end)
    IO.puts border(max_length)
  end

  def get_sums([tile, tile | r]), do: [tile+tile | get_sums(r)]
  def get_sums([tile1, tile2 | r]), do: [tile1 | get_sums([tile2|r])]
  def get_sums(ls), do: ls

  def compress(list) do
    Enum.filter(list, fn item -> item != :empty end)
  end

  def pad_list(summed_list, dir) do
    case dir do
      dir when dir in [:left, :up] -> summed_list ++ List.duplicate(:empty, 4 - length(summed_list))
      dir when dir in [:right, :down] -> List.duplicate(:empty, 4 - length(summed_list)) ++ summed_list
      _ -> IO.puts "This should not happen"
    end
  end

  def get_columns(board) do
    Enum.map(0..3, fn index ->
      Enum.map(board, fn row -> Enum.at(row, index) end)
    end)
  end
  def rotate(board) do
    Enum.map(0..3, fn index -> Enum.map(board, &Enum.at(&1, index)) end)
  end

  def reorient(board, dir) do
    {axis, transform, rotate} = case dir do
      :left -> {&Function.identity/1, &Function.identity/1, &Function.identity/1}
      :up -> {&get_columns/1, &Function.identity/1, &rotate(&1)}
      :right -> {&Function.identity/1, &Enum.reverse/1, &Function.identity/1}
      :down -> {&get_columns/1, &Function.identity/1, &rotate(&1)}
    end

    new_board = Enum.map(axis.(board), fn axis_row ->
      axis_row
      |> compress
      |> transform.()
      |> get_sums
      |> transform.()
      |> pad_list(dir)
    end)
    rotate.(new_board)
  end

  def has_empty_tiles?(board) do
    Enum.any?(List.flatten(board), fn tile -> tile == :empty end)
  end
end
