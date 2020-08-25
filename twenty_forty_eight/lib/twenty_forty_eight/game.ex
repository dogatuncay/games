defmodule TwentyFortyEight.Game do
  alias TwentyFortyEight.Board

  @enforce_keys [:board]
  defstruct @enforce_keys ++ [:is_game_over]

  def new do
    %__MODULE__{
      board: Board.initialize,
      is_game_over: false
    }
  end

  def make_move(game, direction) do
    reoriented_board = Board.reorient(game.board, direction)
    is_game_over = not Board.has_empty_tiles?(reoriented_board)
    case is_game_over do
      false ->
        new_board = Board.update_board_with_random_tile(reoriented_board)
        game = %{game | board: new_board, is_game_over: is_game_over}
        {:ok, game}
      true ->
        :game_over
    end
  end

end
