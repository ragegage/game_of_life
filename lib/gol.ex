defmodule Gol do
  @moduledoc """
  Documentation for Gol.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Gol.hello
      :world

  """
  def hello do
    pid = spawn(Gol.Board, :new, [%{x: 15, y: 15}])
    loop(pid)
  end
  def hello(size) do
    pid = spawn(Gol.Board, :new, [%{x: size, y: size}])
    loop(pid)
  end
  defp loop(pid) do
    Process.sleep(200)
    send(pid, {:turn, self()})
    loop(pid)
  end
end
