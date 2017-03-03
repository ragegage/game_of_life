defmodule Gol.Board do
  @doc """
  board holds the cell_pids, its x and y boundaries, and a snapshot of the game state
  """
  defstruct x: nil, y: nil, snapshot: %{}, cell_pids: []
  alias Gol.Cell

  @doc """
  receives x and y of board size
  creates cells

  pid = spawn(Gol.Board, :new, [%{x: 1, y: 1}])
  """
  def new(%{x: x, y: y} = size) do
    self = struct(%Gol.Board{}, size)
    self
    |> create_cells
    |> loop
  end

  # send(pid, {:turn, self()})
  defp loop(self) do
    receive do
      {:turn, from} ->
        # sends cells a :turn message
        Enum.map(self.cell_pids, fn cell ->
          send(cell, {{:turn, self}, self()})
        end)
        loop(self)
      {:cell, data} ->
        data
        |> create_snapshot(self)
        |> render
        |> loop
    end
  end

  defp create_cells(self) do
    cells = Enum.map(self.x..0, fn row ->
      Enum.map(self.y..0, fn col ->
        # setting every cell to start off alive >:O
        spawn(Cell, :new, [%{position: {row, col}, alive?: true}])
      end)
    end)
    |> List.flatten
    %{self | cell_pids: cells, snapshot: %{{0,0} => true, {0,1} => true, {1,0} => true, {1,1} => true, }}
  end

  defp create_snapshot(cell, self) do
    %{self | snapshot: Map.put(self.snapshot, cell.position, cell.alive?)}
  end

  defp render(self) do
    Enum.each(Map.values(self.snapshot), fn cell ->
      cell
      |> print_cell
      |> IO.puts
    end)
    self
  end

  defp print_cell(true) do
    "A"
  end
  defp print_cell(false) do
    " "
  end
end
