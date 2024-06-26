.PHONY: appimage clean default debug dsgen-pgsql package release

default:
	@echo "targets: appimage (Linux only), clean, debug, package, release"

appimage:
	cmake -H. -Bbuilds/appimage -DCMAKE_INSTALL_PREFIX=/usr
	cd builds/appimage && make -s
	cd builds/appimage && make -s install DESTDIR=AppDir
	cd builds/appimage && make -s appimage-podman

clean:
	-rm -rf builds

debug:
	cmake -H. -Bbuilds/debug -DCMAKE_BUILD_TYPE=Debug
	cd builds/debug && make

dsgen-pgsql:
	cmake -H. -Bbuilds/appimage -DCMAKE_INSTALL_PREFIX=/usr
	cd builds/appimage && make -s
	cd builds/appimage && make -s install DESTDIR=AppDir
	mkdir -p /usr/local/AppDir/opt/
	cp -pr dsgen /usr/local/AppDir/opt/
	builds/appimage/AppDir/usr/bin/dbt7-build-dsgen --patch-dir=patches \
			/usr/local/AppDir/opt/dsgen
	cd builds/appimage && make -s appimage-podman

package:
	git checkout-index --prefix=builds/source/ -a
	cmake -Hbuilds/source -Bbuilds/source
	cd builds/source && make package_source

release:
	cmake -H. -Bbuilds/release
	cd builds/release && make
