# Closure compiler container

This container provides a persistent runtime for Closure Compiler, the Java binary.
Mainly this is used in CI systems for webapps.

## Releasing

- Update the Dockerfile with the correct version of Closure Compiler
- Run `make build` and `make test`.
- Create a new Git tag with the printed `Version:...` string.
- Push the new tag to GitHub.


