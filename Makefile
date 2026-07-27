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
	rm -rf builds/AppDir/opt/dsgen
	mkdir -p builds/AppDir/opt
	cp -a builds/appimage/dsgen builds/AppDir/opt/dsgen
	builds/AppDir/usr/bin/dbt7-build-dsgen --patch-dir=patches \
			builds/AppDir/opt/dsgen
	sed -i -e "s#/usr#././#g" builds/AppDir/opt/dsgen/tools/dsdgen \
			builds/AppDir/opt/dsgen/tools/dsqgen
	cd builds/appimage && $(MAKE) DBMS=$(DBMS) appimage

clean:
	-rm -rf builds

debug:
	cmake --preset debug
	cmake --build --preset debug

package:
	git checkout-index --prefix=builds/source/ -a
	cmake -Hbuilds/source -Bbuild/package
	cd builds/package && $(MAKE) package_source

release:
	cmake --preset release
	cmake --build --preset release

test:
	cmake --preset debug
	ctest --test-dir builds/debug --output-on-failure
