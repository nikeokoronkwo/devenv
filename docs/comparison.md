# Comparing Devenv

## Devenv vs GNU Make
GNU Make is a build and automation

Devenv is designed with a different philosophy and focus in mind. While GNU Make is designed moreso for building projects, Devenv is designed for developing them. Devenv's script feature isn't intended to replace GNU Make, but rather to augment it (i.e you can have all necessary build tasks for test, prod, dev, etc and then have `devenv` call into them via `make <cmd>`). 
Devenv also has other features not in GNU Make suitable for developing, like development environments for instance.

Devenv is designed with cross-platform compatibility in mind thanks to the Dart language.