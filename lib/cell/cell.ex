require IEx
defmodule Gol.Cell do
  @moduledoc """
  Each cell keeps track of its position and its alive? property (true or false)
  """

  alias Gol.Cell
  alias Gol.Helper
  defstruct [alive?: nil, position: {nil, nil}]


  def start_link(values) do
    Agent.start_link(fn -> struct(%Cell{}, values) end)
  end

  @doc """
  tells a cell to update its alive? property using the given information

  Example usage:
  Cell.update(cell, %{snapshot: %{}})
  """
  def update(position, board) do
    self = Agent.get(position, fn c -> c end)
    Helper.neighbors(self.position)
    # handles nils as well as zeroes
    |> Enum.reduce(0, fn(cell, acc) ->
      location_value = Map.get(board.snapshot, cell)
      if location_value && location_value > 0, do: acc + 1, else: acc
    end)
    |> assess(self)
    |> (fn new_state ->
      Agent.update(position, fn state -> %{state | alive?: new_state.alive?} end)
    end).()
  end

  @doc """
  returns the cell's information in the format
  %Gol.Cell{alive?: false, position: {0, 0}}

  Example usage:
  Cell.get(cell)
  """
  def get(position) do
    Agent.get(position, fn cell -> cell end)
  end

  @doc """
  creates a new cell

  Example usage:
  pid = spawn(fn -> Gol.Cell.new(%{position: {0,0}, alive?: true}) end)
  or
  pid2 = spawn(Gol.Cell, :new, [%{position: {0,0}, alive?: true}])

  OR

  {:ok, cell} = Gol.Cell.new(%{position: {0,0}, alive?: true})
  """
  def new(values) do
    # struct(%Cell{}, values)
    start_link(values)
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
