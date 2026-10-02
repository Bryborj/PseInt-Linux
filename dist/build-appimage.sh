#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DIR"

VERSION=$(cat bin/version)
APPDIR="AppDir"

echo "=== 1. Compilando PSeInt ==="
make ARCH=lnx -j$(nproc)

echo "=== 2. Preparando AppDir ==="
rm -rf "$APPDIR"
mkdir -p "$APPDIR/usr/lib/pseint/bin"
mkdir -p "$APPDIR/usr/bin"
mkdir -p "$APPDIR/usr/share/applications"
mkdir -p "$APPDIR/usr/share/icons/hicolor/128x128/apps"
mkdir -p "$APPDIR/usr/lib"

# Copiar binarios y recursos a usr/lib/pseint
cp -a bin/bin/* "$APPDIR/usr/lib/pseint/bin/"
cp -a bin/creator.psz "$APPDIR/usr/lib/pseint/"
cp -a bin/ejemplos "$APPDIR/usr/lib/pseint/"
cp -a bin/help "$APPDIR/usr/lib/pseint/"
cp -a bin/imgs "$APPDIR/usr/lib/pseint/"
cp -a bin/Inconsolata-Regular.ttf "$APPDIR/usr/lib/pseint/"
cp -a bin/perfiles "$APPDIR/usr/lib/pseint/"
cp -a bin/pseint.dir "$APPDIR/usr/lib/pseint/"
cp -a bin/version "$APPDIR/usr/lib/pseint/"

# Crear ejecutables y enlaces en usr/bin
cat << 'EOF' > "$APPDIR/usr/bin/pseint"
#!/bin/bash
HERE="$(dirname "$(readlink -f "${0}")")/../.."
exec "$HERE/usr/lib/pseint/bin/pseint" "$@"
EOF
chmod 0755 "$APPDIR/usr/bin/pseint"

cat << 'EOF' > "$APPDIR/usr/bin/wxpseint"
#!/bin/bash
HERE="$(dirname "$(readlink -f "${0}")")/../.."
exec "$HERE/usr/lib/pseint/bin/wxPSeInt" "$@"
EOF
chmod 0755 "$APPDIR/usr/bin/wxpseint"

# Iconos y .desktop en la raíz de AppDir y usr/share
cp dist/pseint.desktop "$APPDIR/pseint.desktop"
cp dist/pseint.desktop "$APPDIR/usr/share/applications/pseint.desktop"
cp bin/imgs/icon128.png "$APPDIR/pseint.png"
cp bin/imgs/icon128.png "$APPDIR/usr/share/icons/hicolor/128x128/apps/pseint.png"

# Copiar bibliotecas de wxWidgets para hacer el AppImage portable
echo "Copiando bibliotecas compartidas dependientes..."
for lib in $(ldd bin/bin/wxPSeInt 2>/dev/null | grep -E "libwx_" | awk '{print $3}'); do
    if [ -f "$lib" ]; then
        cp -L "$lib" "$APPDIR/usr/lib/" 2>/dev/null || true
    fi
done

# AppRun
cat << 'EOF' > "$APPDIR/AppRun"
#!/bin/bash
HERE="$(dirname "$(readlink -f "${0}")")"
export PATH="${HERE}/usr/bin:${PATH}"
export LD_LIBRARY_PATH="${HERE}/usr/lib:${HERE}/usr/lib/x86_64-linux-gnu:${LD_LIBRARY_PATH}"
export XDG_DATA_DIRS="${HERE}/usr/share:${XDG_DATA_DIRS}"

if [ "$(basename "$0")" = "pseint" ]; then
    exec "${HERE}/usr/lib/pseint/bin/pseint" "$@"
else
    exec "${HERE}/usr/lib/pseint/bin/wxPSeInt" "$@"
fi
EOF
chmod 0755 "$APPDIR/AppRun"

echo "=== 3. Obteniendo appimagetool si no existe ==="
if ! command -v appimagetool >/dev/null 2>&1; then
    if [ ! -f "appimagetool" ]; then
        curl -sL -o appimagetool "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
        chmod +x appimagetool
    fi
    APPIMAGETOOL="./appimagetool"
else
    APPIMAGETOOL="appimagetool"
fi

echo "=== 4. Generando AppImage ==="
mkdir -p dist
ARCH=x86_64 "$APPIMAGETOOL" --appimage-extract-and-run "$APPDIR" "dist/PSeInt-${VERSION}-x86_64.AppImage"
rm -rf "$APPDIR"

echo ""
echo "=== ¡AppImage generado exitosamente! ==="
ls -lh "dist/PSeInt-${VERSION}-x86_64.AppImage"
