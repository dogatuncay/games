defmodule TwentyFortyEight.ConsoleInterface do
  alias TwentyFortyEight.Game
  alias TwentyFortyEight.Board

  def play do
    game = Game.new
    game_loop(game)
  end

  def get_console_input() do
    String.trim IO.gets("Up: w Down: s Left: a Right: d -> ")
  end

  def parse_input("w"), do: :up
  def parse_input("s"), do: :down
  def parse_input("a"), do: :left
  def parse_input("d"), do: :right
  def parse_input(_), do: :error

  def collect_move() do
    input = parse_input(get_console_input())
    if input == :error do
      IO.puts("Invalid entry, try again")
      collect_move()
    else
      input
    end
  end

  def game_loop(game) do
    if game.is_game_over do
      IO.puts("Sorry, game is over !")
    else
      Board.pretty_print(game.board)

      case Game.make_move(game, collect_move()) do
        {:ok, new_game} ->
          game_loop(new_game)
        :game_over ->
          IO.puts "can't make move because game is over"
      end
    end
  end
end
