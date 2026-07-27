This document covers installing the kit from source.

Prerequisites
-------------

Required software:

* C compiler
* `CMake <https://cmake.org/>`_ is the build system used

Recommended software:

* `Make` can be used with the supplied `Makefile` for running common build
  tasks

Building
--------

Using `make`::

	make release

Or using CMake presets directly::

	cmake --preset release
	cmake --build --preset release

See `CMakePresets.json` for available presets and `Makefile` for additional
targets.

Installing
----------

::

	cd build/release
	cmake --install . --prefix /usr/local

Uninstalling
------------

::

	xargs rm < install_manifest.txt

The file `install_manifest.txt` will be created in the build directory
after installing.
