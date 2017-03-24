require IEx

defmodule Gol do
  @moduledoc """
  Documentation for Gol.
  """
  alias Gol.Board

  @doc """
  runs simulation

  Example usage:

  Gol.hello # => runs a 40 x 30 grid

  Gol.hello(30, 20) # => runs a 30 x 20 grid

  Gol.hello(300, 100, 200) # => runs a 300 x 100 grid, pausing for 200ms
    between each render
  """
  def hello do
    {:ok, board} = Board.new(40, 30)
    loop(board, 1, 70)
  end
  def hello(x, y) do
    {:ok, board} = Board.new(x, y)
    loop(board, 1, 70)
  end
  def hello(x, y, t) do
    {:ok, board} = Board.new(x, y)
    loop(board, 1, t)
  end
  defp loop(board, turn_num, wait_time) do
    Board.get(board)
    |> process_list
    |> print
    Process.sleep(wait_time)
    Board.turn(board)
    # IEx.pry
    loop(board, turn_num + 1, wait_time)
  end

  defp process_list(list) do
    Enum.map(list, fn row -> process_row(row) end)
    |> Enum.join("\n")
  end

  defp process_row(row) do
    Enum.map(row, fn cell -> if cell, do: "G", else: " " end)
    |> Enum.join
  end

  defp print(board) do
    IO.puts(IO.ANSI.clear())
    IO.puts(board)
  end
end
