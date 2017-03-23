defmodule Gol.Board do
  @moduledoc """
  board holds the cell_pids, its x and y boundaries, and the previous_state of the game state

  {:ok, board} = Board.new(2, 2)
  Board.turn(board)
  """

  defstruct x: nil, y: nil, previous_state: %{}, cells: []
  alias Gol.Cell
  alias Gol.Board

  @doc """
  Use new/2 instead
  """
  def start_link(board) do
    Agent.start_link(fn -> struct(%Board{}, board) end)
  end

  @doc """
  Tells the board to update its cells

  Example usage:
  Board.turn(board)
  """
  def turn(board) do
    Agent.get(board, fn self ->
      Enum.map(self.cells, fn cell ->
        Cell.update(cell, self)
      end)
    end)
    {:ok, board}
  end

  @doc """
  returns the board's cell's information

  Example usage:
  Board.get(board)
  """
  def get(board) do
    cells = Agent.get(board, fn self ->
      cells = Enum.map(self.cells, fn cell ->
        Cell.get(cell)
      end)
    end)
    # update the board
    Agent.update(board, fn self ->
      %{self | previous_state: create_new_state(self, cells)}
    end)
    cells
    |> IO.inspect
    |> Enum.map(fn cell -> cell.alive? end)
    # |> Enum.chunk(3)
    |> Enum.chunk(Agent.get(board, fn b -> b.x end))
  end

  defp create_new_state(state, cell_list) do
    previous_state = cell_list
    |> make_map
    |> IO.inspect
  end

  @doc """
  receives x and y of board size
    + zero-based
  creates (x * y) cells
  returns {:ok, pid}

  Example usage:
  {:ok, board} = Board.new(2, 2)
  """
  def new(x, y) do
    create_cells(x, y)
    |> initial_state
    |> clean_cells
    |> start_link
  end

  defp create_cells(x, y) do
    cells = Enum.map(1..x, fn row ->
      Enum.map(1..y, fn col ->
        {:ok, cell} = Gol.Cell.new(%{position: {row,col}, alive?: true})
        %{cell_pid: cell, position: {x, y}, alive?: true}
      end)
    end)
    |> List.flatten
    %{x: x, y: y, cells: cells}
  end

  defp initial_state(%{x: x, y: y, cells: cells} = board) do
    initial_state = cells
    |> make_map
    %{x: x, y: y, cells: cells, previous_state: initial_state}
  end

  defp make_map(list) do
    # h is in the form of {cell, x, y, alive?}
    make_map(list, %{})
  end
  defp make_map([h | t], map) do
    make_map(t, Map.put(map,
                       {elem(h.position, 0), elem(h.position, 1)},
                       h.alive?))
  end
  defp make_map([], map) do
    map
  end

  # {cell, x, y, alive?} -> cell
  defp clean_cells(%{x: _x, y: _y, previous_state: _previous_state,
                     cells: cells} = board) do
    clean_cells = cells
    |> Enum.map(fn cell -> cell.cell_pid end)
    %{board | cells: clean_cells}
  end
end
