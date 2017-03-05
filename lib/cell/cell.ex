defmodule Gol.Cell do
  @moduledoc """
  Each cell keeps track of its position and its alive? property (true or false)
  """
  alias Gol.Cell
  alias Gol.Helper
  defstruct [alive?: nil, position: {nil, nil}]

  @doc """
  creates a new cell
  
  Example usage:
  pid = spawn(fn -> Gol.Cell.new(%{position: {0,0}, alive?: true}) end)
  or
  pid2 = spawn(Gol.Cell, :new, [%{position: {0,0}, alive?: true}])
  """
  def new(%{position: _position, alive?: _alive?} = values) do
    # struct(%Cell{}, values)
    loop(struct(%Cell{}, values))
  end

  defp loop(self) do
    receive do
      {{:turn, board}, from} ->
        board
        |> Helper.neighbors(self.position)
        |> Enum.reduce(0, fn(cell, acc) ->
          if Map.get(board.snapshot, cell), do: acc + 1, else: acc
        end)
        |> assess(self)
        |> (&(send(from, {:cell, &1}))).()
        |> fn res -> loop(elem(res, 1)) end.()
      other ->
        IO.puts("other")
        IO.inspect(other)
        loop(self)
    end
  end

  @doc """
  updates alive? based on count
  """
  def assess(count, self) when count < 2 do
    %{self | alive?: false}
  end
  def assess(count, self) when count > 3 do
    %{self | alive?: false}
  end
  def assess(count, self) when count == 3 do
    # live and also rebirth
    %{self | alive?: true}
  end
  def assess(_count, self) do
    # live but no rebirth
    self
  end
end
