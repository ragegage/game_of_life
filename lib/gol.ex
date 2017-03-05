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
    send(pid, {:turn, self()})
    loop(1)
  end
  def hello(size) do
    pid = spawn(Gol.Board, :new, [%{x: size, y: size}])
    send(pid, {:turn, self()})
    loop(1)
  end
  defp loop(turn_num) do
    receive do
      {:print, from} ->
        IO.puts(turn_num)
        Process.sleep(100)
        send(from, {:turn, self()})
        loop(turn_num + 1)
    end
  end
end
