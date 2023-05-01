# conways_game_of_life_ruby_matrix_toy

For fun today while I was waiting for my car to be inspected I went down the path to building conways game of life.

Ultimately, the point is to observe how the ruby Matrix class works. Understand the relationship between vectors and use this mechanism
to create a training set to help a computer predict the life and age of the average cell.

This project uses asdf with some help of a Makefile so check that out.

## Running
Run
```sh
make run
```

Run with Opts
```sh
make run SEED=483383 DIMENSIONS=20,20
```

REPL (Loads the base tools so you can play with rendering)
```sh
make console
```
