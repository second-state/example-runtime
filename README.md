# Example (non-confidential) runtime for the Oasis platform

## Setting up the development environment

First, make sure that you have everything required for Oasis Core installed by
following [the instructions](https://github.com/oasislabs/oasis-core/blob/master/README.md).

For testing the runtime, you need to have specific Oasis Core artifacts available.
To do this, you can either:

* Build Oasis Core locally by checking out the oasis-core repository (e.g., in `/path/to/oasis-core`)
  and then running `OASIS_UNSAFE_SKIP_KM_POLICY=1 make -C /path/to/oasis-core`. After the
  process completes you can then run `make symlink-artifacts OASIS_CORE_SRC_PATH=/path/to/oasis-core`
  and all the required artifacts will be symlinked under `.oasis-core`.

* Manually provide the required artifacts in a custom directory and specify
  `OASIS_CORE_ROOT_PATH=/path/to/oasis-core` on each invocation of `make`, e.g.
  `make OASIS_CORE_ROOT_PATH=/path/to/oasis-core`.

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
