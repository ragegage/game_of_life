defmodule Gol.Board do
  @doc """
  board holds the cell_pids, its x and y boundaries, and a snapshot of the game state
  """
  defstruct x: nil, y: nil, snapshot: %{}, cell_pids: []
  alias Gol.Cell

  @doc """
  receives x and y of board size and either a snapshot or none
  creates cells

  snapshot = %{{0,0} => true, {0,1} => true, {1,0} => true, {1,1} => true, }
  pid = spawn(Gol.Board, :new, [%{x: 1, y: 1, snapshot: snapshot}])


  snapshot = %{{0,0} => true, {0,1} => true, {0,2} => true, {1,0} => true, {1,1} => true, {1,2} => true, {2,0} => true, {2,1} => true, {2,2} => true, }
  
  pid = spawn(Gol.Board, :new, [%{x: 2, y: 2, snapshot: snapshot}])
  """
  def new(%{x: x, y: y, snapshot: snapshot} = size) do
    self = struct(%Gol.Board{}, size)
    self
    |> create_cells
    |> loop
  end
  # pid = spawn(Gol.Board, :new, [%{x: 2, y: 2}])
  def new(%{x: x, y: y} = size) do
    self = struct(%Gol.Board{}, size)
    %{self | snapshot: snapshot_gen(x, y)}
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
        spawn(Cell, :new, [%{position: {row, col}, alive?: self.snapshot[{row, col}]}])
      end)
    end)
    |> List.flatten
    %{self | cell_pids: cells}
  end

  defp create_snapshot(cell, self) do
    %{self | snapshot: Map.put(self.snapshot, cell.position, cell.alive?)}
  end

  # returns a string; allows IO.puts
  def render(%Gol.Board{x: x, y: y, snapshot: snapshot, cell_pids: _cells} = self) do
    0..y
    |> Enum.to_list
    |> Enum.map(fn row_index -> row_to_s(row_index, x, snapshot) end)
    |> Enum.join("\n")
    |> print
    self
  end

  defp print(board) do
    IO.puts(IO.ANSI.clear())
    IO.puts(board)
  end

  defp row_to_s(row_index, cols, snapshot) do
    0..cols
    |> Enum.to_list
    |> Enum.map(fn col_index -> 
      cell_to_s(Map.get(snapshot, {col_index, row_index}))
    end)
    |> Enum.join
  end

  defp cell_to_s(true) do
    "A"
  end
  defp cell_to_s(false) do
    " "
  end
  defp cell_to_s(other) do
    IO.inspect other
  end

  defp snapshot_gen(x, y) do
    0..y
    |> Enum.to_list
    |> Enum.map(fn row_index -> create_row(row_index, x) end)
    |> List.flatten
    |> make_map(%{})
    |> IO.inspect
  end
  defp create_row(row_index, x) do
    0..x
    |> Enum.to_list
    |> Enum.map(fn col_index -> create_cell(col_index, row_index) end)
  end
  defp create_cell(col, row) do
    if (:rand.uniform(2) - 1 == 1) do
      {col, row, true}
    else 
      {col, row, false}
    end
  end
  defp make_map([h | t], map) do
    make_map(t, Map.put(map, {elem(h, 0), elem(h, 1)}, elem(h, 2)))
  end
  defp make_map([], map) do
    map
  end
end
