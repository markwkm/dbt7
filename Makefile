# Top-level convenience wrapper around CMake Presets.
# See CMakePresets.json for the underlying configuration.

ifneq ($(wildcard CMakeCache.txt),)
$(error In-source build detected. Remove CMakeCache.txt and use out-of-source builds.)
endif

.PHONY: appimage clean debug default package release test

default:
	@echo "targets: appimage (Linux only), clean, debug, package," \
			"release, test"

appimage:
	cmake --preset appimage
	cmake --build --preset appimage --target install -- DESTDIR=../AppDir
	rm -rf build/AppDir/opt/dsgen
	mkdir -p build/AppDir/opt
	cp -a build/appimage/dsgen build/AppDir/opt/dsgen
	build/AppDir/usr/bin/dbt7-build-dsgen --patch-dir=patches \
			build/AppDir/opt/dsgen
	sed -i -e "s#/usr#././#g" build/AppDir/opt/dsgen/tools/dsdgen \
			build/AppDir/opt/dsgen/tools/dsqgen
	cd build/appimage && $(MAKE) DBMS=$(DBMS) appimage

clean:
	-rm -rf build

debug:
	cmake --preset debug
	cmake --build --preset debug

package:
	git checkout-index --prefix=build/source/ -a
	cmake -Hbuild/source -Bbuild/package
	cd build/package && $(MAKE) package_source

release:
	cmake --preset release
	cmake --build --preset release

test:
	cmake --preset debug
	ctest --test-dir build/debug --output-on-failure
