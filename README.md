# Gol

Gol is a Conway's Game of Life cellular automata simulator for the
terminal, written in Elixir.

## To Run

+ `clone` this Repo
+ `cd` to this project's directory
+ open up the project in IEx (`iex -S mix`)
+ start the process
  + Use `Gol.hello()` to start a 15 x 15 square world
  + Use `Gol.hello(size)` to start a `size` x `size` world

## Architecture

This is a very simple implementation (architecture-wise), using only
looping processes and not GenServers.

The defaults can be edited by changing the settings in `gol.ex` as well
as by starting a `Gol.Board` process directly and passing in an initial
starting state.

The Gol module's `hello/0` and `hello/1` functions create a Board
process, send it a :turn message, and wait for a response. Once they get
a response, they sleep for a tenth of a second to display the
information, send another :turn message, and wait for a new response.

The Board process creates (size ^ 2) Cell processes and sends them each
a :turn message whenever it receives a :turn message. Once it has
received (size ^ 2) responses, it prints the new game state and responds
to the Gol.

The Cell process, whenever it receives a :turn message, determines
whether it should be alive or dead based on its neighbors' status and
returns its new status.
