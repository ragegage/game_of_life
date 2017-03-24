# Gol

Gol is a Conway's Game of Life cellular automata simulator for the
terminal, written in Elixir.

## To Run

+ `clone` this Repo
+ `cd` to this project's directory
+ open up the project in IEx (`iex -S mix`)
+ start the process
  + Use `Gol.hello()` to start a world simulation
  + Use `Gol.hello(x, y)` to start an `x` x `y` world
  + Use `Gol.hello(x, y, t)` to start an `x` x `y` world that pauses 
  for `t`ms between each rendering

## Architecture

This is a very simple implementation (architecture-wise), using Agents
to manage the state and message-passing properties of both the cells 
and the board.

The defaults can be edited by changing the settings in `gol.ex` as well
as by starting a `Gol.Board` process directly and passing in an initial
starting state.

The Gol module's `hello/0` and `hello/1` functions create a Board
process, ask it for its state, and print it to the console. They then
sleep for 70ms to display the information, send a :turn message to the 
board, and repeat the process.

The Board process creates (`x` x `y`) Cell processes and sends them each
a :turn message whenever it receives a :turn message. When the board 
receives a request for its state, it asks each Cell for its state, 
compiles that information, and responds to the Gol process.

The Cell process, whenever it receives a :turn message, determines
whether it should be alive or dead based on its neighbors' status. It 
returns its current status when asked about its state.
