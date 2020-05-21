# Example runtime for the Oasis platform

This repo contains an example of a simple non-confidential runtime for the
[Oasis platform](https://github.com/oasislabs/oasis-core). The runtime implements
a key/value store, with the interface defined [here](api/src/api.rs).

## Directories

* `api`: The example runtime's API definition.
* `scripts`: Bash scripts for development and testing.
* `src`: The example runtime implemenation.
* `test-client`: A test client that exercises the runtime's API.
* `tests`: Resources used in end-to-end tests.

## Setting up the development environment

First, make sure that you have everything required for Oasis Core installed by
following [the instructions](https://github.com/oasislabs/oasis-core/blob/master/README.md).

In the following instructions, the top-level directory is the directory
where the code has been checked out.

## Building the runtime

To build everything required for running the runtime, simply execute in the
top-level directory:
```bash
$ make
```

## Running end-to-end tests

To run a local Oasis network "cluster," deploy the runtime, and run the test client, run:
```bash
$ make test-e2e
```
