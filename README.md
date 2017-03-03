# Gol

Gol is a Conway's Game of Life cellular automata simulator for the terminal,
written in Elixir.

## To Run

+ `clone` this Repo
+ `cd` to this project's directory
+ open up the project in IEx (`iex -S mix`)
+ start the process
  + Use `Gol.hello()` to start a 15 x 15 square world
  + Use `Gol.hello(size)` to start a `size` x `size` world

## Architecture

This is a very simple implementation (architecture-wise), using only looping
processes and not GenServers.

The defaults can be edited by changing the settings in `gol.ex` as well as by
starting a `Gol.Board` process directly and passing in an initial starting
state.
