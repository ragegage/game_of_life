defmodule Gol.Board do
  @doc """
  board holds the cell_pids, its x and y boundaries, and a snapshot of the game state
  """
  defstruct x: nil, y: nil, snapshot: [], cell_pids: []
  alias Gol.Cell
  
  @doc """
  receives x and y of board size
  creates cells
  """
  def new(%{x: x, y: y} = size) do
    self = struct(%Gol.Board{}, size)
    self = %{self | cell_pids: create_cells(self)}
    loop(self)
  end

  defp loop(self) do
    receive do
      {:turn, from} ->
        # sends cells a :turn message
        # creates a new snapshot
        # prints snapshot
        loop(self)
    end
  end

  def create_cells(self) do
    Enum.map(self.x..0, fn row -> 
      Enum.map(self.y..0, fn col -> 
        # setting every cell to start off alive >:O
        spawn(Cell, :new, [%{position: {row, col}, alive?: true}])
      end)
    end)
  end
end