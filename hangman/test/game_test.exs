defmodule GameTest do 
  use ExUnit.Case 

  alias Hangman.Game 

  test "new_game returns structure" do 

    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing 
    assert length(game.letters) > 0
  end 

  test "state isn't changed for :won or :lost game" do 
    for state <- [ :won, :lost ] do
      game = Game.new_game() 
            |> Map.put(:game_state, state) 
      assert ^game = Game.make_move(game, "x")
    end
  end

  test "first occurence of letter is not already used" do 
    game = Game.new_game() 
    |> Game.make_move("x") 
    assert game.game_state != :already_used 
  end

  test "second occurence of letter is already used" do 
    game = Game.new_game() 
    |> Game.make_move("x") 
    assert game.game_state != :already_used
    game = Game.make_move(game, "x") 
    assert game.game_state == :already_used  
  end

  test "a good guess is recognized" do 
    game = Game.new_game("wibble") 
    |> Game.make_move("w")
    assert game.game_state == :good_guess 
    assert game.turns_left == 7 
  end

  test "a good guess is a won game" do 
    game = Game.new_game("wibble") 
    |> Map.put(:used, MapSet.new(["w", "i", "b", "l"]))
    game = Game.make_move(game, "e")
    assert game.game_state == :won 
    assert game.turns_left == 7 
  end

  test "a good guess wins the game" do
    good_moves = ["w", "i", "b", "l", "e"]
    game = Game.new_game("wibble")
    game = Enum.reduce(good_moves, game, 
      fn (move, game) -> 
        game = Game.make_move(game, move)
        game
      end 
    )
    assert game.game_state == :won 
    assert game.turns_left == 7 
  end

  test "a bad guess is recognized" do 
    game = Game.new_game("wibble") 
    |> Game.make_move("x") 
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "a bad guess has lost the game" do 
    game = Game.new_game("wibble") 
    |> Map.put(:turns_left, 1) 
    game = Game.make_move(game, "x") 
    assert game.game_state == :lost
  end

  test "a bad guess loses the game" do
    bad_moves = ["x", "r", "t", "a", "m", "o", "y"]
    game = Game.new_game("wibble")
    game = Enum.reduce(bad_moves, game, 
      fn (move, game) -> 
        game = Game.make_move(game, move)
        game
      end 
    )
    assert game.game_state == :lost 
    assert game.turns_left == 1 
  end

  # test "a vaild character returns true" do 
  #   input = "x"
  #   assert Game.is_valid?(input) == input
  # end 
end