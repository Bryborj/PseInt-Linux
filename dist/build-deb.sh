#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DIR"

VERSION=$(cat bin/version)
PKG_NAME="pseint_${VERSION}-1_amd64"
BUILD_DIR="build_deb/${PKG_NAME}"

echo "=== 1. Compilando PSeInt ==="
make ARCH=lnx -j$(nproc)

echo "=== 2. Preparando estructura de directorios Debian ==="
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/DEBIAN"
mkdir -p "$BUILD_DIR/usr/lib/pseint/bin"
mkdir -p "$BUILD_DIR/usr/bin"
mkdir -p "$BUILD_DIR/usr/share/applications"
mkdir -p "$BUILD_DIR/usr/share/pixmaps"
mkdir -p "$BUILD_DIR/usr/share/doc/pseint"

echo "=== 3. Copiando binarios y recursos ==="
cp -a bin/bin/* "$BUILD_DIR/usr/lib/pseint/bin/"
cp -a bin/creator.psz "$BUILD_DIR/usr/lib/pseint/"
cp -a bin/ejemplos "$BUILD_DIR/usr/lib/pseint/"
cp -a bin/help "$BUILD_DIR/usr/lib/pseint/"
cp -a bin/imgs "$BUILD_DIR/usr/lib/pseint/"
cp -a bin/Inconsolata-Regular.ttf "$BUILD_DIR/usr/lib/pseint/"
cp -a bin/perfiles "$BUILD_DIR/usr/lib/pseint/"
cp -a bin/pseint.dir "$BUILD_DIR/usr/lib/pseint/"
cp -a bin/version "$BUILD_DIR/usr/lib/pseint/"

# Wrappers
cat << 'EOF' > "$BUILD_DIR/usr/bin/pseint"
#!/bin/bash
exec /usr/lib/pseint/bin/pseint "$@"
EOF
chmod 0755 "$BUILD_DIR/usr/bin/pseint"

cat << 'EOF' > "$BUILD_DIR/usr/bin/wxpseint"
#!/bin/bash
exec /usr/lib/pseint/bin/wxPSeInt "$@"
EOF
chmod 0755 "$BUILD_DIR/usr/bin/wxpseint"

# Desktop file
cp dist/pseint.desktop "$BUILD_DIR/usr/share/applications/"

# Icons
for size in 16 32 48 64 128; do
    mkdir -p "$BUILD_DIR/usr/share/icons/hicolor/${size}x${size}/apps"
    cp -a "bin/imgs/icon${size}.png" "$BUILD_DIR/usr/share/icons/hicolor/${size}x${size}/apps/pseint.png"
done
cp -a bin/imgs/icon128.png "$BUILD_DIR/usr/share/pixmaps/pseint.png"
cp license.txt "$BUILD_DIR/usr/share/doc/pseint/copyright"

echo "=== 4. Creando archivo DEBIAN/control ==="
cat << EOF > "$BUILD_DIR/DEBIAN/control"
Package: pseint
Version: ${VERSION}-1
Section: devel
Priority: optional
Architecture: amd64
Depends: libwxgtk3.2-1t64 | libwxgtk3.2-1 | libwxgtk3.0-gtk3-0v5, libgl1, libglu1-mesa, libx11-6
Maintainer: Bryborj <git@github.com:Bryborj/PseInt-Linux>
Homepage: http://pseint.sourceforge.net/
Description: Tool for learning programming logic with Spanish pseudocode
 PSeInt is an educational tool designed for students starting out in
 programming. Through a simple and intuitive Spanish pseudocode, it allows
 them to focus on the fundamental concepts of computational algorithms.
EOF

echo "=== 5. Empaquetando .deb ==="
mkdir -p dist
dpkg-deb --build --root-owner-group "$BUILD_DIR" "dist/${PKG_NAME}.deb"
rm -rf build_deb

echo ""
echo "=== ¡Paquete .deb creado exitosamente! ==="
ls -lh "dist/${PKG_NAME}.deb"
