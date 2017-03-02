defmodule Gol.Helper do
  @moduledoc """
  helper functions to manage board and cells
  """

  @doc """
  returns neighbors of position

  board must have x and y properties
  position must be a tuple

  base position modified with these diffs
    -1, -1
    -1, 0
    -1, 1
    0, -1
    0, 1
    1, -1
    1, 0
    1, 1

    checks:
    no negatives
    must be within board dimensions
  """
  def neighbors(board, position) do
    [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]
    |> create_diffs(position)
    |> no_negatives
    |> on_board(board)
  end

  defp create_diffs(diffs, position) do
    Enum.map(diffs, fn diff -> 
      {elem(diff, 0) + elem(position, 0), elem(diff, 1) + elem(position, 1)} 
    end)
  end

  defp no_negatives(positions) do
    Enum.reject(positions, fn pos -> 
      elem(pos, 0) < 0 || elem(pos, 1) < 0
    end)
  end

  defp on_board(positions, board) do
    Enum.filter(positions, fn pos -> 
      elem(pos, 0) < board.x && elem(pos, 1) < board.y
    end)
  end
end