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
  def neighbors(position) do
    [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]
    |> create_diffs(position)
    |> no_negatives
  end

  defp create_diffs(diffs, position) do
    Enum.map(diffs, fn diff ->
      {elem(diff, 0) + elem(position, 0), elem(diff, 1) + elem(position, 1)}
    end)
  end

  # actually checks to make sure nothing's smaller than 1 since
  # i moved this to a one-based system
  defp no_negatives(positions) do
    Enum.reject(positions, fn pos ->
      elem(pos, 0) < 1 || elem(pos, 1) < 1
    end)
  end
end
